# frozen_string_literal: true
#
# ronin-wordlists - A library and tool for managing wordlists.
#
# Copyright (c) 2023-2024 Hal Brodigan (postmodern.mod3@gmail.com)
#
# ronin-wordlists is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-wordlists is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-wordlists.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/wordlists/cache_dir'
require 'ronin/wordlists/search_paths'

module Ronin
  #
  # Top-level methods for `ronin-wordlists`.
  #
  module Wordlists
    @cache_dir    = CacheDir.new
    @search_paths = SearchPaths[
      @cache_dir.wordlist_dir.path,
      '/usr/local/share/wordlists',
      '/usr/share/wordlists'
    ]

    #
    # Downloads a new wordlist.
    #
    # @param [String, URI::HTTP] url
    #   The URL of the wordlist to download.
    #
    # @api public
    #
    def self.download(url)
      @cache_dir.download(url)
    end

    #
    # Finds a wordlist.
    #
    # @param [String] name
    #   The wordlist file name.
    #
    # @return [String, nil]
    #   The path to the wordlist file.
    #
    # @api public
    #
    def self.find(name)
      @search_paths.find(name)
    end

    #
    # Lists all wordlists on the system.
    #
    # @param [String] pattern
    #   Optional glob pattern to search for within the wordlist directory.
    #
    # @return [Set<String>]
    #   The wordlist files within the wordlist directories.
    #
    # @api public
    #
    def self.list(pattern='*')
      @search_paths.list(pattern)
    end

    #
    # Opens a wordlist.
    #
    # @param [String] name
    #   The wordlist file name.
    #
    # @return [Wordlist::File]
    #   The opened wordlist file.
    #
    # @raise [WordlistNotFound]
    #   No wordlist with the given name.
    #
    # @api public
    #
    def self.open(name)
      @search_paths.open(name)
    end
  end
end
