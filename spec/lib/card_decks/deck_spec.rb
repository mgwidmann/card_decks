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

end
