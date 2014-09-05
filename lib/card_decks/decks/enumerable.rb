module CardDecks
  module Decks
    module Enumerable
      include ::Enumerable

      attr_accessor :cards

      def << item
        @cards << item
        self
      end

      def [] index
        @cards[index]
      end

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

      def size
        @cards.size
      end

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
