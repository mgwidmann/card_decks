module CardDecks
  module Decks
    module Configurable
      include CardDecks::Decks::Values
      extend ActiveSupport::Concern

      def wild value, *suits
        @wilds ||= {}
        if value == :joker
          @wilds[:joker] = true
        else
          suits = self.class.suits.keys if suits.empty?
          @wilds[value] = suits
        end
        update_wilds!
      end

      def update_wilds!
        @wilds.each do |value, suits|
          (@cards || []).select do |card|
            card.value == value && (suits == true || suits.include?(card.suit))
          end.each(&:wild!)
        end
      end

      def wilds
        (@cards || []).select(&:wild?)
      end

      def wild_config
        (@wilds ||= {}).merge(self.class.wild_config)
      end

      module ClassMethods

        attr_accessor :wilds

        def wild value, *suits
          @wilds ||= {}
          if value == :joker
            @wilds[:joker] = true
          else
            suits = self.suits.keys if suits.empty?
            @wilds[value] = suits
          end
        end

        def wild_config
          @wilds ||= {}
        end

      end

    end
  end
end
