require 'spec_helper'

describe CardDecks::Decks::Values do

  let(:deck) { CardDecks::Deck.new }

  describe 'card values' do

    it 'creates a full deck of cards' do
      deck.full_deck.size.should == 52
    end

    it 'creates a shuffled card deck with new' do
      deck.first.should_not == CardDecks::Deck.new.first
    end

    it 'creates a deck with only four suits' do
      deck.reduce([]) {|suits, c| suits << c.suit }.uniq.sort.should == [:clubs, :diamonds, :hearts, :spades]
    end

    it 'creates a deck with only one of each kind' do
      deck.reduce([]) {|values, c| values << c.value }.uniq.sort.should == [
        :ace, :eight, :five, :four, :jack, :king, :nine, :queen, :seven, :six, :ten, :three, :two
      ]
    end

  end

end
