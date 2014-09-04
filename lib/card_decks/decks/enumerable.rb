module CardDecks
  module Decks
    module Enumerable
      include ::Enumerable

      attr_accessor :cards

      def << item
        @cards << item
        self
      end

      def each
        if block_given?
          @cards.each {|c| yield(c) }
        else
          Enumerable.new(self, :each)
        end
      end
    end
  end
end
