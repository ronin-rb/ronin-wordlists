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

module Ronin
  module Wordlists
    #
    # Common wordlist metadata attributes.
    #
    module WordlistMetadata
      # The optional URL for the wordlist.
      #
      # @return [String, nil]
      attr_reader :url

      #
      # Initializes the wordlist metadata attributes.
      #
      # @param [String, nil] url
      #   The optional URL of the wordlist.
      #
      def initialize(url: nil)
        @url = url
      end
    end
  end
end
