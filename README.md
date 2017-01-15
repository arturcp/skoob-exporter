# Skoob Exporter

Skoob has no public API and does not provide an easy way to export your books to
other social networks like Good Reads.

To fix that, this project gets information about all your books and generates
a csv file in the format Good Reads expect, so you can easily import it there.

# Dependencies

* Ruby `2.3.2`
* Rails `5.0.0.1`
* Postgress `9.6.1`

To prepare your project, adjust your database configurations on db/database.yml
and run on the therminal:

```
  bundle install
  bin/rake db:create db:migrate
```

# How to run in the console

Adjust your email and password in the env variables, go to the terminal and
run:

```
  bin/rake skoob:import
```
At the end of the script, it will provide your skoob id. It is a number like
`999999`. To generate your csv file, execute:

```
  bin/rake skoob:csv::generate 999999
```
Remember to replace `999999` with your skoob id. The task `skoob:import` must
be executed before the `skoob:csv:generate`.

# How to run in the web

Access the root url and provide your skoob credentials. Once you submit, you
will be redirected to a page that will wait until the process is over. It will
hold the user there and be pooling from time to time. When all books are imported,
it will generate the .csv file and the browser will download it.
