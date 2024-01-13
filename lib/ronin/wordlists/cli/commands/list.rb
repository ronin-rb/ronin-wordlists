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

require 'ronin/wordlists/cli/command'
require 'ronin/wordlists/cli/wordlist_dir_option'
require 'ronin/wordlists'

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Lists installed wordlists on the system.
        #
        # ## Usage
        #
        #     ronin-wordlists list [options] [NAME]
        #
        # ## Options
        #
        #     -d, --wordlist-dir DIR           The wordlist directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     [NAME]                           Optional wordlist name to search for
        #
        class List < Command

          include WordlistDirOption

          usage '[options] [NAME]'

          argument :name, required: false,
                          usage:    'NAME',
                          desc:     'Optional wordlist name to search for'

          description 'Lists installed wordlists on the system'

          man_page 'ronin-wordlists-list.1'

          #
          # Runs the `ronin-wordlists list` command.
          #
          # @param [String, nil] name
          #   The optional wordlist name.
          #
          def run(name=nil)
            wordlists = if name then wordlist_dir.list(name)
                        else         wordlist_dir.list
                        end

            wordlists.each do |wordlist|
              puts "  #{wordlist}"
            end
          end

        end
      end
    end
  end
end
