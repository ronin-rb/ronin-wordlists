# ronin-wordlists 1 "2023-01-01" Ronin Wordlists "User Manuals"

## SYNOPSIS

`ronin-wordlists` [*options*] [*COMMAND*]

## DESCRIPTION

Command suite that manages wordlists.

## ARGUMENTS

*COMMAND*
	The `ronin-wordlists` command to execute.

## OPTIONS

`-h`, `--help`
  Prints help information.

## COMMANDS

`download`
  Downloads a wordlist.

`list`, `ls`
  Lists downloaded wordlists.

`purge`
  Deletes all downloaded wordlists.

`remove`, `rm`
  Deletes a downloaded wordlist.

`update`, `up`
  Updates one or all downloaded wordlists.

## FILES

`~/.cache/ronin-wordlists`
	Default installation directory for wordlists.

## ENVIRONMENT

*HOME*
	Specifies the home directory of the user. Ronin will search for the
	`~/.cache/ronin-wordlists` cache directory within the home directory.

*XDG_CACHE_HOME*
    Specifies the cache directory to use. Defaults to `$HOME/.cache`.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-wordlists-download(1) ronin-wordlists-list(1) ronin-wordlists-remove(1) ronin-wordlists-update(1) ronin-wordlists-purge(1)
