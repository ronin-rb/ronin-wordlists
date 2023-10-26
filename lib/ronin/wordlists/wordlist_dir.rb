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

require 'ronin/wordlists/wordlist_file'
require 'ronin/wordlists/wordlist_repo'
require 'ronin/wordlists/exceptions'

require 'wordlist'

module Ronin
  module Wordlists
    #
    # Represents a directory of wordlists.
    #
    # ## Example
    #
    #     wordlist_dir = Wordlists::WordlistDir.new('/path/to/wordlists')
    #     wordlist_dir.find('passwords.txt')
    #     # => "/path/to/wordlists/passwords.txt"
    #     wordlist_dir.find('passwords')
    #     # => "/path/to/wordlists/passwords.txt"
    #     wordlist_dir.open('passwords.txt')
    #     # => #<Wordlist::File:...>
    #     wordlist_dir.open('passwords')
    #     # => #<Wordlist::File:...>
    #
    # @api public
    #
    class WordlistDir

      # The path to the wordlist directory.
      #
      # @return [String]
      attr_reader :path

      #
      # Initializes the wordlist directory.
      #
      # @param [String] path
      #   The path to the wordlist directory.
      #
      def initialize(path)
        @path = path
      end

      #
      # Enumerates over every wordlist in the wordlist directory.
      #
      # @yield [path]
      #   The given block will be passed each path to each wordlist.
      #
      # @yieldparam [String] path
      #   A path to a wordlist within the wordlist directory.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator will be returned.
      #
      def each(&block)
        return enum_for unless block

        Dir.glob(File.join(@path,'**','*.{txt,gz,bz2,xz}'),&block)
      end

      #
      # Looks up a wordlist within the wordlist directory.
      #
      # @param [String] name
      #   The wordlist file name.
      #
      # @return [String, nil]
      #   The path to the wordlist or `nil` if the wordlist could not be found.
      #
      # @example
      #   wordlist_dir.find('passwords.txt')
      #   # => "/path/to/wordlists/passwords.txt"
      #   wordlist_dir.find('passwords')
      #   # => "/path/to/wordlists/passwords.txt"
      #
      def find(name)
        path = File.join(@path,name)

        # check for an exact filenmae match first
        if File.file?(path)
          path
        else
          # fallback to search for the wordlist file by name
          Dir.glob(File.join(@path,'**',"#{name}.{txt,gz,bz2,xz}")).first
        end
      end

      #
      # Lists the wordlists in the wordlist directory.
      #
      # @param [String] name
      #   Optional file name to search for.
      #
      # @return [Array<String>]
      #   The wordlist files within the wordlist directory.
      #
      def list(name='*')
        Dir.glob("{**/}#{name}.{txt,gz,bz2,xz}", base: @path)
      end

      #
      # Opens a wordlist from the wordlist directory.
      #
      # @param [String] name
      #   The wordlist file name.
      #
      # @return [Wordlist::File]
      #   The opened wordlist file.
      #
      # @raise [WordlistNotFound]
      #   No wordlist with the given name.
      #
      # @example
      #   wordlist_dir.open('passwords.txt')
      #   # => #<Wordlist::File:...>
      #   wordlist_dir.open('passwords')
      #   # => #<Wordlist::File:...>
      #
      def open(name)
        if (path = find(name))
          Wordlist.open(path)
        else
          raise(WordlistNotFound,"wordlist not found: #{name.inspect}")
        end
      end

      #
      # Downloads a wordlist from the given URL into the wordlist directory.
      #
      # @param [String, URI::HTTP] url
      #   The URL of the wordlist to downloaded.
      #
      # @return [WordlistFile, WordlistRepo]
      #   The downloaded wordlist. A {WordlistRepo} will be returned for git
      #   URLs and {WordlistFile} for `http://` or `https://` URLs.
      #
      # @raise [DownloadFailed]
      #   The download of the wordlist file or repository failed.
      #
      def download(url)
        uri = URI(url)

        wordlist_class = if uri.scheme == 'git' || uri.path.end_with?('.git')
                           WordlistRepo
                         else
                           WordlistFile
                         end

        FileUtils.mkdir_p(@path)
        return wordlist_class.download(url,@path)
      end

      #
      # Deletes a wordlist file from the wordlist directory.
      #
      # @param [String] name
      #   The wordlist name to delete.
      #
      # @raise [ArgumentError]
      #   No wordlist with the given name.
      #
      def delete(name)
        if (path = find(name))
          File.unlink(path)

          return path
        else
          raise(WordlistNotFound,"unknown wordlist: #{name.inspect}")
        end
      end

    end
  end
end
