# frozen_string_literal: true
#
# ronin-wordlists - A library and tool for managing wordlists.
#
# Copyright (c) 2023 Hal Brodigan (postmodern.mod3@gmail.com)
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

require 'yaml'

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Lists wordlists available for download or installation.
        #
        # ## Usage
        #
        #     ronin-wordlists available [options]
        #
        # ## Options
        #
        #     -h, --help                       Print help information
        #
        class Available < Command

          usage '[options]'

          description 'Lists wordlists available for download or installation'

          man_page 'ronin-wordlists-available.1'

          #
          # Runs the `ronin-wordlists available` command.
          #
          def run
            wordlists = YAML.load_file(File.join(ROOT,'data','wordlists.yml'))

            wordlists.each do |name,attributes|
              puts "[ #{name} ]"
              puts
              puts "  * URL: #{attributes[:url]}"
              puts "  * Categories: #{attributes[:categories].join(', ')}"
              puts "  * Summary: #{attributes[:summary]}"
              puts
            end
          end

        end
      end
    end
  end
end
