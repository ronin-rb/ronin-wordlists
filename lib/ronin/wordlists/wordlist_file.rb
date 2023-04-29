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
        @url  = URI(url) if url
      end

      #
      # Downloads a remote wordlist file.
      #
      # @param [String, URI::HTTP] url
      #   The `http://` or `https://` URL for the wordlist file.
      #
      # @param [String] dest_dir
      #   The directory to download the wordlist file into.
      #
      def self.download(url,dest=Dir.pwd)
        uri       = URI(url)
        ssl       = (uri.scheme == 'https')
        file_name = File.basename(uri.path)
        dest_path = if File.directory?(dest)
                      File.join(dest,file_name)
                    else
                      dest
                    end

        File.open(dest_path,'wb') do |file|
          Net::HTTP.start(uri.host,uri.port, use_ssl: ssl) do |http|
            request = Net::HTTP::Get.new(uri.request_uri)

            http.request(request) do |response|
              response.read_body do |chunk|
                file.write(chunk)
              end
            end
          end
        end

        return new(dest_path, url: url)
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
