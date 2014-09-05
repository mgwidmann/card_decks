module CardDecks
  module Decks
    module Configurable
      include CardDecks::Decks::Values
      extend ActiveSupport::Concern

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

      def wilds
        (@cards || []).select(&:wild?)
      end

      def wild_config
        (@wilds ||= {}).merge(self.class.wild_config)
      end

      def suits_wild!
        @suits_wild = true
      end

      def suits_wild?
        @suits_wild.nil? ? self.class.suits_wild? : @suits_wild
      end

      module ClassMethods

        attr_accessor :wilds

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

        def wild_config
          @wilds ||= {}
        end

        def suits_wild!
          @suits_wild = true
        end

        def suits_wild?
          @suits_wild
        end

      end

    end
  end
end
