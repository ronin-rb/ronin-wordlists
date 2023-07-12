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

require 'ronin/wordlists/exceptions'
require 'ronin/core/system'

require 'net/https'
require 'uri'

module Ronin
  module Wordlists
    #
    # Represents a wordlist file.
    #
    class WordlistFile

      # The path to the wordlist file.
      #
      # @return [String]
      attr_reader :path

      # The name of the wordlist file.
      #
      # @return [String]
      attr_reader :name

      # The optional URL for the wordlist file.
      #
      # @return [String, nil]
      attr_reader :url

      #
      # Initializes the wordlist file.
      #
      # @param [String] path
      #   The path to the wordlist file.
      #
      # @param [String, nil] url
      #   The optional URL for the wordlist file.
      #
      def initialize(path, url: nil)
        @path = path
        @name = File.basename(@path,File.extname(@path))
        @url  = url
      end

      #
      # Downloads a remote wordlist file.
      #
      # @param [String, URI::HTTP] url
      #   The `http://` or `https://` URL for the wordlist file.
      #
      # @param [String] dest
      #   The directory to download the wordlist file into.
      #
      # @raise [DownloadFailed]
      #   Failed to download the wordlist file.
      #
      def self.download(url,dest=Dir.pwd)
        dest_path = begin
                      Core::System.download(url,dest)
                    rescue Core::System::DownloadFailed => error
                      raise(DownloadFailed,error.message)
                    end

        return new(dest_path, url: url.to_s)
      end

      #
      # The wordlist type.
      #
      # @return [:file]
      #
      def type
        :file
      end

      #
      # The name of the wordlist file.
      #
      # @return [String]
      #
      def filename
        File.basename(@path)
      end

      #
      # Updates the wordlist file, if {#url} is set.
      #
      # @raise [DownloadFailed]
      #   Failed to download the wordlist.
      #
      def update
        if @url
          self.class.download(@url,@path)
        end
      end

      #
      # Deletes the wordlist file.
      #
      def delete
        File.unlink(@path)
      end

      #
      # Converts the wordlist file to a String.
      #
      # @return [String]
      #   The wordlist file's path.
      #
      def to_s
        @path
      end

    end
  end
end
