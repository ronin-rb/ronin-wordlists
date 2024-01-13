require 'spec_helper'
require 'ronin/wordlists'

require 'uri'

describe Ronin::Wordlists do
  let(:cache_dir)    { subject.instance_variable_get('@cache_dir') }
  let(:search_paths) { subject.instance_variable_get('@search_paths') }

  describe ".download" do
    context "when given a URI::HTTP object" do
      let(:uri) { URI.parse('http://example.com/path/to/wordlist.txt') }

      it "must pass the URI::HTTP object to @cache_dir.download()" do
        expect(cache_dir).to receive(:download).with(uri)

        subject.download(uri)
      end
    end

    context "when given a String object" do
      context "and the String starts with http://" do
        let(:string) { 'http://example.com/path/to/wordlist.txt' }
        let(:uri)    { URI.parse(string) }

        it "must parse the String as a URI" do
          expect(cache_dir).to receive(:download).with(uri)

          subject.download(string)
        end
      end

      context "and the String starts with https://" do
        let(:string) { 'https://example.com/path/to/wordlist.txt' }
        let(:uri)    { URI.parse(string) }

        it "must parse the String as a URI" do
          expect(cache_dir).to receive(:download).with(uri)

          subject.download(string)
        end
      end
    end
  end

  describe ".find" do
    let(:name) { 'subdomains-100' }
    let(:path) { "/path/to/#{name}.txt" }

    it "must call @search_paths.find with the given name" do
      expect(search_paths).to receive(:find).with(name).and_return(path)
      
      expect(subject.find(name)).to eq(path)
    end
  end

  describe ".list" do
    let(:wordlists) do
      Set[
        double('wordlist1'),
        double('wordlist2'),
        double('wordlist3')
      ]
    end

    context "when given no arguments" do
      it "must call @search_paths.list('*')" do
        expect(search_paths).to receive(:list).with('*').and_return(wordlists)

        expect(subject.list).to eq(wordlists)
      end
    end

    context "when given a glob pattern" do
      let(:pattern) { 'wordlist*' }

      it "must call @search_paths.list() with the glob pattern" do
        expect(search_paths).to receive(:list).with(pattern).and_return(wordlists)

        expect(subject.list(pattern)).to eq(wordlists)
      end
    end
  end

  describe ".open" do
    let(:name)     { 'subdomains-100' }
    let(:wordlist) { double('opened Wordlist') }

    it "must call @search_paths.open with the given name" do
      expect(search_paths).to receive(:open).with(name).and_return(wordlist)
      
      expect(subject.open(name)).to eq(wordlist)
    end
  end
end
