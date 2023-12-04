# ronin-wordlists-list 1 "2023-01-01" Ronin Wordlists "User Manuals"

## SYNOPSIS

`ronin-wordlists` `list` [*options*] [*NAME*]

## DESCRIPTION

Lists the downloaded wordlists.

## ARGUMENTS

*NAME*
: The optional name of the wordlist to search for.

## OPTIONS

`-d`, `--wordlist-dir` *DIR*
: The alternative wordlist directory to search.

`-a`, `--available`
: Lists built-in wordlists that are available for download.

`-h`, `--help`
: Prints help information.

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

[ronin-wordlists-download](ronin-wordlists-download.1.md) [ronin-wordlists-list](ronin-wordlists-list.1.md) [ronin-wordlists-remove](ronin-wordlists-remove.1.md) [ronin-wordlists-update](ronin-wordlists-update.1.md)