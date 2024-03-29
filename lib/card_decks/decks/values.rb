module CardDecks
  module Decks
    module Values
      extend ActiveSupport::Concern

      DEFAULT_SUITS = {spades: 4, clubs: 3, hearts: 2, diamonds: 1}

      DEFAULT_FACE_VALUES = {
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

      DEFAULT_FACE_CARDS = [:jack, :queen, :king]

      DEFAULT_JOKER_COUNT = 0
      DEFAULT_JOKER_VALUE = 14

      # Configured suit hash for this deck.
      #
      # @see #CardDecks::Decks::Values::DEFAULT_SUITS
      # @return [Hash]
      def suits
        @suits ||= self.class.suits
      end

      # Configured face_cards list for this deck.
      #
      # @see #CardDecks::Decks::Values::DEFAULT_FACE_CARDS
      # @return [Array<Symbol>]
      def face_cards
        @face_cards ||= self.class.face_cards
      end

      # Configured face values for each card in this deck.
      #
      # @see #CardDecks::Decks::Values::DEFAULT_FACE_VALUES
      # @return [Hash]
      def face_values
        @face_values ||= self.class.face_values
      end

      attr_writer :joker_value

      # Configured joker value for this deck instance.
      #
      # @return [Fixnum] Joker's value
      def joker_value
        @joker_value ||= self.class.joker_value
      end

      # Builds a full deck without shuffling.
      def full_deck
        wild_config = respond_to?(:wild_config) ? self.wild_config : {}
        suits.keys.product(face_values.keys).map do |card_data|
          wild = (wild_config[card_data.second] || []).include?(card_data.first)
          CardDecks::Card.new deck: self, suit: card_data.first, value: card_data.second, wild: wild
        end +
        (self.class.joker_count.times.map do
          CardDecks::Card.new deck: self, suit: :joker, value: :joker, wild: wild_config.has_key?(:joker)
        end)
      end

      module ClassMethods

        # Includes jokers in instances created
        def with_jokers!(amount = 2)
          @joker_count = amount
        end

        # Fetches the current configured joker count.
        def joker_count
          @joker_count ||= DEFAULT_JOKER_COUNT
        end

        attr_writer :joker_value
        # Fetches the current configured joker value for newly instantiated decks.
        def joker_value
          @joker_value ||= DEFAULT_JOKER_VALUE
        end

        # Fetches the suit hash.
        #
        # @see #CardDecks::Decks::Values::DEFAULT_SUITS
        # @return [Hash]
        def suits
          @suits ||= DEFAULT_SUITS
        end

        # Fetches the face_cards list.
        #
        # @see #CardDecks::Decks::Values::DEFAULT_FACE_CARDS
        # @return [Array<Symbol>]
        def face_cards
          @face_cards ||= DEFAULT_FACE_CARDS
        end

        # Fetches the face_values hash.
        #
        # @see #CardDecks::Decks::Values::DEFAULT_FACE_VALUES
        # @return [Hash]
        def face_values
          @face_values ||= DEFAULT_FACE_VALUES
        end

      end

    end
  end
end
