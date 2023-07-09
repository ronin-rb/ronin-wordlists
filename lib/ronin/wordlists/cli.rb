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

require 'ronin/wordlists/version'
require 'ronin/core/cli/help/banner'

require 'command_kit/commands'
require 'command_kit/commands/auto_load'
require 'command_kit/options/version'

module Ronin
  module Wordlists
    #
    # The `ronin-wordlists` command-line interface (CLI).
    #
    # @api private
    #
    class CLI

      include CommandKit::Commands
      include CommandKit::Commands::AutoLoad.new(
        dir:       "#{__dir__}/cli/commands",
        namespace: "#{self}::Commands"
      )
      include CommandKit::Options::Version
      include Core::CLI::Help::Banner

      command_name 'ronin-wordlists'
      version Ronin::Wordlists::VERSION

      command_aliases['ls'] = 'list'
      command_aliases['up'] = 'update'
      command_aliases['rm'] = 'remove'

    end
  end
end
