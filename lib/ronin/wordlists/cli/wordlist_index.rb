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

require 'ronin/wordlists/root'
require 'ronin/wordlists/exceptions'

require 'yaml'
require 'set'

module Ronin
  module Wordlists
    class CLI
      #
      # Represents an index of known wordlists.
      #
      class WordlistIndex

        include Enumerable

        #
        # Represents an entry in the wordlist index file.
        #
        class Entry

          # The name of the wordlist.
          #
          # @return [String]
          attr_reader :name

          # The download URL of the wordlist.
          #
          # @return [String]
          attr_reader :url

          # A brief summary of the wordlist.
          #
          # @return [String]
          attr_reader :summary

          # The categories the wordlist belongs to.
          #
          # @return [Set<String>]
          attr_reader :categories

          #
          # Initializes the entry object.
          #
          # @param [String] name
          #   The name of the wordlist.
          #
          # @param [String] url
          #   The download URL of the wordlist.
          #
          # @param [String] summary
          #   A brief summary of the wordlist.
          #
          # @param [Array<String>] categories
          #   The categories the wordlist belongs to.
          #
          def initialize(name, url: , summary: , categories: [])
            @name = name
            @url  = url

            @summary    = summary
            @categories = categories.to_set
          end

        end

        # The entries in the wordlist index.
        #
        # @return [Hash{String => Entry}]
        attr_reader :entries

        #
        # Initializes the wordlist index.
        #
        # @param [Hash{String => Entry}] entries
        #   The entries for the wordlist index.
        #
        def initialize(entries)
          @entries = entries
        end

        #
        # Indicates that the wordlist index file has an invalid schema.
        #
        class InvalidSchema < Wordlists::Exception
        end

        # Path to the builtin `wordlists.yml` index file.
        PATH = File.join(ROOT,'data','wordlists.yml')

        #
        # Loads the wordlist index file from the given path.
        #
        # @param [String] path
        #   The path of the wordlit index file.
        #
        # @return [WordlistIndex]
        #   The parsed wordlist index file.
        #
        # @raise [InvalidSchema]
        #   The wordlist index file has an invalid schema.
        #
        def self.load(path=PATH)
          yaml = YAML.load_file(path)

          unless yaml.kind_of?(Hash)
            raise(InvalidSchema,"wordlist index file does not contain a Hash: #{path.inspect}")
          end

          entries = yaml.to_h do |name,attributes|
            unless attributes[:url]
              raise(InvalidSchema,"wordlist index entry does not have a URL: #{name.inspect}")
            end

            unless attributes[:summary]
              raise(InvalidSchema,"wordlist index entry does not have a summary: #{name.inspect}")
            end

            [name, Entry.new(name,**attributes)]
          end

          return new(entries)
        end

        #
        # Looks up the wordlist by name within the wordlist index.
        #
        # @param [String] name
        #   The wordlist name.
        #
        # @return [Entry, nil]
        #   The entry for the wordlist.
        #
        def [](name)
          @entries[name]
        end

        #
        # Enumerates over every entry in the wordlist index.
        #
        # @yield [entry]
        #   If a block is given, it will be passed every entry in the wordlist
        #   index.
        #
        # @yieldparam [Entry] entry
        #   An entry in the wordlist index.
        #
        # @return [Enumerator]
        #   If no block is given, an Enumerator object will be returned instead.
        #
        def each(&block)
          @entries.each_value(&block)
        end

      end
    end
  end
end
