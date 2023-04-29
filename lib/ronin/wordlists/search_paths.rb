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

require 'ronin/wordlists/wordlist_dir'

require 'set'

module Ronin
  module Wordlists
    #
    # Represents the wordlist directories to search for wordlists within.
    #
    # @api private
    #
    class SearchPaths

      include Enumerable

      # The paths of the wordlist directories.
      #
      # @return [Array<WordlistDir>]
      attr_reader :paths

      #
      # Initializes the wordlist search paths.
      #
      # @param [Array<String>] paths
      #   The paths to the wordlist directories to search.
      #
      def initialize(paths=[])
        @paths = []

        paths.each do |path|
          self << path
        end
      end

      #
      # Initializes the wordlist search paths.
      #
      # @param [Array<String>] paths
      #   The paths to the wordlist directories to search.
      #
      # @return [SearchPaths]
      #   The wordlist search paths.
      #
      def self.[](*paths)
        new(paths)
      end

      #
      # Enumerates over each wordlist directory within the search paths.
      #
      # @yield [wordlist_dir]
      #   If a block is given, each wordlist directory will be yielded.
      #
      # @yieldparam [WordlistDir] wordlist_dir
      #   A wordlist directory within the search paths.
      #
      # @return [Enumerator]
      #   If no block is given, an Enumerator will be returned.
      #
      def each(&block)
        @paths.each(&block)
      end

      #
      # Adds a new wordlist directory to the search paths.
      #
      # @param [String] new_dir
      #   A new wordlist directory to add to the search directories.
      #
      # @return [self]
      #
      def <<(new_dir)
        @paths.unshift(WordlistDir.new(new_dir))
        return self
      end

      #
      # Finds a wordlist within one of the wordlist directories.
      #
      # @param [String] name
      #   The wordlist file name.
      #
      # @return [String, nil]
      #   The path to the wordlist or `nil` if the wordlist could not be found.
      #
      def find(name)
        @paths.each do |wordlist_dir|
          if (wordlist_path = wordlist_dir.find(name))
            return wordlist_path
          end
        end

        return nil
      end

      #
      # Lists all wordlists in the wordlist directories.
      #
      # @param [String] name
      #   Optional file name to search for.
      #
      # @return [Set<String>]
      #   The wordlist files within the wordlist directories.
      #
      def list(name='*')
        each_with_object(Set.new) do |wordlist_dir,files|
          files.merge(wordlist_dir.list(name))
        end
      end

      #
      # Opens a wordlist from one of the wordlist directories.
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
      def open(name)
        if (path = find(name))
          Wordlist.open(path)
        else
          raise(WordlistNotFound,"wordlist not found: #{name.inspect}")
        end
      end

    end
  end
end
