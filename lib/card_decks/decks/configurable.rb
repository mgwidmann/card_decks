module CardDecks
  module Decks
    module Configurable
      include CardDecks::Decks::Values
      extend ActiveSupport::Concern

      # Makes a particular card or card for any suit wild on this deck instance.
      #
      # @param value [Symbol] Symbol of card (:ace, :two, ... :queen, :king)
      # @param suits [*Symbol] Symbols of suits to apply to (defaults to all)
      # @param block [Proc] Custom block allows identifying wilds by hand.
      def wild value = nil, *suits, &block
        @wilds ||= {}
        if block_given?
          @wilds[:blocks] ||= []
          @wilds[:blocks] << block
        else
          if value == :joker
            @wilds[:joker] = true
          else
            suits = self.class.suits.keys if suits.empty?
            @wilds[value] = suits
          end
        end
        update_wilds!
      end

      # Updates the current deck for any changes in the wild configuration.
      # Automatically called after wild configuration on the deck instance. Needs
      # to be called manually after changes to the class configuration.
      def update_wilds!
        @wilds.each do |value, suits|
          (@cards || []).select do |card|
            if value == :blocks
              blocks = suits
              blocks.any? {|b| b.call(card) }
            else
              card.value == value && (suits == true || suits.include?(card.suit))
            end
          end.each(&:wild!)
        end
      end

      # Returns the cards which are wild in this deck.
      #
      # @return [Array<CardDecks::Card>]
      def wilds
        (@cards || []).select(&:wild?)
      end

      # Wild configuration merged with class' wild configuration.
      #
      # @return [Hash]
      def wild_config
        (@wilds ||= {}).merge(self.class.wild_config)
      end

      # Makes suits wild
      def suits_wild!
        @suits_wild = true
      end

      # Checks if suits are wild
      def suits_wild?
        @suits_wild.nil? ? self.class.suits_wild? : @suits_wild
      end

      # Add a combination to be checked when evaluating hands. These will boost
      # scores of hands and are the basis for creating a game by putting all your
      # game rules in here.
      def add_combination &block
        @combinations ||= []
        @combinations << block
      end

      attr_writer :combinations
      # Gets all combination Proc objects.
      #
      # @return [Array<Proc>]
      def combinations
        (@combinations ||= []) + self.class.combinations
      end

      module ClassMethods

        attr_accessor :wilds

        # Class configuration for setting wild values. Makes a particular card or card for any suit wild on this deck instance.
        #
        # @param value [Symbol] Symbol of card (:ace, :two, ... :queen, :king)
        # @param suits [*Symbol] Symbols of suits to apply to (defaults to all)
        # @param block [Proc] Custom block allows identifying wilds by hand.
        def wild value = nil, *suits, &block
          @wilds ||= {}
          if block_given?
            @wilds[:blocks] ||= []
            @wilds[:blocks] << block
          else
            if value == :joker
              @wilds[:joker] = true
            else
              suits = self.suits.keys if suits.empty?
              @wilds[value] = suits
            end
          end
        end

        # Class configuration for wild values.
        #
        # @return [Hash]
        def wild_config
          @wilds ||= {}
        end

        # Class configuration for suits being wild
        def suits_wild!
          @suits_wild = true
        end

        # Returns class configuration for suits build wild
        def suits_wild?
          @suits_wild
        end

        # Adds a combination to the list of combinations for this class.
        #
        # @param method [Symbol, String] Method name to call on the instance to run the combination
        def add_combination method = nil, &block
          @combinations ||= []
          if block_given?
            @combinations << block
          elsif method
            @combinations << method.to_sym
          end
        end

        attr_writer :combinations

        # Gets class level combination Proc objects.
        #
        # @return [Array<Proc>]
        def combinations
          @combinations ||= []
        end

      end

    end
  end
end
