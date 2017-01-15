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

# How to run

Adjust your email and password in the env variables, go to the terminal and
run:

```
  bin/rake skoob:import
```
