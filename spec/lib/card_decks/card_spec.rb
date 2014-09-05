require 'spec_helper'

describe CardDecks::Card do

  let(:deck) { CardDecks::Deck.new }
  let(:card) { CardDecks::Card.new(deck: deck, value: :jack, suit: :spades) }

  it 'can create a card' do
    card.should be_a(CardDecks::Card)
  end

  it 'has a suit' do
    card.suit.should == :spades
  end

  it 'has a value' do
    card.value.should == :jack
  end

  it 'has an integer value' do
    card.integer_value.should == 11
  end

  it 'defaults wild? to false' do
    card.wild?.should be_falsey
  end

  it 'can be made wild' do
    card.wild!
    card.wild.should be true
  end

  it 'can access the deck' do
    card.deck.should be_a(CardDecks::Deck)
  end

  it 'should raise an exception when creating a card without a reference to the deck' do
    expect { CardDecks::Card.new }.to raise_exception
  end

  it 'should print a pretty inspect' do
    card.inspect.should == "#{CardDecks::Card::SPADE} Jack"
  end

end
