module CardDecks
  class Deck
    include Enumerable

    attr_accessor :cards

    def initialize
      @cards = []
    end

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
