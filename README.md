# Skoob Exporter

[Skoob](https://skoob.com.br/) has no public API and does not provide an easy way to export your publications (books, comics, and magazines) to other social networks like [Goodreads](https://www.goodreads.com/).

To fix that, this project imports all publications from your Skoob account and generates
a CSV file in the format that Goodreads expect, so you can easily
[import it here](https://www.goodreads.com/review/import).

**[Check the website](http://skoob-exporter.colabs.dev)**

# Dependencies

- Ruby `3.2.2`
- Rails `7.0.5.1`
- Postgress `9.6.1`

To prepare your project, adjust your database configurations on `db/database.yml`
and run on the terminal:

```
  bundle install
  bin/rake db:create db:migrate
```

# How to run in the console

Go to the terminal and run:

```
  bin/rake skoob:import
```

Provide your Skoob credentials and wait.

At the end of the script, it will provide your skoob id. It is a number like
`999999`. To generate your csv file, execute:

```
  bin/rake skoob:csv::generate 999999
```

Remember to replace `999999` with your skoob id. The instructions to generate the
csv will also be provided by the skoob:import task, so you don't need to remember
the command to generate the CSV.

# How to run in the web

Access the root url and provide your skoob credentials. Once you submit, you
will be redirected to a page that will wait until the process is over. It will
hold the user there and be pooling from time to time. When all publications are imported,
it will generate the CSV file and the browser will download it.

# How to run it locally

- Start the redis:

```
redis
```

- start sidekiq

```
bundle exec sidekiq
```

or

```
bin/sidekiq
```

- start the database

```
docker compose up
```

- start the server

```
bin/rails s
```

# Clean up job

When a user imports publications, each one of them will be saved into the `publications` table. This table is going to be used to generate the CSV file. After the CSV is generated, the publications are not needed anymore. To clean up the database, run:

```
bin/rake skoob:clean_up
```

This will delete publications older than 1 day ago (or publications that have no `created_at` set. That happens because the timestamp was added with the website up and running, so any book created pior to the timestamp migration will have `null` as the created_at value).

The clean up job is scheduled to run every day at 3am (UTC).
