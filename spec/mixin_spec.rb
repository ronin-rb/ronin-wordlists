require 'spec_helper'
require 'ronin/wordlists/mixin'

describe Ronin::Wordlists::Mixin do
  class TestWordlistsMixin
    include Ronin::Wordlists::Mixin
  end

  subject { TestWordlistsMixin.new }

  describe "#wordlists_download" do
    let(:url) { 'http://example.com/path/to/wordlist.txt' }

    it "must call Ronin::Wordlists.download with the given URL" do
      expect(Ronin::Wordlists).to receive(:download).with(url)

      subject.wordlists_download(url)
    end
  end

  describe "#wordlists_find" do
    let(:name) { 'subdomains-100' }
    let(:path) { "/path/to/#{name}.txt" }

    it "must call Ronin::Wordlists.find with the given name" do
      expect(Ronin::Wordlists).to receive(:find).with(name).and_return(path)

      expect(subject.wordlists_find(name)).to eq(path)
    end
  end

  describe "#wordlists_list" do
    let(:wordlists) do
      Set[
        double('wordlist1'),
        double('wordlist2'),
        double('wordlist3')
      ]
    end

    context "when given no arguments" do
      it "must call Ronin::Wordlists.list('*')" do
        expect(Ronin::Wordlists).to receive(:list).with('*').and_return(wordlists)

        expect(subject.wordlists_list).to eq(wordlists)
      end
    end

    context "when given a glob pattern" do
      let(:pattern) { 'wordlist*' }

      it "must call Ronin::Wordlists.list() with the glob pattern" do
        expect(Ronin::Wordlists).to receive(:list).with(pattern).and_return(wordlists)

        expect(subject.wordlists_list(pattern)).to eq(wordlists)
      end
    end
  end

  describe "#wordlists_open" do
    let(:name)     { 'subdomains-100' }
    let(:wordlist) { double('opened Wordlist') }

    it "must call Ronin::Wordlists.open with the given name" do
      expect(Ronin::Wordlists).to receive(:open).with(name).and_return(wordlist)

      expect(subject.wordlists_open(name)).to eq(wordlist)
    end
  end
end
