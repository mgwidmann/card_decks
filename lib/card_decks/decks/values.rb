module CardDecks
  module Decks
    module Values
      extend ActiveSupport::Concern

      @@suits = {spades: 4, clubs: 3, hearts: 2, diamonds: 1}
      def suits
        @suits ||= @@suits
      end

      @@face_values = {
        ace: 1,
        two: 2,
        three: 3,
        four: 4,
        five: 5,
        six: 6,
        seven: 7,
        eight: 8,
        nine: 9,
        ten: 10,
        jack: 11,
        queen: 12,
        king: 13
      }
      def face_values
        @face_values ||= @@face_values
      end

      attr_writer :joker_value
      @@joker_value = 13
      def joker_value
        @joker_value ||= @@joker_value
      end

      def full_deck
        suits.keys.product(face_values.keys).map do |card_data|
          wild_config = respond_to?(:wild_config) ? self.wild_config : {}
          wild = (wild_config[card_data.second] || []).include?(card_data.first)
          CardDecks::Card.new deck: self, suit: card_data.first, value: card_data.second, wild: wild
        end
      end

    end
  end
end
