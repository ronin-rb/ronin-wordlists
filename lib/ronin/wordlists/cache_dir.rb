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

require 'ronin/wordlists/wordlist_dir'
require 'ronin/wordlists/exceptions'
require 'ronin/core/home'

require 'uri'
require 'yaml'
require 'yaml/store'
require 'fileutils'

module Ronin
  module Wordlists
    #
    # Represents the cache directory.
    #
    # @api private
    #
    class CacheDir

      include Enumerable

      # The `~/.cache/ronin-wordlists/` directory where all repos are stored.
      PATH = Core::Home.cache_dir('ronin-wordlists')

      # The path to the cache directory.
      #
      # @return [String]
      attr_reader :path

      # The directory containing the downloaded wordlists.
      #
      # @return [WrodlistDir]
      attr_reader :wordlist_dir

      #
      # Initializes the repository cache.
      #
      # @param [String] path
      #   The path to the repository cache directory.
      #
      def initialize(path=PATH)
        @path = path

        @manifest_file = File.join(@path,'manifest.yml')
        @wordlist_dir  = WordlistDir.new(File.join(@path,'wordlists'))

        @manifest = load_manifest
      end

      # Mapping of wordlist `type:` values and their classes.
      WORDLIST_TYPES = {
        git:  WordlistRepo,
        file: WordlistFile
      }

      #
      # Accesses a wordlist file or repository from the cache directory.
      #
      # @param [String] name
      #   The name of the wordlist file or repository.
      #
      # @return [WordlistRepo, WordlistFile]
      #   The wordlist file or repository.
      #
      # @raise [WordlistNotFound]
      #   No wordlist with the given name exists in the cache directory.
      #
      # @raise [InvalidManifestFile]
      #   The `~/.cache/ronin-wordlists/manifest.yml` file contained invalid
      #   YAML data.
      #
      def [](name)
        unless (metadata = @manifest[name])
          raise(WordlistNotFound,"wordlist not downloaded: #{name.inspect}")
        end

        type = metadata.fetch(:type) do
          raise(InvalidManifestFile,"entry #{name.inspect} is missing a :type attribute")
        end

        url  = metadata.fetch(:url) do
          raise(InvalidManifestFile,"entry #{name.inspect} is missing a :url attribute")
        end

        filename = metadata.fetch(:filename) do
          raise(InvalidManifestFile,"entry #{name.inspect} is missing a :filename attribute")
        end

        path = File.join(@wordlist_dir.path,filename)

        wordlist_class = WORDLIST_TYPES.fetch(type) do
          raise(InvalidManifestFile,"unsupported wordlist type: #{type.inspect}")
        end

        return wordlist_class.new(path, url: url)
      end

      #
      # Enumerates over every wordlist in the cache directory.
      #
      # @yield [name, wordlist]
      #
      # @yieldparam [WordlistFile, WordlistRepo] wordlist
      #
      # @return [Enumerator]
      #   If no block is given an enumerator will be returned.
      #
      def each
        return enum_for unless block_given?

        @manifest.each_key do |name|
          yield self[name]
        end
      end

      #
      # Lists the wordlists in the cache directory.
      #
      # @param [String] name
      #   Optional file name to search for.
      #
      # @return [Array<String>]
      #   The wordlist files within the wordlist directory.
      #
      def list(name='*')
        @wordlist_dir.list(name)
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
      def open(name)
        @wordlist_dir.open(name)
      end

      #
      # Downloads a wordlist into the cache directory.
      #
      # @param [String, URI::HTTP] url
      #   The wordlist URL.
      #
      # @return [WordlistFile, WordlistRepo]
      #   The newly downloaded wordlist or the previously downloaded wordlist.
      #
      def download(url)
        wordlist = @wordlist_dir.download(url)

        update_manifest do |manifest|
          manifest[wordlist.name] = {
            type:     wordlist.type,
            filename: wordlist.filename,
            url:      wordlist.url.to_s
          }
        end

        return wordlist
      end

      #
      # Updates the wordlists in the cache directory.
      #
      def update
        each(&:update)
      end

      #
      # Deletes a wordlist from the cache directory.
      #
      # @param [String] name
      #   The wordlist file or directory name to delete.
      #
      def remove(name)
        wordlist = self[name]
        wordlist.delete

        update_manifest do |manifest|
          manifest.delete(name)
        end
      end

      #
      # Purge all wordlists from the cache directory.
      #
      def purge
        FileUtils.rm_rf(@path)
      end

      private

      #
      # Loads the manifest file.
      #
      # @return [Hash{String => Hash{Symbol => String}}]
      #
      def load_manifest
        if File.file?(@manifest_file)
          YAML.load_file(@manifest_file)
        else
          {}
        end
      end

      #
      # Updates both the {#manifest} and the `manifest.yml` file.
      #
      # @yield [manifest]
      #
      # @yieldparam [Hash] manifest
      #
      def update_manifest(&block)
        yield @manifest
        update_manifest_file(&block)
      end

      #
      # Updates the `manifest.yml` file.
      #
      # @yield [manifest]
      #
      # @yieldparam [Hash] manifest
      #
      def update_manifest_file(&block)
        manifest = YAML::Store.new(@manifest_file)
        manifest.transaction(&block)
      end

    end
  end
end
