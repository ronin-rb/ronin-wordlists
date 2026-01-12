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

require 'ronin/wordlists/cli/command'
require 'ronin/wordlists/cli/wordlist_dir_option'

require 'ronin/core/cli/logging'

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Removes a wordlist from the cache directory.
        #
        # ## Usage
        #
        #     ronin-wordlists remove [options] NAME
        #
        # ## Options
        #
        #     -d, --wordlist-dir DIR           The wordlist directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     NAME                             The wordlist to remove
        #
        class Remove < Command

          include WordlistDirOption
          include Core::CLI::Logging

          usage '[options] NAME'

          argument :name, required: true,
                          desc:     'The wordlist to remove'

          description 'Deletes a wordlist from the cache directory'

          man_page 'ronin-wordlists-remove.1'

          #
          # Runs the `ronin-wordlists remove` command.
          #
          def run(name)
            wordlist_dir.remove(name)
          rescue WordlistNotFound
            print_error "no such wordlist: #{name}"
            exit(1)
          end

        end
      end
    end
  end
end
