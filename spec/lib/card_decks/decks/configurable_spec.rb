require 'spec_helper'

class MyClassConfiguredDeck < CardDecks::Deck; end
class MyInstanceConfiguredDeck < CardDecks::Deck; end

describe CardDecks::Decks::Configurable do

  context 'class object configuration' do

    before :each do
      MyClassConfiguredDeck.wilds = {}
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


  end

end
