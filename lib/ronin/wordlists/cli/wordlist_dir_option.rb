# frozen_string_literal: true
#
# ronin-wordlists - A library and tool for managing wordlists.
#
# Copyright (c) 2023-2026 Hal Brodigan (postmodern.mod3@gmail.com)
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
require 'ronin/wordlists/wordlist_dir'

module Ronin
  module Wordlists
    class CLI
      #
      # Adds the `--wordlist-dir DIR` option to a command.
      #
      module WordlistDirOption
        #
        # Adds the `--wordlist-dir DIR` option to the command including
        # {WordlistDirOption}.
        #
        # @param [Class<Command>] command
        #   The command class including {WordlistDirOption}.
        #
        def self.included(command)
          command.option :wordlist_dir, short: '-d',
                                        value: {
                                          type: String,
                                          usage: 'DIR'
                                        },
                                        desc: 'The wordlist directory'
        end

        #
        # The wordlist directory.
        #
        # @return [CacheDir, WordlistDir]
        #   The {WordlistDir} if the `--wordlist-dir` option was specified or
        #   {CacheDir}.
        #
        def wordlist_dir
          @wordlist_dir ||= if options[:wordlist_dir]
                              WordlistDir.new(options[:wordlist_dir])
                            else
                              CacheDir.new
                            end
        end
      end
    end
  end
end
