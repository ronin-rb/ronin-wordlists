require 'spec_helper'
require 'ronin/wordlists/wordlist_repo'

describe Ronin::Wordlists::WordlistRepo do
  subject { described_class.new(path) }

  let(:fixtures_dir) { File.expand_path(File.join(__dir__, '..', 'spec', 'fixtures')) }

  let(:path) { File.join(fixtures_dir, 'wordlists') }

  describe "#initialize" do
    it "must initialize #path and #name" do
      expect(subject.path).to eq(path)
      expect(subject.name).to eq("wordlists")
    end
  end

  describe ".download" do
    let(:url) { "https://www.example.com" }

    context "with given a URL and a path" do
      let(:repo_path) { "/does/not/exist/" }

      context "when `git clone` succeeded" do
        it "must return new wordlist repo" do
          expect(described_class).to receive(:system).with('git', 'clone', '--depth', '1', '--', url, repo_path).and_return(true)

          expect(described_class.download(url, repo_path)).to be_kind_of(described_class)
        end
      end

      context "but `git clone` failed" do
        it "must raise DownloadFailed error" do
          expect(described_class).to receive(:system).with('git', 'clone', '--depth', '1', '--', url, repo_path).and_return(false)

          expect {
            described_class.download(url, repo_path)
          }.to raise_error(Ronin::Wordlists::DownloadFailed, "git command failed: git clone --depth 1 -- #{url} #{repo_path}")
        end
      end

      context "but `git` is not installed" do
        it "must raise DownloadFailed error" do
          expect(described_class).to receive(:system).with('git', 'clone', '--depth', '1', '--', url, repo_path).and_return(nil)

          expect {
            described_class.download(url, repo_path)
          }.to raise_error(Ronin::Wordlists::DownloadFailed, "git is not installed on the system")
        end
      end
    end

    context "when only given a URL" do
      let(:repo_path) { "#{Dir.pwd}/" }

      context "when `git clone` succeeded" do
        it "must return new wordlist repo" do
          expect(described_class).to receive(:system).with('git', 'clone', '--depth', '1', '--', url, repo_path).and_return(true)

          expect(described_class.download(url)).to be_kind_of(described_class)
        end
      end

      context "but `git clone` failed" do
        it "must raise DownloadFailed error" do
          expect(described_class).to receive(:system).with('git', 'clone', '--depth', '1', '--', url, repo_path).and_return(false)

          expect {
            described_class.download(url)
          }.to raise_error(Ronin::Wordlists::DownloadFailed, "git command failed: git clone --depth 1 -- #{url} #{repo_path}")
        end
      end

      context "but `git` is not installed" do
        it "must raise DownloadFailed error" do
          expect(described_class).to receive(:system).with('git', 'clone', '--depth', '1', '--', url, repo_path).and_return(nil)

          expect {
            described_class.download(url)
          }.to raise_error(Ronin::Wordlists::DownloadFailed, "git is not installed on the system")
        end
      end
    end
  end

  describe "#type" do
    it "must return :git" do
      expect(subject.type).to eq(:git)
    end
  end

  describe "#git?" do
    context "when the wordlist repository is a git repository" do
      let(:git_dir) { File.join(subject.path, '.git') }

      it "must return true" do
        allow(File).to receive(:directory?).with(git_dir).and_return(true)

        expect(subject.git?).to eq(true)
      end
    end

    context "when the wordlist repository is a plain directory" do
      it "must return false" do
        expect(subject.git?).to eq(false)
      end
    end
  end

  describe "#filename" do
    it "must return the name of the wordlist repo directory" do
      expect(subject.filename).to eq("wordlists")
    end
  end

  describe "#url" do
    context "when the wordlist repository is a git repository" do
      let(:url) do
        Dir.chdir(subject.path) { `git config --get remote.origin.url`.chomp }
      end

      it "must return its URL" do
        allow(subject).to receive(:git?).and_return(true)

        expect(subject.url).to eq(url)
      end
    end

    context "when the wordlist repository is a plain directory" do
      it "must return nil" do
        allow(subject).to receive(:git?).and_return(false)

        expect(subject.url).to eq(nil)
      end
    end
  end

  describe "#update" do
    before do
      allow(subject).to receive(:git?).and_return(true)
    end

    context "when `git pull` succeeded" do
      it "must return true" do
        expect(subject).to receive(:system).with('git', 'pull', '-C', subject.path).and_return(true)

        expect(subject.update).to eq(true)
      end
    end

    context "but `git pull` failed" do
      it "must raise DownloadFailed error" do
        expect(subject).to receive(:system).with('git', 'pull', '-C', subject.path).and_return(false)

        expect {
          subject.update
        }.to raise_error(Ronin::Wordlists::DownloadFailed, "git command failed: git pull -C #{subject.path}")
      end
    end

    context "but `git` is not installed" do
      it "must raise DownloadFailed error" do
        expect(subject).to receive(:system).with('git', 'pull', '-C', subject.path).and_return(nil)

        expect {
          subject.update
        }.to raise_error(Ronin::Wordlists::DownloadFailed, "git is not installed on the system")
      end
    end
  end

  describe "#delete" do
    it "must delete the wordlist repository directory" do
      expect(FileUtils).to receive(:rm_rf).with(subject.path)

      subject.delete
    end
  end
end
