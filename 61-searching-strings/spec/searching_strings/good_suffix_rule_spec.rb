require "spec_helper"

RSpec.describe GoodSuffixRule do
  subject { described_class.new("CTTACTTAC") }

  it "returns the correct results for the examples in the video" do
    # Both TAC sequences share a T before them so we shouldn't skip to it
    expect(subject.mismatch("C", 5)).to eq(8)
    expect(subject.mismatch("C", 3)).to eq(4)
    expect(subject.mismatch("C", 1)).to eq(4)
  end

  it "skips the correct number of characters on an exact match" do
    expect(subject.mismatch("X", -1)).to eq(4)
  end

  it "returns the correct results for PICNIC" do
    subject = described_class.new("PICNIC")

    # If we mismatch on the I after already matching a C, the next
    # IC in the pattern should also be skipped as it would have the
    # same mismatch.
    expect(subject.mismatch("C", 4)).to eq(6)
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

  it "matches a prefix with a suffix" do
    subject = described_class.new("ABAA")

    expect(subject.mismatch("A", 0)).to eq(3)
  end

  it "skips the pattern when a prefix doesn't match a suffix" do
    subject = described_class.new("ABAD")

    expect(subject.mismatch("A", 0)).to eq(4)
  end

  it "ignores matching suffixes if they are preceded by the same character" do
    subject = described_class.new("CABFABFAB")

    expect(subject.mismatch("F", 6)).to eq(6)
  end

  # 'The website' = http://www.iti.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm
  it "matches the behavior of an example on the website" do
    # if we've matched bab and failed on 'a' then it finds next bab with a different
    # prefix character - 'b' in this case
    subject = described_class.new("abbabab")

    expect(subject.mismatch("B", 3)).to eq(2)
  end
end
