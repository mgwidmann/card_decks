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
        @cards.pop(index_or_range)
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
