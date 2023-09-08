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

require 'fileutils'
require 'uri'

module Ronin
  module Wordlists
    #
    # Represents a git repository of wordlists.
    #
    class WordlistRepo

      # The path to the wordlist repository.
      #
      # @return [String]
      attr_reader :path

      # The name of the wordlist repository.
      #
      # @return [String]
      attr_reader :name

      #
      # Initializes the wordlist repository.
      #
      # @param [String] path
      #   The path to the wordlist repository.
      #
      # @param [String, nil] url
      #   The optional URL of the wordlist repository.
      #   If no URL is given, {#url} will infer it from the git repository.
      #
      def initialize(path, url: nil)
        @path = path
        @name = File.basename(@path)
        @url  = url
      end

      #
      # Clones a wordlist repository from the given git URL.
      #
      # @param [String, URI::HTTP] url
      #   The git URL for the wordlist repository.
      #
      # @param [String] dest_dir
      #   The directory to clone the wordlist repository into.
      #
      # @return [WordlistRepo]
      #   The newly cloned wordlist repository.
      #
      # @raise [DownloadFailed]
      #   The `git clone --depth 1` command failed or `git` was not installed on
      #   the system.
      #
      def self.download(url,dest_dir=Dir.pwd)
        uri       = URI(url)
        url       = url.to_s
        repo_name = File.basename(uri.path,'.git')
        repo_path = File.join(dest_dir,repo_name)

        case system('git','clone','--depth','1','--',url,repo_path)
        when true
          new(repo_path, url: url)
        when false
          raise(DownloadFailed,"git command failed: git clone --depth 1 -- #{url} #{repo_path}")
        when nil
          raise(DownloadFailed,"git is not installed on the system")
        end
      end

      #
      # The wordlist type.
      #
      # @return [:git]
      #
      def type
        :git
      end

      #
      # Determines if the wordlist repository uses Git.
      #
      # @return [Boolean]
      #
      def git?
        File.directory?(File.join(@path,'.git'))
      end

      #
      # The name of the wordlist repository directory.
      #
      # @return [String]
      #
      def filename
        File.basename(@path)
      end

      #
      # The URL of the wordlist repository.
      #
      # @return [String, nil]
      #
      def url
        @url ||= if git?
                   Dir.chdir(@path) do
                     `git config --get remote.origin.url`.chomp
                   end
                 end
      end

      #
      # Updates the wordlist repository.
      #
      # @raise [DownloadFailed]
      #   The `git pull -C` command failed or `git` was not installed on the
      #   system.
      #
      def update
        if git?
          case system('git','pull','-C',@path)
          when true then true
          when false
            raise(DownloadFailed,"git command failed: git pull -C #{@path}")
          when nil
            raise(DownloadFailed,"git is not installed on the system")
          end
        end
      end

      #
      # Deletes the wordlist repository.
      #
      def delete
        FileUtils.rm_rf(@path)
      end

    end
  end
end
