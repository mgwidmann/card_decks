require 'spec_helper'

class MyDeck < CardDecks::Deck; end

describe CardDecks::Decks::Configurable do

  before :each do
    MyDeck.wild :ace, :spades
  end

  it 'is configurable from a class method' do
    MyDeck.wilds.should == {ace: [:spades]}
  end

  it 'is configurable from an instance object' do
    deck = MyDeck.new
    deck.wild :ace, :diamonds
    deck.wilds.map {|c| "#{c.value} of #{c.suit}" }.should == ["ace of spades", "ace of diamonds"]
  end

end
