module CardDecks
  class Deck
    include CardDecks::Decks::Enumerable
    include CardDecks::Decks::Values

    attr_accessor :unused, :inhand
    def initialize
      @cards = full_deck.shuffle
      @unused = []
      @inhand = []
    end

    def with_jokers!(amount = 2)
      amount.times do
        @cards << CardDecks::Card.joker(self)
      end
    end

    @@anonymous_player_count = 0
    def deal amount = 5, player_name = "Player #{@@anonymous_player_count += 1}"
      cards = amount.times.map do
        card = self.first
        @cards = @cards[1..@cards.size]
        @inhand << card
        card
      end
      CardDecks::Hand.new *cards, deck: self, name: player_name
    end

    def return *hands
      hands.each do |hand_or_cards|
        cards = (hand_or_cards.is_a?(CardDecks::Hand) ? hand_or_cards.cards : Array.wrap(hand_or_cards))
        @unused += cards
        @inhand.delete_if {|c| cards.include?(c) }
      end
    end

  end
end
