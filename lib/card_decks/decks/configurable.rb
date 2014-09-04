module CardDecks
  module Decks
    module Configurable
      extend ActiveSupport::Concern

      def wild value, *suits
        @wilds ||= {}
        suits = @@suits.keys if suits.empty?
        @wilds[value] = suits
        update_wilds!
      end

      def update_wilds!
        @wilds.each do |value, suits|
          (@cards || []).select do |card|
            card.value == value && suits.include?(card.suit)
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

        cattr_accessor :wilds

        def wild value, *suits
          @@wilds ||= {}
          suits = @@suits.keys if suits.empty?
          @@wilds[value] = suits
        end

        def wild_config
          @@wilds ||= {}
        end

      end

    end
  end
end
