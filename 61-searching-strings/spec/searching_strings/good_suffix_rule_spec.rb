require "spec_helper"

RSpec.describe GoodSuffixRule do
  subject { described_class.new("CTTACTTAC") }

  it "returns the correct results for the examples in the video" do
    expect(subject.mismatch("C", 5)).to eq(4)
    expect(subject.mismatch("C", 1)).to eq(4)
  end

  it "skips the correct number of characters on an exact match" do
    expect(subject.mismatch("X", -1)).to eq(4)
  end

  it "returns the correct results for PICNIC" do
    subject = described_class.new("PICNIC")

    expect(subject.mismatch("C", 4)).to eq(3)
    expect(subject.mismatch("C", 3)).to eq(3)
    expect(subject.mismatch("C", 2)).to eq(6)
    expect(subject.mismatch("C", 1)).to eq(6)
    expect(subject.mismatch("C", 0)).to eq(6)
  end

  it "skips past the pattern if no match occurs" do
    subject = described_class.new("ABC")

    expect(subject.mismatch("X", 1)).to eq(3)
    expect(subject.mismatch("X", 0)).to eq(3)
  end

  it "advances by a single character if there is no suffix" do
    subject = described_class.new("ABC")
    expect(subject.mismatch("X", 2)).to eq(1)
  end
end
