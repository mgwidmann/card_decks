module CardDecks
  class Deck
    include CardDecks::Decks::Enumerable
    include CardDecks::Decks::Values
    include CardDecks::Decks::Configurable

    attr_accessor :used, :inhand, :hands
    def initialize
      @cards = full_deck.shuffle
      @used = []
      @inhand = []
      @hands  = []
    end

    def with_jokers!(amount = 2)
      amount.times do
        @cards << CardDecks::Card.joker(self)
      end
    end

    @@anonymous_player_count = 0
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

    def return *hands
      hands.each do |hand_or_cards|
        cards = (hand_or_cards.is_a?(CardDecks::Hand) ? hand_or_cards.cards : Array.wrap(hand_or_cards))
        @used += cards
        @inhand.delete_if {|c| cards.include?(c) }
        @hands.each {|h| h.cards.delete_if {|c| cards.include?(c) } }
      end
    end

    def reset!
      @hands.each(&:discard!)
      @cards += @used
      @used = []
    end

    def reset_unused!
      @cards += @used
      @used = []
    end

  end
end
