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

module Ronin
  module Wordlists
    #
    # Base class for all `ronin-wordlists` exceptions.
    #
    class Exception < RuntimeError
    end

    #
    # Indicates that a download of a wordlist failed.
    #
    class DownloadFailed < Wordlists::Exception
    end

    #
    # Indicates that a requests wordlist does not exist.
    #
    class WordlistNotFound < Wordlists::Exception
    end

    #
    # Indicates that the `manifest.yml` file is invalid or is missing data.
    #
    class InvalidManifestFile < Wordlists::Exception
    end
  end
end
