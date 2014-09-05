module CardDecks
  class Deck
    include CardDecks::Decks::Values
    include CardDecks::Decks::Configurable
    include CardDecks::Decks::Enumerable

    attr_accessor :used, :inhand, :hands

    # Creates a new deck that has been preconfigured via class methods or is
    # just a basic 52 card deck already shuffled. Jokers are disabled by default.
    # To add them in, simply call `with_jokers!` to include them in the current deck.
    def initialize
      @cards = full_deck.shuffle
      @used = []
      @inhand = []
      @hands  = []
    end

    # Adds into the current list of cards the number of jokers passed in.
    #
    # @param [Fixnum] amount Amount of jokers to include in the deck, default 2.
    def with_jokers!(amount = 2)
      amount.times do
        @cards << CardDecks::Card.joker(self)
      end
    end

    @@anonymous_player_count = 0
    # Deals any number of cards out of the deck making sure to track them properly.
    #
    # @param [Fixnum] amount Amount of cards to deal from the deck, default 5.
    # @param [String] player_name The name of the player to attach the hand to.
    # @return CardDecks::Hand
    def deal amount = 5, player_name = "Player #{@@anonymous_player_count += 1}"
      cards = amount.times.map do
        card = take(1).first
        unless card
          reset_unused!
          card = take(1).first
        end
        @inhand << card
        card
      end
      hand = CardDecks::Hand.new *cards, deck: self, name: player_name
      @hands << hand
      hand
    end

    # Returns any number of hands to the deck. These cards are added into the
    # used pile and will not be reused until after the deck is fully emptied.
    #
    # @param [CardDecks::Hand, Array<CardDecks::Card>, CardDecks::Card] hands List of cards or hands to return
    def return *hands
      hands.each do |hand_or_cards|
        cards = (hand_or_cards.is_a?(CardDecks::Hand) ? hand_or_cards.cards : Array.wrap(hand_or_cards))
        @used += cards
        @inhand.delete_if {|c| cards.include?(c) }
        @hands.each {|h| h.cards.delete_if {|c| cards.include?(c) } }
      end
    end

    # Resets the deck back to its new state. All hands are discarded, the used pile
    # is emptied and added back to the card list.
    def reset!
      @hands.each(&:discard!)
      @cards += @used
      @used = []
    end

    # Resets just the unused pile back to the card list. Does not discard all hands.
    def reset_unused!
      @cards += @used
      @used = []
    end

    # Determines a winner by sorting the hands by the provided block
    #
    # @param [Proc] block Block of custom sort function between hands.
    def winner &block
      if block_given?
        @hands.sort(&block)
      end
    end

  end
end
