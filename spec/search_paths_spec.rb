require 'spec_helper'
require 'ronin/wordlists/search_paths'
require 'ronin/wordlists/exceptions'

describe Ronin::Wordlists::SearchPaths do
  subject { described_class.new([path]) }

  let(:path)         { File.expand_path(File.join(__dir__, '..', 'spec', 'fixtures', 'wordlists')) }
  let(:wordlist_dir) { Ronin::Wordlists::WordlistDir.new(path) }

  describe "#initialize" do
    it "must initialize #paths and call #<< for each one" do
      expect(subject.paths[0]).to be_kind_of(Ronin::Wordlists::WordlistDir)
      expect(subject.paths[0].path).to eq(path)
    end
  end

  describe ".[]" do
    it "must initialize SearchPaths instance" do
      expect(described_class[path]).to be_kind_of(Ronin::Wordlists::SearchPaths)
      expect(described_class[path].paths[0].path).to eq(path)
    end
  end

  describe "#each" do
    let(:example_block) { proc { p "test" } }

    it "must iterate over #paths and yield each directory" do
      yielded_values = []
      subject.each do |value|
        yielded_values << value
      end

      expect(yielded_values[0].path).to eq(wordlist_dir.path)
    end
  end

  describe "#<<" do
    it "must add a new WordlistDir instance to search paths and return self" do
      expect(subject << path).to be_kind_of(Ronin::Wordlists::SearchPaths)
      expect((subject << path).paths.size).to eq(3)
    end
  end

  describe "#find" do
    let(:example_wrodlist_path) { File.join(path, "example_wordlist.txt") }

    it "must return wordlist path if it could be found" do
      expect(subject.find("example_wordlist.txt")).to eq(example_wrodlist_path)
    end

    it "must return nil if path could not be found" do
      expect(subject.find("foo")).to eq(nil)
    end
  end

  describe "#list" do
    let(:all_wordlists) { Dir.children(path) }

    context "if argument is not passed" do
      it "must list all wordlists in the wordlist directories" do
        expect(subject.list).to eq(Set.new(all_wordlists))
      end
    end

    context "if argument is passed" do
      it "and file is found, it must return wordlist filename" do
        expect(subject.list("foo_wordlist")).to eq(Set.new(["foo_wordlist.txt"]))
      end

      it "but file is not found, it must return an empty Set" do
        expect(subject.list("invalid_wordlist")).to eq(Set.new([]))
      end
    end
  end

  describe "#open" do
    context "if wordlist exist" do
      let(:example_wrodlist_path) { File.join(path, "example_wordlist.txt") }

      it "must call .open on Wordlist with path" do
        expect(Wordlist).to receive(:open).with(example_wrodlist_path)
        subject.open("example_wordlist")
      end
    end

    context "if wordlist does not exist" do
      let(:filename) { "foo_bar_baz" }

      it "must raise a WordlistNotFound error" do
        expect {
          subject.open(filename)
        }.to raise_error(Ronin::Wordlists::WordlistNotFound, "wordlist not found: #{filename.inspect}")
      end
    end
  end
end
