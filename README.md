# Skoob Exporter

Skoob has no public API and does not provide an easy way to export your books to
other social networks like Goodreads.

To fix that, this project gets information about all your books and generates
a csv file in the format Goodreads expect, so you can easily
[import it here](https://www.goodreads.com/review/import).

**[Check the website](http://skoob-exporter.colabs.dev)**

# Dependencies

* Ruby `2.3.2`
* Rails `5.0.0.1`
* Postgress `9.6.1`

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
the command to generate the csv.

# How to run in the web

Access the root url and provide your skoob credentials. Once you submit, you
will be redirected to a page that will wait until the process is over. It will
hold the user there and be pooling from time to time. When all books are imported,
it will generate the .csv file and the browser will download it.
