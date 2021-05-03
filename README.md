# job-hunter

App for serving job search results for a location.

## Development

### Local environment setup

#### Install Ruby dependencies

```
bundle install
```

#### Setup database

The app uses SQLite as database. Run the migrations:
```
rails db:migrate
```

#### Start the server

```
rails s
```

### Running tests

Tests are run using [rpsec-rails](https://github.com/rspec/rspec-rails). To execute tests, run:

```
bundle exec rspec
```
