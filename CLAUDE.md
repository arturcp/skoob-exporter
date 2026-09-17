# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

⚠️ This project is currently non-functional: Skoob added a captcha to its login page that
blocks the Mechanize-based login flow (see README.md). Any work here is either about
restoring that flow or is unrelated maintenance — don't assume login/import works end-to-end.

## Commands

```
bundle install
bin/rake db:create db:migrate      # requires Postgres running (docker compose up)
bin/rails s                        # web server
bin/sidekiq                        # background worker (or: bundle exec sidekiq)
docker compose up                  # Postgres + Redis for local dev
bundle exec rspec                  # full test suite
bundle exec rspec spec/models/skoob_spec.rb        # single file
bundle exec rspec spec/models/skoob_spec.rb:12     # single example by line
```

Console-driven import/export (no web server needed):
```
bin/rake skoob:import              # prompts for Skoob email/password, imports publications
bin/rake skoob:csv:generate <skoob_user_id>   # prints the Goodreads-format CSV
bin/rake skoob:cleanup             # deletes publications older than 1 day (scheduled daily at 3am UTC)
bin/rake skoob:cleanup_user EMAIL=<email>     # deletes a SkoobUser and their data
```

CI (CircleCI, `.circleci/config.yml`) runs `bundle exec rspec` against a Postgres 9 service
container on Ruby 3.2.2.

## Architecture

This is a Rails 7 app with one job: log into a user's Skoob account, scrape their book/comic/
magazine shelves, and export them as a Goodreads-importable CSV.

**Two entry points, same pipeline:**
- Web: `CrawlersController#create` (`POST /importar`) logs the user in, kicks off
  `SkoobImporterJob` on Sidekiq, and redirects to a polling page (`crawlers#show`) that the
  frontend (`app/javascript/lib/import-status.js`) polls via `StatusController` (`/status/:id`)
  until `import_status` flips back to `0`. `ExporterController#show` (`/exporter/:id`) then
  streams the CSV.
- Console: `lib/tasks/skoob.rake` (`skoob:import` / `skoob:csv:generate`) runs the same
  `SkoobUser.login` → `Skoob.fetch_publications!` → `Exporter#generate_csv` pipeline
  synchronously in a rake task, for use without the web/worker stack.

**Scraping pipeline** (`app/models`):
- `SkoobUser.login` uses Mechanize to fill and submit the Skoob login form, then extracts the
  numeric `skoob_user_id` from the post-login redirect URL. This is the step broken by Skoob's
  captcha.
- `Skoob.fetch_publications!(user)` is the pipeline entry point; it wraps the import in
  `user.import_library` which tracks `import_status` (0 = idle, 1 = importing) and
  `not_imported` (duplicates) on the `SkoobUser` record — this is what the status-polling UI
  reads.
- `Publications#import` hits Skoob's internal JSON API (`SkoobUrls`, undocumented endpoints
  under `/v1/bookcase/...`) once per shelf type (books/comics/magazines), paginating until a
  page comes back empty. For each item it also does a second Mechanize `GET` per publication
  page to scrape the ISBN out of a meta tag (`fetch_isbn`), which is slow — this is the "Skoob
  performance warning" mentioned in `.env.example` (`SHOW_SKOOB_PERFORMANCE_WARNING`).
  Already-imported publications (by `skoob_user_id` + `skoob_publication_id`) are skipped and
  reported back as duplicates rather than re-saved.
- `Exporter#generate_csv` reads `Publication` rows for a `skoob_user_id` and writes them out in
  the exact column layout Goodreads' bulk import expects (see README for the goodreads import
  URL); columns Goodreads doesn't get data for (average rating, binding, bookshelves, review)
  are left blank.
- `Publication` rows are transient: they exist only to bridge import → CSV generation and are
  purged by the daily `skoob:cleanup` rake task (scheduled externally at 3am UTC), not by app
  code.

**Cross-cutting:**
- `Slack::Message.send` posts operational notifications (import started, import failed, CSV
  exported, cleanup ran) to Slack via `SLACK_WEBHOOK`/`SLACK_CHANNEL`; it's a no-op if no
  webhook is configured, and is skipped entirely in the test environment where it matters
  (`SkoobUser.login`'s rescue).
- Sidekiq runs with concurrency 1 in production (`config/sidekiq.yml`) and jobs are configured
  with `retry: 0, dead: false` — a failed import is not retried or kept in the dead set.
