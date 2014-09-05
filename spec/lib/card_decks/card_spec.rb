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

  it 'should allow multiplication' do
    (card * card).should == card.integer_value * card.integer_value
  end

  it 'should allow addition' do
    (card + card).should == card.integer_value + card.integer_value
  end

  it 'should allow division' do
    (card / card).should == card.integer_value / card.integer_value
  end

  it 'should allow subtraction' do
    (card - card).should == card.integer_value - card.integer_value
  end

  it 'should allow modulus' do
    (card % card).should == card.integer_value % card.integer_value
  end

  it 'should allow power' do
    (card ** card).should == card.integer_value ** card.integer_value
  end

  context '#face?' do

    let(:jack) { CardDecks::Card.new(deck: deck, value: :jack, suit: :spades) }
    let(:queen) { CardDecks::Card.new(deck: deck, value: :queen, suit: :spades) }
    let(:king) { CardDecks::Card.new(deck: deck, value: :king, suit: :spades) }
    let(:ten) { CardDecks::Card.new(deck: deck, value: :ten, suit: :spades) }
    let(:nine) { CardDecks::Card.new(deck: deck, value: :nine, suit: :spades) }
    let(:two) { CardDecks::Card.new(deck: deck, value: :two, suit: :spades) }
    let(:ace) { CardDecks::Card.new(deck: deck, value: :ace, suit: :spades) }

    it 'is true for jack' do
      jack.face?.should be true
    end

    it 'is true for queen' do
      queen.face?.should be true
    end

    it 'is true for king' do
      king.face?.should be true
    end

    it 'is not true for ten' do
      ten.face?.should_not be true
    end

    it 'is not true for nine' do
      nine.face?.should_not be true
    end

    it 'is not true for ace' do
      ace.face?.should_not be true
    end

    it 'is not true for two' do
      two.face?.should_not be true
    end

  end

end
