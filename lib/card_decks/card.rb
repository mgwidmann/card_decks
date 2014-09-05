module CardDecks
  class Card

    attr_accessor :deck, :suit, :value, :integer_value, :wild

    SPADE = "\u2664"
    CLUB = "\u2667"
    HEART = "\u2661"
    DIAMOND = "\u2662"

    def initialize data = {}
      @deck = data[:deck]
      raise 'Cannot create a card without the reference to the deck' unless @deck
      @suit = data[:suit]
      @value = data[:value]
      @integer_value = data[:integer_value] || @deck.face_values[@value] ||
        (@value == :joker && @deck.joker_value) || raise("Cannot find integer value for #{@value}")
      @wild = data[:wild] || (@deck.wild_config[:blocks] || []).any? {|block| block.call(self) }
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

    def suits_wild?
      @deck.suits_wild?
    end

    def + other_card
      if other_card.is_a?(CardDecks::Card)
        self.integer_value + other_card.integer_value
      else
        self.integer_value
      end
    end

    def inspect
      const = self.class.const_defined?(self.suit.to_s.singularize.upcase) ? self.class.const_get(self.suit.to_s.singularize.upcase) : "?"
      "#{const} #{self.value.to_s.titleize}"
    end

  end
end
