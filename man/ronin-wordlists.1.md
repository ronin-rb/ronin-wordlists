# ronin-wordlists 1 "2023-01-01" Ronin Wordlists "User Manuals"

## SYNOPSIS

`ronin-wordlists` [*options*] [*COMMAND*]

## DESCRIPTION

Command suite that manages wordlists.

## ARGUMENTS

*COMMAND*
: The `ronin-wordlists` command to execute.

## OPTIONS

`-h`, `--help`
: Prints help information.

## COMMANDS

`search`
: Lists wordlists available for download or installation.

`completion`
: Manages the shell completion rules for `ronin-wordlists`.

`download`
: Downloads a wordlist.

`list`, `ls`
: Lists downloaded wordlists.

`purge`
: Deletes all downloaded wordlists.

`remove`, `rm`
: Deletes a downloaded wordlist.

`update`, `up`
: Updates one or all downloaded wordlists.

## FILES

`~/.cache/ronin-wordlists`
: Default installation directory for wordlists.

## ENVIRONMENT

*HOME*
: Specifies the home directory of the user. Ronin will search for the
  `~/.cache/ronin-wordlists` cache directory within the home directory.

*XDG_CACHE_HOME*
: Specifies the cache directory to use. Defaults to `$HOME/.cache`.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-wordlists-search](ronin-wordlists-search.1.md) [ronin-wordlists-completion](ronin-wordlists-completion.1.md) [ronin-wordlists-download](ronin-wordlists-download.1.md) [ronin-wordlists-list](ronin-wordlists-list.1.md) [ronin-wordlists-remove](ronin-wordlists-remove.1.md) [ronin-wordlists-update](ronin-wordlists-update.1.md) [ronin-wordlists-purge](ronin-wordlists-purge.1.md)
