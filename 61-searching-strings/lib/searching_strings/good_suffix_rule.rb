class GoodSuffixRule
  attr_accessor :shifts

  def initialize(pattern)
    chars = pattern.chars
    m = chars.length

    self.shifts = Array.new(m + 1) { 0 }

    # values of `f` in preprocess_rule_1 map to the starting position of the
    # widest border of the suffix of the pattern beginning at each index.
    # A border is a substring which is both a 'proper' prefix and a 'proper' suffix.
    # e.g. in aabaa, the borders would be ['a', 'aa']
    widest_border_starting_positions = preprocess_rule_1(chars, m)
    preprocess_rule_2(chars, m, widest_border_starting_positions)
  end

  def mismatch(_char, index)
    # The shift table is keyed by the last index which had a match but our input
    # index is the 'current mismatch index', so we add 1.
    self.shifts.fetch(index + 1, 1)
  end

  private
  # Algorithm overview: http://www.iti.fh-flensburg.de/lang/algorithmen/pattern/bmen.htm
  # This step finds matching suffixes somewhere else in the pattern, which is a border of
  # the suffix of the pattern.
  #
  # There's a good explaination of how this works on stack overflow:
  # http://stackoverflow.com/questions/19345263/boyer-moore-good-suffix-heuristics?rq=1
  def preprocess_rule_1(chars, m)
    f = Array.new(m + 1) { 0 }
    i, j = m, m + 1

    # "The suffix ε beginning at position m has no border, therefore f[m] is set to m+1."
    f[i] = j

    while i > 0 do
      # At each iteration we know the values of f[i...m]

      # Try to extend the border for the current `i` based on knowledge from `f[i + 1...]`
      # If j > m, then its only border is the empty suffix (its longest border starts after the string)
      # If this check fails on the second clause, then the characters are the same
      # and so we can extend the border to the left, i.e. the longest border for i-1 starts at j-1
      while j <= m && chars[i - 1] != chars[j - 1] do
        # Set the shift if it hasn't been set yet.
        # This is where the current 'border' cannot be extended further to the left.
        # We can use this knowledge for a shift as it means we potentially had a matching
        # suffix with a different character prefix so we can skip straight to that check.
        # (the shift amount is the difference between the indices that we were comparing)
        shifts[j] = j - i if shifts[j] == 0

        # This should increment j by an amount as its value points to the starting point
        # of a border of the suffix of the string.
        j = f[j]
      end

      i -= 1
      j -= 1

      f[i] = j
    end

    f
  end

  # Store the starting position of the widest border in all unset entries of the array.
  def preprocess_rule_2(chars, m, f)
    # The starting position of the widest border of the pattern at all is stored in f[0].
    j = f[0]

    0.upto(m) do |i|
      # Only set the shift if we don't already have one from the matching suffixes
      shifts[i] = j if shifts[i] == 0

      # When we reach i == j, then the border we're pointing to will be longer than what
      # would remain of the suffix if we chop at the current index, so we continue with
      # the next widest border
      j = f[j] if i == j
    end
  end
end
