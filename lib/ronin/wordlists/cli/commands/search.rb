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

require 'ronin/wordlists/cli/command'
require 'ronin/wordlists/cli/wordlist_index'

require 'set'

module Ronin
  module Wordlists
    class CLI
      module Commands
        #
        # Lists wordlists available for download or installation.
        #
        # ## Usage
        #
        #     ronin-wordlists search [options]
        #
        # ## Options
        #
        #     -c, --category NAME              Filters wordlists by a specific category
        #     -h, --help                       Print help information
        #
        # Arguments:
        #     [KEYWORD]                        Optional search keyword
        #
        class Search < Command

          usage '[options] [KEYWORD]'

          option :category, short: '-c',
                            value: {
                              type:  String,
                              usage: 'NAME'
                            },
                            desc: 'Filters wordlists by a specific category' do |category|
                              @categories << category
                            end

          argument :keyword, required: false,
                             desc:     'Optional search keyword'

          description 'Lists wordlists available for download or installation'

          man_page 'ronin-wordlists-search.1'

          # Wordlist categories to filter by.
          #
          # @return [Set<String>]
          attr_reader :categories

          #
          # Initializes the `ronin-wordlists search` command.
          #
          # @param [Hash{Symbol => Object}] kwargs
          #   Additional keyword arguments for the command.
          #
          def initialize(**kwargs)
            super(**kwargs)

            @categories = Set.new
          end

          #
          # Runs the `ronin-wordlists search` command.
          #
          # @param [String, nil] keyword
          #   The optional search keyword.
          #
          def run(keyword=nil)
            search(keyword, categories: @categories).each do |entry|
              print_entry(entry)
            end
          end

          #
          # Searches for matching entries in the wordlist index file.
          #
          # @param [String, nil] keyword
          #   The optional search keyword.
          #
          # @param [Set<String>, nil] categories
          #   The optional set of categories to filter by.
          #
          # @return [Enumerator::Lazy]
          #   The filtered wordlist index entries.
          #
          def search(keyword=nil, categories: Set.new)
            entries = WordlistIndex.load.lazy

            unless categories.empty?
              entries = entries.filter do |entry|
                categories.subset?(entry.categories)
              end
            end

            if keyword
              entries = entries.filter do |entry|
                entry.name.include?(keyword)      ||
                  entry.summary.include?(keyword) ||
                  entry.categories.include?(keyword)
              end
            end

            return entries
          end

          #
          # Prints an entry from the wordlist index file.
          #
          # @param [WordlistIndex::Entry] entry
          #   An entry from the wordlist index file.
          #
          def print_entry(entry)
            puts "[ #{entry.name} ]"
            puts
            puts "  * URL: #{entry.url}"
            puts "  * Categories: #{entry.categories.join(', ')}"
            puts "  * Summary: #{entry.summary}"
            puts
          end

        end
      end
    end
  end
end
