# Classes

On of the main constructs in Object Oriented Programming (OOP) are, obviously, objects! As you may recall from your introductory Python experiences, EVERYTHING in Python is an object and as such it lends itself nicely to concepts of OOP. Objects have attributes (values assigned to them) and methods (actions that the object can take).  Classes, then, are a way to define objects.  They provide a means of bundling data and functionality together. Creating a new class creates a new type of object, allowing new instances of that type to be made. It follows then that each class instance can have attributes attached to it for maintaining its state. Class instances can also have methods (defined by its class) for modifying its state.

## Scopes and Namespaces

A namespace is a mapping from names to objects. Examples of namespaces are: the set of built-in names (functions inherent to the language itself); the global names in a module; and the local names in a function calls. In a sense the set of attributes of an object also form a namespace. The important thing to know about namespaces is that there is absolutely no relation between names in different namespaces; for instance, two different modules may both define a function maximize without confusion — users of the modules must prefix it with the module name.

Namespaces are created at different moments and have different lifetimes. The namespace containing the built-in names is created when the Python interpreter starts up, and is never deleted. The global namespace for a module is created when the module definition is read in; normally, module namespaces also last until the interpreter quits. The statements executed by the top-level invocation of the interpreter, either read from a script file or interactively, are considered part of a module called __main__, so they have their own global namespace. (The built-in names actually also live in a module; this is called builtins.)

