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
require 'ronin/wordlists/cli/wordlist_dir_option'
require 'ronin/wordlists'

require 'yaml'

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
        #     -a, --available                  List all wordlists available for download
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     [NAME]                           Optional wordlist name to search for
        #
        class List < Command

          include WordlistDirOption

          usage '[options] [NAME]'

          option :available, short: '-a',
                             desc:  'List all wordlists available for download'

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
            if options[:available]
              list_available_wordlists
            else
              list_wordlists(name)
            end
          end

          #
          # Lists wordlists available for download.
          #
          # @see https://github.com/ronin-rb/ronin-wordlists/blob/main/data/wordlists.yml
          #
          def list_available_wordlists
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

          #
          # Lists downloaded wordlists.
          #
          # @param [String, nil] name
          #   Optional wordlit name to list.
          #
          def list_wordlists(name=nil)
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
