module CardDecks
  class Hand
    include CardDecks::Decks::Enumerable
    include CardDecks::Decks::Values

    attr_accessor :cards, :deck, :name
    def initialize *cards
      metadata = cards.extract_options!
      @deck = metadata[:deck]
      raise 'Cannot create a hand without the reference to the deck' unless @deck
      @name = metadata[:name]
      @cards = (cards || []).delete_if(&:nil?)
      @cards.each do |card|
        raise "All cards must have come from the same deck passed in." unless card.deck == @deck
      end
    end

    def discard!
      deck.return(self)
      self.cards = []
    end

    def integer_value
      all_combinations = (1..@cards.size).map {|int| @cards.combination(int).to_a }.flatten(1)
      combo_points = all_combinations.map do |combination|
        (deck.combinations.map do |c|
          c.is_a?(Symbol) ? deck.send(c, *combination) : c.call(*combination)
        end.delete_if(&:nil?).max)
      end.max || 0
      raw_points = @cards.raw_integer_value
      if combo_points > raw_points
        combo_points
      else
        raw_points
      end
    end

    def inspect
      "#<#{self.class.name} @name=\"#{name}\", @cards=#{cards.inspect}>"
    end

  end
end
