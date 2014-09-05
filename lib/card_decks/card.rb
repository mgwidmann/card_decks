module CardDecks
  class Card
    include Comparable

    attr_accessor :deck, :suit, :value, :integer_value, :wild
    alias_method :raw_integer_value, :integer_value

    SPADE = "\u2664"
    CLUB = "\u2667"
    HEART = "\u2661"
    DIAMOND = "\u2662"

    # Creates a new card instance. Must have a reference back to the deck it belongs.
    # Automatically figures out its integer value if it is not passed in.
    #
    # @param [Hash] data Metadata hash containing card information.
    def initialize data = {}
      @deck = data[:deck]
      raise 'Cannot create a card without the reference to the deck' unless @deck
      @suit = data[:suit]
      @value = data[:value]
      @integer_value = data[:integer_value] || @deck.face_values[@value] ||
        (@value == :joker && @deck.joker_value) || raise("Cannot find integer value for #{@value}")
      @wild = data[:wild] || (@deck.wild_config[:blocks] || []).any? {|block| block.call(self) }
    end

    # Creates a joker for the given deck. Uses the deck.joker_value configuration item
    # to set its joker value.
    #
    # @return CardDecks::Card
    def self.joker(deck)
      new(deck: deck, suit: :joker, value: :joker, integer_value: deck.joker_value)
    end

    # Reports if this card is wild or not.
    #
    # @return [true, false]
    def wild?
      wild
    end

    # Makes this card flagged as wild. Wild is used as just metadata about the
    # card. It can be used to write custom card combination rules.
    def wild!
      @wild = true
    end

    # Checks if suits are considered wild by checking with the deck instance.
    def suits_wild?
      @deck.suits_wild?
    end

    # Fetches the value of the suit for card value computation if it is necessary
    # to differentiate between suits with value. This can be used as a multiplier or
    # to add to the final integer_value to make certain suits win over others in
    # certain combinations.
    #
    # @return [Fixnum] Configured value for this suit.
    def suit_value
      deck.suits[suit]
    end

    # Checks if this card is considered a "face card". This helper is available just
    # for help writing combinations.
    def face?
      deck.face_cards.include?(self.value)
    end

    # Mathematical operations
    [:+, :*, :/, :-, :%, :**].each do |op|
      define_method op do |other_card|
        if other_card.is_a?(CardDecks::Card)
          self.integer_value.send(op, other_card.integer_value)
        else
          self.integer_value.send(op, other_card)
        end
      end
    end

    # Comparison between cards. The integer value as well as the suit_value is used
    # in comparing between cards. In a tie between integer_value, suit value will
    # be the determining factor.
    #
    # @return [Fixnum]
    def <=>(other_card)
      [integer_value, suit_value] <=> [other_card.integer_value, suit_value]
    end

    # Pretty prints the card for better display to the user. Uses unicode values
    # to display spades, clubs, hearts and diamonds.
    def inspect
      const = self.class.const_defined?(self.suit.to_s.singularize.upcase) ? self.class.const_get(self.suit.to_s.singularize.upcase) : "?"
      "#{const} #{self.value.to_s.titleize}"
    end

  end
end
