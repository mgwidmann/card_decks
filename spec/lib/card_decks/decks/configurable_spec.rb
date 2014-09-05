require 'spec_helper'

class MyClassConfiguredDeck < CardDecks::Deck; end
class MyInstanceConfiguredDeck < CardDecks::Deck; end

describe CardDecks::Decks::Configurable do

  context 'class object configuration' do

    before :each do
      MyClassConfiguredDeck.wilds = {}
      MyClassConfiguredDeck.with_jokers!(0)
      MyClassConfiguredDeck.wild :ace, :spades
    end

    it 'can access wilds' do
      MyClassConfiguredDeck.wilds.should == {ace: [:spades]}
    end

    it 'setting value and suit' do
      MyClassConfiguredDeck.wild :queen, :diamonds
      MyClassConfiguredDeck.wilds.should == {ace: [:spades], queen: [:diamonds]}
    end

    it 'setting just value' do
      MyClassConfiguredDeck.wild :jack
      MyClassConfiguredDeck.wilds.should == {ace: [:spades], jack: [:spades, :clubs, :hearts, :diamonds]}
    end

    it 'setting a joker' do
      MyClassConfiguredDeck.with_jokers!
      MyClassConfiguredDeck.wild :joker
      MyClassConfiguredDeck.wilds.should == {ace: [:spades], joker: true}
    end

    it 'setting suits wild' do
      MyClassConfiguredDeck.suits_wild!
      MyClassConfiguredDeck.suits_wild?.should be true
    end

    it 'setting wild blocks' do
      block = Proc.new do |card|
        card.integer_value > 12
      end
      MyClassConfiguredDeck.wild &block
      MyClassConfiguredDeck.wilds.should == {ace: [:spades], blocks: [block]}
    end

    it 'wild blocks makes the correct cards wild' do
      MyClassConfiguredDeck.wild do |card|
        card.integer_value > 12
      end
      deck = MyClassConfiguredDeck.new
      deck.wilds.map {|c| "#{c.value} of #{c.suit}" }.sort.should == [
        "ace of spades", "joker of joker", "joker of joker", "king of clubs", "king of diamonds", "king of hearts", "king of spades"
      ]
    end

  end

  context 'instance object configuration' do

    let(:deck) { MyInstanceConfiguredDeck.new }

    it 'can access wilds' do
      deck.wilds.should == []
    end

    it 'setting value and suit' do
      deck.wild :ace, :diamonds
      deck.wilds.map {|c| "#{c.value} of #{c.suit}" }.sort.should == ["ace of diamonds"]
    end

    it 'setting just value' do
      deck.wild :king
      deck.wilds.map {|c| "#{c.value} of #{c.suit}" }.sort.should == [
        "king of clubs", "king of diamonds", "king of hearts", "king of spades"
      ]
    end

    it 'setting a joker' do
      deck.with_jokers!
      deck.wild :joker
      deck.wilds.map {|c| "#{c.value} of #{c.suit}" }.sort.should == [
        "joker of joker", "joker of joker"
      ]
    end

    it 'setting suits wild' do
      deck.suits_wild!
      deck.suits_wild?.should be true
    end

    it 'suits wild makes all cards have wild suits' do
      deck.suits_wild!
      deck.cards.all? {|card| card.suits_wild? }
    end

    it 'setting wild blocks' do
      block = Proc.new do |card|
        card.integer_value > 12
      end
      deck.wild &block
      deck.wilds.map {|c| "#{c.value} of #{c.suit}" }.sort.should == [
        "king of clubs", "king of diamonds", "king of hearts", "king of spades"
      ]
    end

    it 'can add and fetch combinations' do
      combination = Proc.new do |*cards|
        if cards.map(&:integer_value).uniq!.size == 1
          # Return the number of matches times the total value
          cards.reduce(&:+) * cards.size
        end
      end
      deck.add_combination &combination
      deck.combinations.should == [combination]
    end

    it 'adds card combinations to increase their point value' do
      deck.add_combination do |*cards|
        # If cards all have the same integer value then multiply their sum
        # by the number of cards. This is a basic pairs, tripples, ect combo
        if cards.map(&:integer_value).uniq!.size == 1
          cards.reduce(&:+) * cards.size
        end
      end
      cards = deck.take(ace: [:spades,:diamonds])
      hand = CardDecks::Hand.new *cards, deck: deck
      # Two aces at value 1 each should be doubled to 4
      hand.integer_value.should == 4
    end

  end

end
