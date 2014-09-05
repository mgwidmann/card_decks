module CardDecks
  module Decks
    module Enumerable
      include ::Enumerable

      attr_accessor :cards

      # Allows insertion of new items into the list.
      #
      # @param item [CardDecks::Card] Card to push
      def << item
        @cards << item
        self
      end

      # Fetches card at index
      #
      # @param index [Fixnum] Index to fetch card at
      def [] index
        @cards[index]
      end

      # Takes a certain number (or range) of cards from the deck. Additionally,
      # A hash can be provided to name specific cards to take those from the
      # deck. Take is useful for temporarily or permanently removing certain
      # cards from the deck. For example, if a game doesn't use Aces. Cards
      # taken with take will not be tracked and must be manually inserted back
      # into the deck.
      #     # Single suit
      #     {ace: :spades}
      #     # Multiple suits
      #     {king: [:hearts, :diamonds]}
      #
      # @param index_or_range [Fixnum, Range, Hash]
      # @return [CardDecks::Card, Array<CardDecks::Card>]
      def take index_or_range
        if index_or_range.is_a?(Fixnum) || index_or_range.is_a?(Range)
          @cards.pop(index_or_range)
        elsif index_or_range.is_a?(Hash)
          index_or_range.map do |value, suits|
            cards = @cards.select {|c| c.value == value && Array.wrap(suits).include?(c.suit) }
            cards.each {|c| @cards.delete(c) }
            cards
          end.flatten
        end
      end

      # Returns the count of cards in the deck.
      #
      # @return [Fixnum]
      def size
        @cards.size
      end

      # Allows iteration on the deck object, looping through each card.
      #
      # @return [Enumerable] When no block is given.
      def each
        if block_given?
          @cards.each {|c| yield(c) }
        else
          Enumerator.new(self, :each)
        end
      end
    end
  end
end
