class Array

  def raw_integer_value
    self.reduce(0) {|sum, card| sum + card.raw_integer_value }
  end

end
