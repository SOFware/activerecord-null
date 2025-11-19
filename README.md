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

Customize the null class name:

```ruby
class User < ApplicationRecord
  Null(class_name: "Guest")
  class << self
    alias_method :null, :guest
  end
end

User.guest # returns a User::Guest instance
```

### Void Objects

While `Null` objects are singletons (one instance per model), `Void` objects are instantiable null objects that allow creating multiple instances with different attribute values.

Define a void object for the model:

```ruby
class Product < ApplicationRecord
  Void([:name] => "Unknown Product") do
    def display_name
      "Product: #{name}"
    end
  end
end
```

Create instances with custom attributes:

```ruby
product1 = Product.void(name: "Widget")
product2 = Product.void(name: "Gadget")

product1.name # => "Widget"
product2.name # => "Gadget"
```

Each call to `.void` returns a new instance:

```ruby
Product.void.object_id != Product.void.object_id # => true
```

Instance attributes override defaults:

```ruby
product = Product.void(name: "Custom")
product.name # => "Custom" (overrides default "Unknown Product")

default_product = Product.void
default_product.name # => "Unknown Product" (uses default)
```

Void objects support the same features as Null objects:
- Callable defaults (lambdas/procs)
- Custom methods via block syntax
- Association handling
- All ActiveRecord query methods (`null?`, `persisted?`, etc.)
- Custom class names via `class_name:` parameter

```ruby
class Product < ApplicationRecord
  Void(class_name: "Placeholder")
  class << self
    alias_method :void, :placeholder
  end
end

Product.placeholder # returns a Product::Placeholder instance
```

Use `Null` when you need a single shared null object instance. Use `Void` when you need multiple null object instances with different attribute values.

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