The local namespace for a function is created when the function is called, and deleted when the function returns or raises an exception that is not handled within the function. (Actually, forgetting would be a better way to describe what actually happens.

A scope is a textual region of a Python program where a namespace is directly accessible. “Directly accessible” here means that an unqualified reference to a name attempts to find the name in the namespace.

Although scopes are determined statically, they are used dynamically. At any time during execution, there are 3 or 4 nested scopes whose namespaces are directly accessible:

* the innermost scope, which is searched first, contains the local names
* the scopes of any enclosing functions, which are searched starting with the nearest enclosing scope, contains non-local, but also non-global names
* the next-to-last scope contains the current module’s global names
* the outermost scope (searched last) is the namespace containing built-in names

If a name is declared global, then all references and assignments go directly to the middle scope containing the module’s global names. To rebind variables found outside of the innermost scope, the nonlocal statement can be used; if not declared nonlocal, those variables are read-only (an attempt to write to such a variable will simply create a new local variable in the innermost scope, leaving the identically named outer variable unchanged).

Usually, the local scope references the local names of the (textually) current function. Outside functions, the local scope references the same namespace as the global scope: the module’s namespace. Class definitions place yet another namespace in the local scope.

It is important to realize that scopes are determined textually: the global scope of a function defined in a module is that module’s namespace, no matter from where or by what alias the function is called. On the other hand, the actual search for names is done dynamically, at run time — however, the language definition is evolving towards static name resolution, at “compile” time, so don’t rely on dynamic name resolution! (In fact, local variables are already determined statically.)

A special quirk of Python is that – if no global or nonlocal statement is in effect – assignments to names always go into the innermost scope. Assignments do not copy data — they just bind names to objects. In fact, all operations that introduce new names use the local scope: in particular, import statements and function definitions bind the module or function name in the local scope.

The global statement can be used to indicate that particular variables live in the global scope and should be rebound there; the nonlocal statement indicates that particular variables live in an enclosing scope and should be rebound there.

Let's see an example.  Copy the following code to scope_test.py

```python
def scope_test():
    def do_local():
        spam = "local spam"

    def do_nonlocal():
        nonlocal spam
        spam = "nonlocal spam"

    def do_global():
        global spam
        spam = "global spam"

    spam = "test spam"
    do_local()
    print("After local assignment:", spam)
    do_nonlocal()
    print("After nonlocal assignment:", spam)
    do_global()
    print("After global assignment:", spam)

scope_test()
print("In global scope:", spam)
```

And run it:

```bash
cd ~/src
python scope_test.py
```

The output of the example is:

```
After local assignment: test spam
After nonlocal assignment: nonlocal spam
After global assignment: nonlocal spam
In global scope: global spam
```

Note how the local assignment (which is default) didn’t change scope_test’s binding of spam. The nonlocal assignment changed scope_test’s binding of spam, and the global assignment changed the module-level binding.

You can also see that there was no previous binding for spam before the global assignment.

## Class Syntax

The simplest form of class definition looks like this:

```
class ClassName:
    <statement-1>
    .
    .
    .
    <statement-N>
```

Class definitions, like function definitions (def statements) must be executed before they have any effect.

In practice, the statements inside a class definition will usually be function definitions, but other statements are allowed, and sometimes useful — we’ll come back to this later. The function definitions inside a class normally have a peculiar form of argument list, dictated by the calling conventions for methods — again, this is explained later.

When a class definition is entered, a new namespace is created, and used as the local scope — thus, all assignments to local variables go into this new namespace. In particular, function definitions bind the name of the new function here.

## Class Objects

Class objects support two kinds of operations: attribute/method references and instantiation (creation of the object).

Attribute references use the standard syntax used for all attribute references in Python: obj.name. Valid attribute names are all the names that were in the class’s namespace when the class object was created. Let's use this as a jumping off point to start building our game.

When thinking about a game of blackjack (or any functional thing for that matter), the first thoughts going into design should be "what objects define that function?" and "what are the attributions and actions that can occur on each object?". For blackjack, that thought process leads us to Cards, Decks, Chips (for money), people (players and dealers), and finally the game itself!  If you can map out what lower level objects build into higher order objects, that makes your job all the easier when you go to code!  In this instance it seems that Card and Chip would be the most fundamental of objects for our game.

Let's start with Card:

In the IDE to the right, open the blank card.py file and copy over the following:

```python
class Card() :
    def __init__(self, suit, number) :
        self.suit = suit.capitalize()
        self.number = number
        
```

Congrats!  You made your first class!

Doesn't seem like much is going on here, but there are some VERY important things happening.  

First we're defining our namespace (Card) allowing us to instantiate (create) our objects (52 per deck to be precise).  The function ```__init__``` is called on creation of the Card object and requires we define attributes suit and number.  The notion of `self` is reference to the current object in use and how the object is able to reference its own attributes and methods.

Let's try out our new class in the interpreter:

```bash
cd ~/src
python
from card import Card
new_card = Card()
```

Wait!  What happened?  We got an error ```'TypeError: __init__() missing 2 required positional arguments: 'suit' and 'number'```.  Oh yeah, we need a suit and number to define a card.  Let's try again:

```bash
new_card = Card("hearts",7)
type(new_card)
```

You'll now see that we have a card object created of ```<class 'card.Card'>```. Let's see how we access the attributes of our card.

First suit:

```bash
new_card.suit
```

This should show result of ```"Hearts"```.

The value:

```bash
new_card.number
```

This should show the result of ```7```.

Let's exit the interpreter.

```bash
exit()
```

There are a few more attributes we need to add to our Card class to make it useful in our game.  Copy the following code to your card.py file:

```python
    def __str__(self) :
        face = self.number
        if self.number == 1 :
            face = 'Ace'
        elif self.number == 11 :
            face = 'Jack'
        elif self.number == 12 :
            face = 'Queen'
        elif self.number == 13 :
            face = 'King'
        return f'{face} of {self.suit}'
        
    def __repr__(self) :
        return Card.__str__(self)
    
    def get_value(self) : 
        value = self.number
        if self.number >= 11 and self.number <= 13 :
            value = 10
        return value
        
    def __eq__(self, other) :
        return self.number == other.number
```

You may have noticed that there are several functions defined with ```__``` before and after the name.  Those are coloquially called "Dunder" or "Magic" methods.  These are methods that are often defined in several built-in and newly created objects in Python and are thusly considered "overloaded".  A point of note, the term "Dunder" is short for "Double Under".  Let's see the result of these functions:

```bash
cd ~/src
python
from card import Card
new_card = Card("hearts",7)
new_card.__repr__()
```

We can check if one card is equal to another as well using ```__eq__```

```bash
other_card = Card("Spades", 9)
new_card.__eq__(other_card)
```

These cards are not equal so return value is False.

One more thing to try before we move on to our next Class creation.  Face cards (Jack, Queen, King, Ace) cause a little bit of a challenge because their value is all 10 (as well as 10), but we want to represent their string assignment.  We will differentiate them from each other using their int values (11,  12, 13, 1) respectively.  The string then is accessed through a local variable called "face".   So, as an example:

```bash
face_card = Card("Clubs", 11)
face_card.__repr__()
```

You should see the result ```'Jack of Clubs'```

Whew! Alright we have our first Object in our game done!  Let's move onto creating our other baseline object, the Chip.

Open chip.py in the editor and copy the following:

```python

class Chip() :
    values = [1, 5, 25, 100]
    def __init__(self, value) :
        if value not in values :
            raise ValueError('${value} is not a valid chip value')
        self.value = value
        
    def __str__(self) :
        return f'${self.value}'

# NEVER use second and third parameters     
def convert_to_chips(amount, dict={}, i=len(Chip.values)-1) :
    if amount <= 0 :
        while i >= 0 :
            dict[f'${Chip.values[i]} chip'] = 0
            i -= 1
        return
    dict[f'${Chip.values[i]} chip'] = int(amount/Chip.values[i])
    convert_to_chips(amount%Chip.values[i], dict, i-1)
    return dict
```

This class introduces a couple of interesting new items.   The first is the line ```values = [1, 5, 25, 100]```.  The variable ```values``` is a class variable and is the same for ALL instances of Chip created.  In contrast, variables with ```self.``` in front of them are called instance variables and can be different per object.

The second item introduced is the notion of recursion.  In the module function ```convert_to_chips``` you see that convert_to_chips is calling ITSELF!  It's a pretty clever function that takes the modulus (remainder of division) to turn the money amount into actual chips until all the money is allocated.  So if someone puts in $126 dollars, this function will figure out that there will be one $100 chip, one $25 chip, and one $1 chip (though to be fair, this is an unlikely allocation of chips in the real world).

Let's quickly try out the Chip class:

```bash
from chip import convert_to_chips
print(convert_to_chips(126))
```

Let's clean  up:

```bash
exit()
```

Note ```convert_to_chips()``` is not a Class function, but a module function, and so in this case there is no instantiation of the Chip object.  This is  as best a place as any to address Python modules.