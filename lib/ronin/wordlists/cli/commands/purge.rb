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

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Purges all cached wordlists.
        #
        # ## Usage
        #
        #     ronin-wordlists purge [options]
        #
        # ## Options
        #
        #     -d, --wordlist-dir DIR           The wordlist directory
        #     -h, --help                       Print help information
        #
        class Purge < Command

          include WordlistDirOption

          description 'Purges all downloaded wordlists'

          man_page 'ronin-wordlists-purge.1'

          #
          # Runs the `ronin-wordlists purge` command.
          #
          def run
            cache_dir = CacheDir.new
            cache_dir.purge
          end

        end
      end
    end
  end
end
