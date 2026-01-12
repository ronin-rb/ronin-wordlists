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
require 'ronin/wordlists/cache_dir'

require 'ronin/core/cli/logging'

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Updates a wordlist or all wordlists.
        #
        # ## Usage
        #
        #     ronin-wordlists update [options] [WORDLISt]
        #
        # ## Options
        #
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     [WORDLIST]                       The optional wordlist to update
        #
        class Update < Command

          include Core::CLI::Logging

          usage '[options] [WORDLISt]'

          argument :wordlist, required: false,
                              desc:     'The optional wordlist to update'

          description 'Updates a wordlist or all wordlists'

          man_page 'ronin-wordlists-update.1'

          #
          # Runs the `ronin-wordlists update` command.
          #
          # @param [String, nil] name
          #   The optional wordlist name to update.
          #
          def run(name=nil)
            cache_dir = CacheDir.new

            if name
              begin
                update(cache_dir[name])
              rescue WordlistNotFound
                print_error "no such wordlist: #{name}"
                exit(1)
              end
            else
              cache_dir.each(&method(:update))
            end
          end

          #
          # Updates a wordlist.
          #
          # @param [WordlistFile, WordlistRepo] wordlist
          #   The wordlist file or git repository to update.
          #
          def update(wordlist)
            log_info "Updating wordlist #{wordlist.name} from #{wordlist.url} ..."
            begin
              wordlist.update
            rescue DownloadFailed => error
              log_error error.message
            end
          end

        end
      end
    end
  end
end
