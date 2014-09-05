class Array

  # Patching Array to add this method which will perform a reduce and sum up
  # all integer values of each card in the Array. Useful for using on splat
  # parameters instead of having to covert them to a CardDeck::Hand first.
  def raw_integer_value
    self.reduce(0) {|sum, card| sum + card.raw_integer_value }
  end

end
