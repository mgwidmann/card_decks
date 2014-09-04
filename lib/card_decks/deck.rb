module CardDecks
  class Deck
    include CardDecks::Decks::Enumerable
    include CardDecks::Decks::Values

    def initialize
      @cards = full_deck.shuffle
    end

    def with_jokers!(amout = 2)
      amount.times do
        @cards << CardDecks::Card.joker(self)
      end
    end

  end
end
