# CardDecks

A digital deck of cards that can be used to implement any card game desired!

## Installation

Add this line to your application's Gemfile:

    gem 'card_decks'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install card_decks

## Usage

#### Example of using the deck of cards

```ruby
# Returns an already shuffled list of cards
deck = CardDecks::Deck.new

joe   = deck.deal(5, 'Joe') # Optional second parameter
frank = deck.deal(5, 'Frank')
bob   = deck.deal(5, 'Bob')

# For this (simple) game, the player with the highest total card
# value will be declared the winner
winner = deck.winner do |hand_one, hand_two|
  hand_two.integer_value <=> hand_one.integer_value
end
puts "#{winner.first.name} wins the game!"
```

#### Configuring game rules

Game rules can be configured on a per deck basis or via inheritance.

##### Wild cards

```ruby
deck = CardDecks::Deck.new

# Make the Ace of Spades wild
deck.wild(:ace, :spades)
# Make all Kings wild
deck.wild(:king)
# Custom wild declaration -- Cards with even value are wild
deck.wild do |card|
  card.integer_value % 2
end
# Make wild cards also make suits wild
deck.suits_wild!

class MyDeck < CardDecks::Deck

  wild :joker
  suits_wild!

end
```

##### Card Combinations

Card combinations can be created to hold additional card value when they are together.

For example, matching cards with the same value could be worth more when together.

```ruby
deck = CardDecks::Deck.new

# Return the point value of the list of cards for this rule
deck.add_combination do |*cards|
  # To make pairs, triples and all four matches more valuable
  # we return an increased point value for this list of cards

  # When all the cards are the same value
  if cards.map(&:integer_value).uniq!.size == 1
    # Return the number of matches times the total value
    cards.reduce(&:+) * cards.size
  end
  # Returning nil simply means use the raw card value
end

# And the class version
class MyDeck < CardDecks::Deck

  [:rule_1, :rule_2, :rule_3].each {|rule| add_combination(rule) }

  # Highest card is worth twice as much
  def rule_1 *cards
    cards.max * 2
  end

  # A wild card in your hand doubles
  # the value of your hand
  def rule_2 *cards
    if cards.any?(&:wild?)
      cards.map(&:+) * 2
    end
  end

  # All cards are face cards adds 50 points
  def rule_3 *cards
    if cards.all?(&:face?)
      cards.reduce(&:integer_value) + 50
    end
  end

end
```


## Contributing

1. Fork it ( https://github.com/[my-github-username]/card_decks/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
