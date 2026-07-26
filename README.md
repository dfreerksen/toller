# Toller

URL-query-param-based filtering and sorting for Rails controllers.

Toller is a Rails engine that lets controllers declare filter_on/sort_on directives, then applies whichever filters and sorts are active for the current request to an ActiveRecord relation based on URL query parameters.

See the [wiki](https://github.com/dfreerksen/toller/wiki) for usage information.

## Requirements

* Ruby >= 3.3.0
* Rails >= 6.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'toller', '~> 1.1'
```

And then execute:

```bash
$ bundle install
```

## Filtering

Filters are not automagically set up for you. You define the filters you want.

Filtering parameters are passed in the URL as such `?filters[visible]=1`. Multiple filter parameters can be passed like so `?filters[visible]=1&filters[published_after]=2020-07-04`.

More information is [available in the wiki](https://github.com/dfreerksen/toller/wiki/Filter).

## Sorting

Sorting is not automagically set up for you. You define the sorting you want.

Sorting parameters are passed in the URL as such `?sort=position`. Multiple sort parameters can be passed like so `?sort=-published_at,title`.

More information is [available in the wiki](https://github.com/dfreerksen/toller/wiki/Sort).

## Testing

```bash
$ bin/test
```

### Appraisal

Uses [Appraisal2](https://github.com/appraisal-rb/appraisal2) (a maintained fork of [Appraisal](https://github.com/thoughtbot/appraisal), still exposing the `appraisal` executable) to ensure various dependency versions work as expected

When dependencies change, run

```bash
$ bundle exec appraisal install
$ bundle exec appraisal generate-install
```

To run tests with Appraisal, run

```bash
$ bundle exec appraisal rspec
```

`-n 1` forces Appraisal2 to run one Rails version at a time. Without it, Appraisal2 defaults to running 2 appraisals in parallel, and since every appraisal shares the same `test/dummy/db/test.sqlite3` file, concurrent runs can intermittently fail with `SQLite3::BusyException: database is locked`.

```bash
$ bundle exec appraisal rails-6-0 rspec
$ bundle exec appraisal rails-6-1 rspec
$ bundle exec appraisal rails-7-0 rspec
$ bundle exec appraisal rails-7-1 rspec
$ bundle exec appraisal rails-7-2 rspec
$ bundle exec appraisal rails-8-0 rspec
$ bundle exec appraisal rails-8-1 rspec
```

## Release

See [Release.md](docs/Release.md)

## Code Analysis

Various tools are used to ensure code is linted and formatted correctly.

### RuboCop

[RuboCop](https://github.com/bbatsov/rubocop) is a Ruby static code analyzer.

```bash
$ rubocop
```

### YARD-Lint

[YARD-Lint](https://github.com/mensfeld/yard-lint) is a linter for YARD documentation.

```bash
$ bundle exec yard-lint
```

## Documentation

[Yard](https://github.com/lsegal/yard) is used to generate documentation. [Online documentation is available](http://www.rubydoc.info/github/dfreerksen/toller/master)

Build the documentation with one of the following

```bash
$ yard
$ yard doc
```

Build the documentation and list all undocumented objects

```bash
$ yard stats --list-undoc
```

## Contributing

1. Fork it ([https://github.com/dfrerksen/toller/fork](https://github.com/dfrerksen/toller/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
