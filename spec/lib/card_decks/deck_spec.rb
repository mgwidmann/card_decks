require 'spec_helper'

describe CardDecks::Deck do

  let(:deck) { new }

  it 'is enumberable' do
    deck.should be_a(Enumberable)
  end

end
