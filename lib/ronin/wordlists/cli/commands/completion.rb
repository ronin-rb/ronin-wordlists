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

require 'ronin/wordlists/root'
require 'ronin/core/cli/completion_command'

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Manages the shell completion rules for `ronin-wordlists`.
        #
        # ## Usage
        #
        #     ronin-wordlists completion [options]
        #
        # ## Options
        #
        #         --print                      Prints the shell completion file
        #         --install                    Installs the shell completion file
        #         --uninstall                  Uninstalls the shell completion file
        #     -h, --help                       Print help information
        #
        # ## Examples
        #
        #     ronin-wordlists completion --print
        #     ronin-wordlists completion --install
        #     ronin-wordlists completion --uninstall
        #
        class Completion < Core::CLI::CompletionCommand

          completion_file File.join(ROOT,'data','completions','ronin-wordlists')

          man_dir File.join(ROOT,'man')
          man_page 'ronin-wordlists-completion.1'

          description 'Manages the shell completion rules for ronin-wordlists'

        end
      end
    end
  end
end
