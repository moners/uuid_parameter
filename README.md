# UUIDParameter

The `UUIDParameter` module provides support for UUIDs in `ActiveRecord` models.

It takes care of generating (if one was not provided), validating, and keeping
this UUID intact, protecting the `:uuid` field from being changed once set.

Models including the `UUIDParameter` module will:
- use their `:uuid` rather than their `:id` (primary key) for URLs.
- accept an given UUID on creation to allow offline resource generation.

### Features

- Can be used with existing models (simply add a `uuid` column).
- Does not affect existing primary key.
- Can accept any valid random UUID (version 4) provided externally.
- Automatically generates a UUID on `:create` if one is not set.
- Only works with UUID version 4 (random).
- Prevents changing the UUID once set.
- Silently ignores any attempt at changing a set UUID.
- Overrides `:to_param` to provide the UUID instead of the primary key.

## Usage

Add a `uuid` column to your model if it does not have one already:
``` bash
$ rails g migration AddUuidColumnToUser uuid:string{36}
$ rails db:migrate
```

If you're using Postgres, you should use the native `uuid` type instead:
``` bash
$ rails g migration AddUuidColumnToUser uuid:uuid
$ rails db:migrate
```

Then, simply include the module in your model:
``` ruby
class User < ApplicationRecord
  include UUIDParameter
end

# u = User.create  # Generates a new UUID
# u.id             # => 123 (does not change primary key)
# u.uuid           # => '8bb27724-7439-4965-9598-883419179b21'
# u.to_param       # => '8bb27724-7439-4965-9598-883419179b21'
# u.uuid = SecureRandom.uuid
# u.save           # Silently ignores changes to :uuid
# u.reload         # Instead, it restores the original:
# u.uuid           # => '8bb27724-7439-4965-9598-883419179b21'
```

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'uuid_parameter'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install uuid_parameter
```

## Contributing

Bug reports and pull requests are welcome on Gitlab at
https://gitlab.com/incommon.cc/uuid_parameter.

The [Github repository] is a mirror to facilitate integration with other Rails
development, but I don't like Microsoft, and never will. They may show the face
they like, they come from enemity and, as far as I'm concerned, will remain
there.

[Github repository]: https://github.com/moners/uuid_parameter

# Development

After checking out the repo, run `bin/setup` to install dependencies.
Run specifications with `bundle exec rake`.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).
See `bundle exec rake -T` for more options.

## License

This gem is free software under the same [license] terms as Rails.

[license]: ./LICENSE
