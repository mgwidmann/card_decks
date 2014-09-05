require 'spec_helper'
require 'ostruct'

describe CardDecks::Decks::Enumerable do

  let(:deck) { CardDecks::Deck.new }

  it 'is enumerable' do
    deck.should be_a(Enumerable)
  end

  describe 'enumerable' do

    # Remove test coupling to Card object
    before :each do
      deck.cards = [OpenStruct.new(value: :ace, suit: :spades),
        OpenStruct.new(value: :ace, suit: :diamonds)]
    end

    it 'supports each' do
      deck.each {|c| c.should be_a(OpenStruct) }
    end

    it 'supports map' do
      deck.map {|c| :value }.uniq.should == [:value]
    end

    it 'supports << insertion' do
      deck << CardDecks::Card.new(deck: deck, suit: :joker, value: :joker)
    end

    it 'can retrieve an enumerable object' do
      deck.each.should be_a(Enumerable)
    end

    it 'can take numbers of cards' do
      deck.take(1).size.should == 1
    end

    it 'can take specific cards' do
      deck.take(ace: :spades).size.should == 1
    end

    it 'can take multiple specific cards' do
      deck.take(ace: :spades, king: :spades).size.should == 2
    end

  end

end
