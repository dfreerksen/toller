# Toller

URL based filtering and sorting. See the wiki for usage information.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'toller'
```

And then execute:

```bash
$ bundle install
```

## Filtering

Filters are not automagically set up for you. You define the filters you want.

### Filter Types

* integer - Filter on an integer column
* boolean - Filter on a boolean column
* string - Filter on a string column
* text - Filter on a text column
* date - Filter on a date column
* time - Filter on a time column
* datetime - Filter on a datetime column
* scope - Filter on an ActiveRecord scope

## Sort

Sorting is not automagically set up for you. You define the sorting you want.

Sort parameters are passed in the URL as such `?sort=position`. Multiple sort parameters can be passed like so `?sort=-published_at,title`.

### Sort Types

Every sort must have a type. Valid sort types are:

* integer - Sort on an integer column
* string - Sort on a string column
* text - Sort on a text column
* date - Sort on a date column
* time - Sort on a time column
* datetime - Sort on a datetime column
* scope - Sort on an ActiveRecord scope

## Testing

```bash
$ bin/test
```

## Contributing

1. Fork it ([https://github.com/dfrerksen/recieve/fork](https://github.com/dfrerksen/recieve/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
