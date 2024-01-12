require 'rspec'

shared_examples_for "WordlistMetadata#initialize" do
  it "must default #url to nil" do
    expect(subject.url).to be(nil)
  end
end
