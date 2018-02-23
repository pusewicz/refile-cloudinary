# Refile::Cloudinary

This gem adds [Cloudinary](https://cloudinary.com) as storage backend to Refile.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'refile-cloudinary', github: 'pusewicz/refile-cloudinary'
```

And then execute:

```rb
bundle install
```

## Usage

If your not have your Refile properly configured follow this link: https://github.com/refile/refile, then so to use this gem you have to configure your config/initializer in your rails application:

```rb
require "refile/cloudinary"

cloudinary = {
    cloud_name: "cloud_name",
    api_key: "api_key",
    api_secret: "api_secret",
}

Refile.cache = Refile::Cloudinary.new({**cloudinary }, max_size: nil)
Refile.store = Refile::Cloudinary.new({**cloudinary }, max_size: nil)
```

after this, restart your server and you can see that your cloudinary receive your file that you upload.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pusewicz/refile-cloudinary.
