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
require 'ronin/wordlists/root'

require 'ronin/core/cli/logging'
require 'yaml'

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Downloads a wordlist.
        #
        # ## Usage
        #
        #     ronin-wordlists download [options] {NAME | URL}
        #
        # ## Options
        #
        #     -d, --wordlist-dir DIR           The wordlist directory
        #     -h, --help                       Print help information
        #
        # ## Arguments
        #
        #     NAME | URL                       The wordlist name or URL to download
        #
        class Download < Command

          include WordlistDirOption
          include Core::CLI::Logging

          usage '[options] {NAME | URL}'

          argument :name_or_url, required: true,
                                 usage: 'NAME | URL',
                                 desc:  'The wordlist name or URL to download'

          description 'Downloads a wordlist'

          man_page 'ronin-wordlists-download.1'

          #
          # Runs the `ronin-wordlists download` command.
          #
          # @param [String] name_or_url
          #   The wordlist name or URL to download.
          #
          def run(name_or_url)
            if name_or_url =~ %r{\A(?:git|http|https)://}
              url = name_or_url

              download(url)
            else
              wordlists = YAML.load_file(File.join(ROOT,'data','wordlists.yml'))
              name      = name_or_url

              if (metadata = wordlists[name])
                download(metadata.fetch(:url))
              else
                print_error "unknown wordlist: #{name}"
                exit(1)
              end
            end
          end

          #
          # Downloads a wordlist from the URL.
          #
          # @param [String] url
          #   The URL to download from.
          #
          def download(url)
            log_info "Downloading wordlist #{url} ..."

            begin
              downloaded_wordlist = wordlist_dir.download(url)

              log_info "Wordlist #{downloaded_wordlist.name} downloaded"
            rescue DownloadFailed => error
              log_error error.message
              exit(2)
            end
          end

        end
      end
    end
  end
end
