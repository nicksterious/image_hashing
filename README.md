# ImageHashing

This gem generates hopefully unique image hashes based on pHash and RGB color histograms. You can persist these in your database where you keep track of your images, and use them to query for duplicates as new images are added.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'image_hashing'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install image_hashing

## Usage

```
file_name = "image1.webp"

require "image_hashing"

hasher = ImageHash::ImageHash.new(file_name)
puts hasher.generate
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/image_hashing.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
