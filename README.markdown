# Yajl - Version 0.2.1

Yet another JSON logger. I like Ruby's logger, but it's annoying to
always set it up. I like flexible, machine and human readable logs.
I want simplicity and brevity. I want to dump JSON in my logs
without screwing around, and I want to be able to easily log text.

## TODOs

1. Tests. I guess. Maybe.
2. Maybe rewrite this in [Nim](http://nim-lang.org/) and wrap it in the Ruby FFI. I'd have to be logging a *lot* to justify it though.
3. Maybe make it Windows friendly. (Not sure how to handle newlines for Windows).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yajl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yajl

## Usage

```ruby
require 'yajl'

logger = Yajl.create_logger
logger.warn "danger"
```

Will produce the following
(although it has been pretty printed for readability):

```json
{
	"id": "44fa7a8f0186092d849ac1ea263ceb3f",
	"severity": "WARN",
	"datetime": "2015-08-24 18:22:12 UTC",
	"progname": null,
	"message": {
		"text": "danger"
	}
}
```

You can also log data structures:

```ruby
require 'yajl'

logger = Yajl.create_logger
interesting_data = { banana_count: 2345, text: "So many bananas!" }
logger.info interesting_data
```

Which produces:

```json
{
	"datetime": "2015-08-24 18:43:24 UTC",
	"id": "4ae209a739a7bb562d7b55dfba88fc4e",
	"message": {
		"banana_count": 2345,
		"text": "So many bananas!"
	},
	"progname": null,
	"severity": "INFO"
}
```

And because it is just a normal Ruby logger, you can also do:

```ruby
require 'yajl'

logger = Yajl.create_logger
logger.fatal("deathstar") { "Nooooo" }
```

Which sets the `progname` attribute.

```json
{
	"datetime": "2015-08-24 18:48:37 UTC",
	"id": "3e6dfcc2038dd0dec5e4be21574cb76d",
	"message": {
		"text": "Nooooo"
	},
	"progname": "deathstar",
	"severity": "FATAL"
}
```

By default logs are stored in `~/logs` with a very sensible
logger name. If even one person wants the ability to change the
filename that is set I'll add the support to do so. Right now it
looks like this (Where `yajl` would be the name of whatever git
repo you are using):

`/home/zach/logs/zach@Lux.yajl.log`

or like this:

`/home/zach/logs/zach@Lux.yajl.log.1`

If there are multiple running processes (just like the normal Ruby
processor).

Note, it gets the name of the project from your Git project name.
If you don't use Git let me know and I'll make this toggleable too.

## Development

After checking out the repo, run `bin/setup` to install
dependencies. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run
`bundle exec rake install`.

### Stuff that only I need to do

To release a new version, update the version number in
`version.rb`, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and tags,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/zachaysan/yajl. Matz is nice. Be like Matz.

## License

The gem is available as open source under the terms of the
[MIT License](http://opensource.org/licenses/MIT).
