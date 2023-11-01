require 'spec_helper'
require 'ronin/wordlists/search_paths'
require 'ronin/wordlists/exceptions'

describe Ronin::Wordlists::SearchPaths do
  subject { described_class.new([path1, path2]) }

  let(:fixtures_dir) { File.expand_path(File.join(__dir__, '..', 'spec', 'fixtures')) }
  let(:path1) { File.join(fixtures_dir, 'wordlists') }
  let(:path2) { File.join(fixtures_dir, 'extra_wordlists') }

  describe "#initialize" do
    it "must initialize #paths and call #<< for each one" do
      expect(subject.paths).to all(be_kind_of(Ronin::Wordlists::WordlistDir))
      expect(subject.paths.map(&:path).sort).to eq([path2, path1])
    end
  end

  describe ".[]" do
    context "when given a single path argument" do
      subject { described_class[path1] }

      it "must initialize #{described_class} instance with the single path" do
        expect(subject).to be_kind_of(described_class)
        expect(subject.paths.map(&:path)).to eq([path1])
      end
    end

    context "when given multiple path arguments" do
      subject { described_class[path1, path2] }

      it "must initialize the #{described_class} instance with the paths" do
        expect(subject).to be_kind_of(described_class)
        expect(subject.paths.map(&:path)).to eq([path2, path1])
      end
    end
  end

  describe "#each" do
    let(:wordlist_dirs) { [Ronin::Wordlists::WordlistDir.new(path2), Ronin::Wordlists::WordlistDir.new(path1)] }

    it "must iterate over #paths and yield each directory" do
      yielded_values = []

      subject.each do |value|
        yielded_values << value
      end

      expect(yielded_values.size).to eq(2)
      expect(yielded_values.map(&:path)).to eq(wordlist_dirs.map(&:path))
    end
  end

  describe "#<<" do
    before do
      subject << path1
    end

    it "must add a new WordlistDir instance to search paths" do
      expect(subject.paths.size).to eq(3)
    end
  end

  describe "#find" do
    let(:example_wrodlist_path) { File.join(path1, "example_wordlist.txt") }

    it "must return wordlist path if it could be found" do
      expect(subject.find("example_wordlist.txt")).to eq(example_wrodlist_path)
    end

    it "must return nil if path could not be found" do
      expect(subject.find("foo")).to be(nil)
    end
  end

  describe "#list" do
    let(:all_wordlists) { Dir.children(path1) + Dir.children(path2) }

    context "when no arguments are given" do
      it "must list all wordlists in the wordlist directories" do
        expect(subject.list).to eq(Set.new(all_wordlists))
      end
    end

    context "when an argument is given" do
      context "and the wordlist file is found" do
        it "must return wordlist filename" do
          expect(subject.list("foo_wordlist")).to eq(Set.new(["foo_wordlist.txt"]))
        end
      end

      context "but the wordlist file is not found" do
        it "must return an empty Set" do
          expect(subject.list("invalid_wordlist")).to eq(Set.new([]))
        end
      end
    end
  end

  describe "#open" do
    context "when the wordlist file is found" do
      let(:wordlist_name)         { "example_wordlist" }
      let(:example_wrodlist_path) { File.join(path1, "example_wordlist.txt") }

      it "must call .open on Wordlist with path" do
        wordlist = subject.open(wordlist_name)

        expect(wordlist).to be_kind_of(Wordlist::File)
        expect(wordlist.path).to eq(example_wrodlist_path)
      end
    end

    context "but the wordlist file is not found" do
      let(:filename) { "foo_bar_baz" }

      it "must raise a WordlistNotFound error" do
        expect {
          subject.open(filename)
        }.to raise_error(Ronin::Wordlists::WordlistNotFound, "wordlist not found: #{filename.inspect}")
      end
    end
  end
end
