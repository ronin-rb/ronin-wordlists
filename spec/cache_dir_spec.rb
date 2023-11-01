require 'spec_helper'
require 'tmpdir'
require 'ronin/wordlists/cache_dir'
require 'ronin/wordlists/exceptions'
require 'ronin/core/home'

describe Ronin::Wordlists::CacheDir do
  let(:fixtures_dir) { File.expand_path(File.join(__dir__,'..','spec','fixtures')) }

  let(:path)          { File.join(fixtures_dir, 'cache_dir') }
  let(:wordlist_path) { File.join(fixtures_dir, 'example_wordlist.txt') }

  subject { described_class.new(path) }

  describe "#initialize" do
    it "must initialize #wordlist_dir" do
      expect(subject.wordlist_dir).to be_kind_of(Ronin::Wordlists::WordlistDir)
      expect(subject.wordlist_dir.path).to eq(File.join(path, 'wordlists'))
    end

    context "when given a path argument" do
      subject { described_class.new(path) }

      let(:path) { "foo/bar/baz" }

      it "must initialize #path to given path" do
        expect(subject.path).to eq(path)
      end
    end

    context "when no arguments are given" do
      subject { described_class.new }

      it "must initialize #path do default path" do
        expect(subject.path).to eq(Ronin::Core::Home.cache_dir('ronin-wordlists'))
      end
    end
  end

  describe "#[]" do
    context "when the wordlist cannot be found" do
      it "must raise an WordlistNotFound" do
        expect {
          subject["invalid_name"]
        }.to raise_error(Ronin::Wordlists::WordlistNotFound, "wordlist not downloaded: \"invalid_name\"")
      end
    end

    context "but the :type attribute is missing" do
      before do
        subject.instance_variable_set(:@manifest, { foo: { url: "url", filename: "filename" } })
      end

      it "must raise an InvalidManifestFile" do
        expect {
          subject[:foo]
        }.to raise_error(Ronin::Wordlists::InvalidManifestFile, "entry :foo is missing a :type attribute")
      end
    end

    context "but the :url attribute is missing" do
      before do
        subject.instance_variable_set(:@manifest, { foo: { type: "type", filename: "filename" } })
      end

      it "must raise an InvalidManifestFile" do
        expect {
          subject[:foo]
        }.to raise_error(Ronin::Wordlists::InvalidManifestFile, "entry :foo is missing a :url attribute")
      end
    end

    context "but the :filename attribute is missing" do
      before do
        subject.instance_variable_set(:@manifest, { foo: { type: "type", url: "url" } })
      end

      it "must raise an InvalidManifestFile" do
        expect {
          subject[:foo]
        }.to raise_error(Ronin::Wordlists::InvalidManifestFile, "entry :foo is missing a :filename attribute")
      end
    end

    context "but the wordlist type is unsupported" do
      before do
        subject.instance_variable_set(:@manifest, { foo: { type: "type", url: "url", filename: "filename" } })
      end

      it "must raise an InvalidManifestFile" do
        expect {
          subject[:foo]
        }.to raise_error(Ronin::Wordlists::InvalidManifestFile, "unsupported wordlist type: \"type\"")
      end
    end

    context "when the wordlist type is :git" do
      before do
        subject.instance_variable_set(:@manifest, { foo: { type: :git, url: "url", filename: "filename" } })
      end

      it "must return new WordlistRepo" do
        expect(subject[:foo]).to be_kind_of(Ronin::Wordlists::WordlistRepo)
      end
    end

    context "when the wordlist type is :file" do
      before do
        subject.instance_variable_set(:@manifest, { foo: { type: :file, url: "url", filename: "filename" } })
      end

      it "must return new WordlistFile" do
        expect(subject[:foo]).to be_kind_of(Ronin::Wordlists::WordlistFile)
      end
    end
  end

  describe "#each" do
    context "when a block is given" do
      before do
        subject.instance_variable_set(:@manifest, { foo: { type: :file, url: "url", filename: "filename" } })
      end

      it "must yields wordlists" do
        yielded_values = []

        subject.each do |value|
          yielded_values << value
        end

        expect(yielded_values.size).to eq(1)
        expect(yielded_values[0]).to be_kind_of(Ronin::Wordlists::WordlistFile)
      end
    end

    context "when no block is given" do
      it "must return an Enumerator" do
        expect(subject.each).to be_kind_of(Enumerator)
      end
    end
  end

  describe "#list" do
    it "must return an Array of all wordlists" do
      expect(subject.list).to eq(["cache_dir_wordlist.txt"])
    end
  end

  describe "#open" do
    context "when the wordlist with given name is found" do
      it "must open a wordlist file" do
        expect(subject.open("cache_dir_wordlist")).to be_kind_of(Wordlist::File)
      end
    end

    context "but the wordlist with given name cannot be found" do
      it "must raise an WordlistNotFound" do
        expect {
          subject.open("foo")
        }.to raise_error(Ronin::Wordlists::WordlistNotFound, "wordlist not found: \"foo\"")
      end
    end
  end

  describe "#download" do
    let(:url)      { "https://github.com/Escape-Technologies/graphql-wordlist.git" }
    let(:wordlist) { Ronin::Wordlists::WordlistRepo.new("bar") }

    it "must download the wordlist" do
      expect(Ronin::Wordlists::WordlistRepo).to receive(:download).and_return(wordlist)

      expect(subject.download(url)).to eq(wordlist)
    end
  end

  describe "#update" do
    let(:name1)     { 'foo' }
    let(:name2)     { 'bar' }

    let(:wordlist1) { Ronin::Wordlists::WordlistFile.new(File.join(subject.wordlist_dir.path,name1)) }
    let(:wordlist2) { Ronin::Wordlists::WordlistRepo.new(File.join(subject.wordlist_dir.path,name1)) }

    it "must iterate over all wordlist objects and call #update on each one" do
      expect(subject).to receive(:[]).with(name1).and_return(wordlist1)
      expect(subject).to receive(:[]).with(name2).and_return(wordlist2)
      expect(wordlist1).to receive(:update)
      expect(wordlist2).to receive(:update)

      subject.update
    end
  end

  describe "#remove" do
    let(:path) { Dir.mktmpdir('ronin-wordlists-cache-dir') }

    before do
      FileUtils.mkdir_p("#{path}/wordlists")
      FileUtils.cp_r('spec/fixtures/cache_dir/manifest.yml', path)
    end

    it "must delete wordlist and remove it from the manifest" do
      subject.remove("foo")

      expect(subject.list("fo")).to eq([])

      expect {
        subject["foo"]
      }.to raise_error(Ronin::Wordlists::WordlistNotFound, "wordlist not downloaded: \"foo\"")
    end
  end

  describe "#purge" do
    let(:path) { Dir.mktmpdir('ronin-wordlists-cache-dir') }

    before { FileUtils.cp_r('spec/fixtures/cache_dir', path) }

    it "must remove the cache directory" do
      expect(FileUtils).to receive(:rm_rf).with(subject.path).and_return(true)
      subject.purge
    end
  end
end
