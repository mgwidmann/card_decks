module CardDecks
  class Card

    attr_accessor :deck, :suit, :value, :integer_value, :wild

    def initialize data = {}
      @deck = data[:deck]
      raise 'Cannot create a card without the reference to the deck' unless @deck
      @suit = data[:suit]
      @value = data[:value]
      @integer_value = data[:integer_value] || @deck.face_values[@value]
    end

    def self.joker(deck)
      new(deck: deck, suit: :joker, value: :joker, integer_value: deck.joker_value)
    end

    def wild?
      wild
    end

    def wild!
      @wild = true
    end

  end
end
