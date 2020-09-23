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

## Contributing

1. Fork it ([https://github.com/dfrerksen/recieve/fork](https://github.com/dfrerksen/recieve/fork))
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
