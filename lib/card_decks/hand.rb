module CardDecks
  class Hand
    include CardDecks::Decks::Enumerable
    include CardDecks::Decks::Values

    attr_accessor :cards, :deck, :name

    # Creates an enumerable list of cards which are a subset of cards pulled from
    # the deck instance. The deck object is expected as options attached to the
    # end of the splat of cards.
    #
    # @param cards [*CardDecks::Card] A splat array of cards
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

    # Returns all the cards in this hand to the deck. This method is called by the
    # deck when reset! is called. After calling, the cards in this hand are all cleared.
    def discard!
      deck.return(self)
      self.cards = []
    end

    # Computes the highest possible integer value for this hand based on all deck rules
    # and returns that value. Note that all unique card combinations are tried and so
    # for a large number of cards with lots of rule sets this call could become heavy.
    #
    # @return Fixnum
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

    # Pretty prints the hand for better legibility
    #
    # @return String
    def inspect
      "#<#{self.class.name} @name=\"#{name}\", @cards=#{cards.inspect}>"
    end

  end
end
