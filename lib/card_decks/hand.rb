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
      @integer_value ||= cards.reduce(0) {|sum,card| sum + card.integer_value }
    end

  end
end
