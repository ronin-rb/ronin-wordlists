# ronin-wordlists

[![CI](https://github.com/ronin-rb/ronin-wordlists/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-wordlists/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-wordlists.svg)](https://codeclimate.com/github/ronin-rb/ronin-wordlists)

* [Website](https://ronin-rb.dev/)
* [Source](https://github.com/ronin-rb/ronin-wordlists)
* [Issues](https://github.com/ronin-rb/ronin-wordlists/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-wordlists/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |

## Description

ronin-wordlists is a library and tool for managing wordlists. ronin-wordlists
can install and update wordlists, and contains a curated list of popular
wordlists and their download URLs.

## Features

* Installs, updates, and manages wordlist files and Git repositories.
* Contains a curated list of popular wordlists and their download URLs.
* Allows looking wordlists up by name, instead of explicit path.
* Supports searching for wordlists in `/usr/share/wordlists` (Kali Linux),
  `/usr/local/wordlists`, and `~/.cache/ronin-wordlists/wordlists` directories.

## Synopsis

```shell
$ ronin-wordlists
Usage: ronin-wordlists [options]

Options:
    -V, --version                    Prints the version and exits
    -h, --help                       Print help information

Arguments:
    [COMMAND]                        The command name to run
    [ARGS ...]                       Additional arguments for the command

Commands:
    download
    help
    list, ls
    purge
    remove, rm
    update, up
```

Download a known wordlist:

```shell
$ ronin-wordlists download rockyou
```

Download a wordlist from a URL:

```shell
$ ronin-wordlists download https://example.com/path/to/wordlist.gz
```

Update all downloaded wordlists:

```shell
$ ronin-wordlists update
```

Update a specific wordlist:

```shell
$ ronin-wordlists update SecLists
```

## Examples

Open a wordlist by name:

```ruby
require 'ronin/wordlists'

wordlist = Ronin::Wordlists.open('alexa-top-1000')
# =>
# #<Wordlist::File:0x00007f7b548bf840                     
#  @format=:txt,                                          
#  @path="/home/ronin/.cache/ronin-wordlists/wordlists/alexa-top-1000.txt">

wordlist.each do |word|
  # ...
end
```

Download a custom wordlist into `~/.cache/ronin-wordlists/wordlists`:

```ruby
Ronin::Wordlists.download('https://...')
```

List installed wordlists:

```ruby
Ronin::Wordlists.list
# =>  #<Set: {"alexa-top-1000.txt", "rockyou.txt", ...}>
```

## Requirements

* [Ruby] >= 3.0.0
* [wordlist] ~> 1.0
* [ronin-core] ~> 0.1

## Install

```shell
$ gem install ronin-wordlists
```

### Gemfile

```ruby
gem 'ronin-wordlists', '~> 0.1'
```

### gemspec

```ruby
gem.add_dependency 'ronin-wordlists', '~> 0.1'
```

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-wordlists/fork)
2. Clone It!
3. `cd ronin-wordlists/`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)

ronin-wordlists is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-wordlists is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-wordlists.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[wordlist]: https://github.com/postmodern/wordlist.rb#readme
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
