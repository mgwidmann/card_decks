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

  describe '#jokers' do

    it 'can include jokers in the deck' do
      deck.with_jokers!
      deck.size.should == 54
    end

  end

  describe '#deal' do

    it 'can deal to anonymous players' do
      deck.deal(5).name.should =~ /Player \d+/
    end

    it 'removes the cards from the deck' do
      deck.size.should == 52
      deck.deal(5)
      deck.size.should == 47
    end

    it 'tracks that the cards are currently in hand' do
      deck.deal(5)
      deck.inhand.size.should == 5
      deck.size.should == 47
    end

  end

  describe "#return" do

    let(:hand) { deck.deal(5) }
    let(:second_hand) { deck.deal(5) }

    before(:each) { hand.size.should == 5 }

    it 'can return a hand' do
      deck.return(hand)
    end

    it 'can return a list of hands' do
      deck.return(hand, second_hand)
    end

    it 'can return individual cards' do
      deck.return(*hand.cards)
    end

    after :each do
      (deck.size + deck.used.size).should == 52
    end

  end

  describe '#reset!' do
    # Deal cards and lose reference to hand
    before :each do
      3.times { deck.deal(5) }
    end

    it 'can reset the deck' do
      deck.reset!
      deck.size.should == 52
    end

    it 'will reset the used automatically when cards are available' do
      deck.hands.each(&:discard!)
      deck.deal(50).size.should == 50
    end

    it 'will only deal the cards it has left' do
      deck.deal(50).size.should == 37
    end

  end

end
