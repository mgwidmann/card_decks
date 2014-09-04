require 'spec_helper'
require 'ostruct'

describe CardDecks::Hand do

  let(:deck) { CardDecks::Deck.new }
  let(:cards) { deck.take(5) }
  let(:hand) { CardDecks::Hand.new *cards, deck: deck, name: "Joe" }

  it 'is enumerable' do
    CardDecks::Hand.included_modules.should include(CardDecks::Decks::Enumerable)
  end

  it 'includes deck values' do
    CardDecks::Hand.included_modules.should include(CardDecks::Decks::Values)
  end

  it 'has a name field' do
    hand.name.should == "Joe"
  end

  it 'has a list of cards' do
    hand.cards.should == cards
  end

  it 'can be discarded' do
    cards # Call to activate take
    hand.discard!
    hand.cards.should be_empty
  end

  it 'should raise an exception when creating a hand without a reference to the deck' do
    expect { CardDecks::Hand.new }.to raise_exception
  end

  it 'should raise an exception when creating a hand cards from a different deck' do
    d = CardDecks::Deck.new
    c = d[0..5]
    expect { CardDecks::Hand.new *c, deck: deck }.to raise_exception
  end

  it 'should have an integer value' do
    hand.integer_value.should be_a(Fixnum)
  end

end
