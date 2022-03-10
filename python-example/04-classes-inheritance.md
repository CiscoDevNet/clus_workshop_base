# More about Classes

One of the main maxim about object oriented programming languages is the notion of inheritance.  Inheritance allows another class to use the attributes and methods of another class and even redefine them as needed.

This plays nicely into the people involved in a Blackjack game; players and the dealer.  Let's start by defining our player. Copy the following code into people.py:

```python
from deck import Deck
import chip
import sys
import time

class Player() :
    def __init__(self, name, money) :
        self.name = name
        self.initial_money = money
        self.money = money
        self.chips = chip.convert_to_chips(money)
        self.hand = [[]]
        self.bet = 0
        self.did_double_down = False
        
    def accept_card(self, card, hand_index=0) :
        self.hand[hand_index].append(card)
        
    def adjust_money(self, adjustment) :
        self.money += adjustment
        
    def return_cards(self) :
        self.hand = [[]]

        
    def hand_value(self, hand_index=0) :  
        total = 0
        num_aces = 0
        for card in self.hand[hand_index] :
            if card.number == 1 : 
                num_aces += 1
            else :
                total += card.get_value()   
        hand_tuple = Player.place_aces(total, num_aces)
        if hand_tuple[0] :
            return hand_tuple[1]
        else :
            return total
    
    def place_aces(total, aces) :
        if not aces :
            return (True,total)        
        for val in [11,1] : # try 11 first so we can ensure greatest possible hand value
            if total+val <= 21 :
                total_tuple = Player.place_aces(total+val, aces-1)
                if total_tuple[0] :
                    return total_tuple
        return (False,1000) # the 1000 is just to allow method to return a tuple and also show that hand was a bust
        
    def check_bust(self, hand_index=0) :
        return self.hand_value(hand_index) > 21
        
    def check_blackjack(self, hand_index=0) :
        return self.hand_value(hand_index) == 21
    
    def check_broke(self) :
        return self.money == 0
        
    def __str__(self) :
        return f'Name: {self.name}, Account: {self.money}, Chips: {self.chips}, Hand: {self.hand}, Current Bet: {self.bet}'  
```

We've done all the necessary imports and have defined everything a player does, has done to them, and their attributes.  This includes things like checking for bust (over 21) or blackjack (right on 21).

Let's test our new class:

```bash
cd ~/src
python
from people import Player
player = Player("Matt",100)
player.__str__()
```

Output:

```
"Name: Matt, Account: 100, Chips: {'$100 chip': 1, '$25 chip': 0, '$5 chip': 0, '$1 chip': 0}, Hand: [[]], Current Bet: 0"
```

Let's reset the interpreter:

```bash
exit()
```

Looks like we have our Player class setup.  Now the other type of person involved in a game of Blackjack is a dealer.  Dealers have their own attributes but they also share some of the same attributes with a Player and so we don't have to revinvent the wheel.  We will just inherit the Player (base class) and define what we need new for a Dealer  (derived class).  Copy the following to people.py (make sure it is under the Player class definition, but not scoped inside of it).

```python
class Dealer(Player) :
    def __init__(self, deck) :
        Player.__init__(self, 'Dealer', 0) # money doesn't matter for dealer
        self.deck = deck
    
    def deal_card(self, player, hand_index=0) :
        try :
            player.accept_card(self.deck.get_card(), hand_index)
        except : 
            print('No more cards left in deck.\nShuffling ', end='')
            for i in range(0,3) :
                print('.', end='')
                sys.stdout.flush()
                time.sleep(0.5)
            self.deck = Deck(6)
            print(' Done! Resume dealing.')
            sys.stdout.flush()
            time.sleep(0.8)
            player.accept_card(self.deck.get_card(), hand_index)
            
    def adjust_money(self, adjustment) :
        raise TypeError('\'adjust_money()\' should not be called on object of type \'Dealer\'.')
        
    def retrieve_cards(self, player) :
        player.return_cards()
        
    def check_hard_17(self, hand_index=0) :
        total = 0
        for card in self.hand[hand_index] :
            total += card.get_value()
        return total >= 17
        
    def __str__(self) :
        personInfo = Player.__str__(self)
        return f'{personInfo}\nStart Deck: {self.deck}'
```

You'll notice that in the class definition ```class Dealer(Player) :``` the base class Player is referenced.  All other functions defined are specific to the dealer and are not accessible by any player object.

For example:

```bash
cd ~/src
python
from people import Player
player = Player("Matt",100)
player.__str__()
from people import Dealer
dealer = Dealer("Alice")
dealer.__str__()
```

Output:

```
'Name: Dealer, Account: 0, Chips: None, Hand: [[]], Current Bet: 0\nStart Deck: Alice'
```

```bash
dealer.deal_card(player)
player.hand_value()
```

Will result in some value as will:

```bash
dealer.deal_card(dealer)
dealer.hand_value()
```

Because ```hand_value()``` was inherited from Player.  

However if:

```bash
player.deal_card(dealer)
```

Is attempted, the player will be kicked out of the casino and the dealer fired (or in our game an error will occur)!

```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Player' object has no attribute 'deal_card'
```

It looks like we have all of our necessary supporting classes setup.  Let's close our interpreter get onto the game!

```bash
exit()
```

