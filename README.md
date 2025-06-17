# ActiveRecord::Null

Create null objects for ActiveRecord models.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add activerecord-null

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install activerecord-null

## Usage

Extend your primary abstract class with `ActiveRecord::Null`.

```ruby
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  extend ActiveRecord::Null
end
```

Define a null object for the model.

```ruby
class User < ApplicationRecord
  has_many :posts
  Null do
    def name = "None"
  end
end
```

This will create a Singleton class `User::Null` that mimics the `User` class.

Use the null object.

```ruby
User.null
```

It will even work with associations.

```ruby
User.null.posts # => []
```

By default, the null object will have the same attributes as the original model and will return `nil` for all attributes.

You can override this by passing a hash to the `Null` method where the key is an array of attributes and the value is the value to return for the attribute.

```ruby
class User < ApplicationRecord
  Null([:name, :team_name] => "Unknown") do
    def other_attribute = "Other"
  end
end
```

You may also pass a callable to the hash which will be used to determine the value for the attribute.

```ruby
class User < ApplicationRecord
  Null([:name, :team_name] => -> { "Unknown" })
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Releasing

Run `rake build:checksum` to build the gem and generate the checksum. This will also update the version number in the gemspec file.

Run `rake release` to create a git tag for the version, push git commits and tags, and push the .gem file to rubygems.org.

This will leave a new commit with the version number incremented in the version file and the changelog updated with the new version. Push the changes to the repository.

## Contributing

This gem is managed with [Reissue](https://github.com/SOFware/reissue).

Bug reports and pull requests are welcome on GitHub at https://github.com/SOFware/activerecord-null.
