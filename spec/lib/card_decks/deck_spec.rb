require 'spec_helper'
require 'ostruct'

describe CardDecks::Deck do

  let(:deck) { CardDecks::Deck.new }

  it 'is enumerable' do
    deck.should be_a(Enumerable)
  end

  describe 'enumerable' do

    # Remove test coupling to Card object
    before :each do
      deck.cards = [OpenStruct.new(suit: :ace, value: :spades),
        OpenStruct.new(suit: :ace, value: :diamonds)]
    end

    it 'supports each' do
      deck.each {|c| c.should be_a(OpenStruct) }
    end

    it 'supports map' do
      deck.map {|c| :value }.uniq.should == [:value]
    end

  end


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
