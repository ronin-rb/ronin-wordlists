require 'spec_helper'
require 'ronin/wordlists/cli/commands/purge'
require_relative 'man_page_example'

describe Ronin::Wordlists::CLI::Commands::Purge do
  include_examples "man_page"

  describe '#run' do
    let(:cache_dir) { instance_double('CacheDir') }

    before do
      allow(Ronin::Wordlists::CacheDir).to receive(:new).and_return(cache_dir)
    end

    it 'must purge all cached wordlists' do
      expect(cache_dir).to receive(:purge)

      subject.run
    end
  end
end
