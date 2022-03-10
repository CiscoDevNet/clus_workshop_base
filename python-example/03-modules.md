# Modules

In any programming language, it is the goal of design and development that the code be as atomic, reusable, and readable as possible.  In your introductions to Python, the notion of creating functions was introduced and this allows you to consolidate pieces of code that could potentially be run over and over again.  Functions, or methods, are great, but when we start getting into more complex applications and functionality,  it makes sense to think about grouping attributes and functionality together, hence our previous lesson on Classes/Objects. What you likely noticed is that when we created our Card class and our Chip class, we saved them in different Python (.py) files and did not address how those elements could come together.  This is where modules come into play.

Python has a way to put definitions in a file and use them in a script or in an interactive instance of the interpreter. Such a file is called a module; definitions from a module can be imported into other modules or into the main module (the collection of variables that you have access to in a script executed at the top level and in calculator mode).

A module is a file containing Python definitions and statements. The file name is the module name with the suffix .py appended. Within a module, the module’s name (as a string) is available as the value of the global variable __name__.

## Access Module Attributes

A module can contain executable statements as well as function definitions. These statements are intended to initialize the module. They are executed only the first time the module name is encountered in an import statement. They are also run if the file is executed as a script.

Each module has its own private symbol table, which is used as the global symbol table by all functions defined in the module. Thus, the author of a module can use global variables in the module without worrying about accidental clashes with a user’s global variables. On the other hand, if you know what you are doing you can touch a module’s global variables with the same notation used to refer to its functions, modname.itemname.

Modules can import other modules. It is customary but not required to place all import statements at the beginning of a module (or script, for that matter). The imported module names are placed in the importing module’s global symbol table.

Let's try a little exercise with our Card object.  First start your interpreter:

```bash
cd ~/src
python
```

Now, let's import our *module* card

```bash
import card
```

Now that we've imported card, we should have the ability to access the class functions and attributes inside that module:

```bash
new_card = Card("hearts",7)
```

Wait! Why do we have error:

```
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
NameError: name 'Card' is not defined
```

We imported our card module, but to get to it's elements we have to use dot notation.  Let's try:

```bash
new_card = card.Card("hearts",7)
new_card.__repr__()
```

We should now see the representation of the card as output:

```
'7 of Hearts'
```

Now this seems a little bit of a nuisance everytime we have to instantiate a new object. Python is pretty good at offering multiple ways to do the same thing.  Let's try using the keyword ```from```.

```bash
from card import Card
```

Now we can access the Card class in the card module directly.

```bash
next_card = Card("Clubs",10)
next_card.__repr__()
```

Output: 

```
'10 of Clubs'
```

Let's exit the interpreter:

```bash
exit()
```

Huzzah! Now that we have a grasp on how we access code in other modules, let's build another part of our Blackjack game. We already have our card defined, and so the next logical object is to put those cards into a deck.  So open your deck.py file in the editor and copy in the following code:

```python
from card import Card
from random import shuffle
import requests
import sys
import json

class Deck() :
    def __init__(self, num_decks=1) : 
        self.deck_id = ""
        try:
            decks = requests.get(f"https://deckofcardsapi.com/api/deck/new/shuffle/?deck_count={str(num_decks)}")
            decks.raise_for_status()
            decks = decks.json()
            self.deck_id = decks['deck_id']
        except Exception as e:
            sys.exit(e)

    def __str__(self) :
        return f'Deck_ID: {self.deck_id}'
        
    def get_card(self) :
        try:       
            FACE_CARDS = {'KING':13, 'QUEEN':12, 'JACK':11, 'ACE':1}
            draw = requests.get(f"https://deckofcardsapi.com/api/deck/{self.deck_id}/draw?count=1")
            draw.raise_for_status()
            cards = draw.json()["cards"]

            for card in cards:
                if card['value'] in FACE_CARDS.keys(): 
                    value = FACE_CARDS[card["value"]]
                else:
                    value = int(card["value"])

                return Card(card['suit'],value)
  
        except Exception as e:
            sys.exit(e)
```

There are a few things to note on the code above. First, we see our ```from card import Card``` line, but after that we see a bunch of imports for files we didn't create!  Where did those come from?  If you recall from your introduction to Python, there are modules standard to Python (```sys```,```json```, and ```random``` in this example), and modules that are installed through pipPython's package manager pip (```requests``` here).  Similar to our card module however, these are Python files with functionality we can use and don't have to build on our own.

Now, this deck class creates 1-n decks based on how the object is instantiated and uses the Deck of Cards API to create the decks.  In the class function ```get_card(self)```, an API call is made to the created decks to draw a card and the result is used to instatiate and return a Card object to the calling code.

Ok, so let's review: we have our Card class, our Chip class, and our Deck class ready to go for our game.  Now we need people to play!

