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

require 'ronin/wordlists'

module Ronin
  module Wordlists
    class CLI
      #
      # Adds the `-W,--wordlist {NAME | PATH}` option to a command that includes
      # {WordlistOption}.
      #
      # @api public
      #
      module WordlistOption
        #
        # Adds the `-W,--wordlist {NAME | PATH}` option to the command including
        # {WordlistOption}.
        #
        # @param [Class<Command>] command
        #   The command class including {WordlistOption}.
        #
        # @api private
        #
        def self.included(command)
          command.option :wordlist, short: '-W',
                                    value: {
                                      type:  String,
                                      usage: '{NAME | PATH}'
                                    },
                                    desc: 'The wordlist name or file' do |path_or_name|
                                      @wordlist = if File.file?(path_or_name)
                                                    Wordlist.open(path_or_name)
                                                  else
                                                    Wordlists.open(path_or_name)
                                                  end
                                    rescue WordlistNotFound => error
                                      raise(OptionParser::InvalidArgument,"unknown wordlist: #{error.message}")
                                    end
        end

        # The opened wordlist file.
        #
        # @return [::Wordlist, nil]
        attr_reader :wordlist
      end
    end
  end
end
