require 'spec_helper'
require 'ostruct'

describe CardDecks::Deck do

  let(:deck) { CardDecks::Deck.new }

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

  describe '#winner' do

    before :each do
      @joe = deck.deal(5, 'Joe')
      @frank = deck.deal(5, 'Frank')
      @bob = deck.deal(5, 'Bob')
      @name_to_hand_map = {'Joe' => @joe, 'Frank' => @frank, 'Bob' => @bob}
    end

    it 'should allow a custom winner function' do
      winner = deck.winner do |player, other_player|
        other_player.integer_value <=> player.integer_value
      end
      values = @name_to_hand_map.values.map {|hand| hand.integer_value }
      # Find the player name who has the highest integer value of their hand
      actual_winner = @name_to_hand_map.keys[values.index(values.max)]
      winner.first.name.should == actual_winner
    end

  end

end
