module CardDecks
  class Deck
    include Enumerable

    def new
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
        Enumerator.new(self, :each)
      end
    end

  end
end
