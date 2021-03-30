# Heroku

Skoob-exporter is hosted in two different environments.

To prepare your git configuration to deploy to them, follow these steps:

1. Production

Log into your personal heroku account and run:

```
git remote add heroku-personal https://git.heroku.com/skoob-export.git
```

Then:

```
git push heroku-personal master
```

2. Stage

Log into the staging heroku account and run:

```
git remote add heroku-stage https://git.heroku.com/skoob-export.git
```

Then:

```
git push heroku-stage master
```

# Heroku commands

Because you will have more than one Heroku remotes in your git configuration, you need to explicitly provide the app during all heroku's commands:

```
heroku logs --tail --app <name of the app>
```

or

```
heroku logs --tail --remote heroku-stage
```
