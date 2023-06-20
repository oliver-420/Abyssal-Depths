/* Abyssal Depths Linus Nestler, Oliver Daxinger, Bajtik Berg*/

:- dynamic i_am_at/1, at/2, holding/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

i_am_at(starting_location).

path(starting_location, n, cave).
path(cave, s, starting_location).

at(flashlight, starting_location).
at(knife, cave).

/* These rules describe how to pick up an object. */

take(X) :-
    holding(X),
    write('You''re already holding it!'),
    !, nl.

take(X) :-
    i_am_at(Place),
    at(X, Place),
    retract(at(X, Place)),
    assert(holding(X)),
    write('OK.'),
    !, nl.

take(_) :-
    write('I don''t see it here.'),
    nl.

/* These rules describe how to put down an object. */

drop(X) :-
    holding(X),
    i_am_at(Place),
    retract(holding(X)),
    assert(at(X, Place)),
    write('OK.'),
    !, nl.

drop(_) :-
    write('You aren''t holding it!'),
    nl.

/* These rules define the direction letters as calls to go/1. */

n :- go(n).
s :- go(s).

/* This rule tells how to move in a given direction. */

go(Direction) :-
    i_am_at(Here),
    path(Here, Direction, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    !, look.

go(_) :-
    write('You can''t go that way.').

/* This rule tells how to look about you. */

look :-
    i_am_at(Place),
    describe(Place),
    nl,
    notice_objects_at(Place),
    nl.

/* These rules set up a loop to mention all the objects
   in your vicinity. */

notice_objects_at(Place) :-
    at(X, Place),
    write('There is a '), write(X), write(' here.'), nl,
    fail.

notice_objects_at(_).

/* These rules describe the various rooms. */

describe(starting_location) :-
    write('You find yourself in a dimly lit cave. The sound of water dripping echoes in the distance.'), nl.

describe(cave) :-
    write('You are in a vast underwater cave. Bioluminescent flora illuminates the surroundings.'), nl.

/* Additional rooms and descriptions can be added here */

/* Game initialization */

start :-
    instructions,
    look.

/* Game instructions */

instructions :-
    nl,
    write('Welcome to Abyssal Depths! Explore the mysterious underwater world and survive the challenges.'), nl,
    write('Enter commands using standard Prolog syntax.'), nl,
    write('Available commands are:'), nl,
    write('start.             -- to start the game.'), nl,
    write('n.  s.             -- to go in that direction.'), nl,
    write('take(Object).      -- to pick up an object.'), nl,
    write('drop(Object).      -- to put down an object.'), nl,
    write('look.              -- to look around you again.'), nl,
    write('instructions.      -- to see this message again.'), nl,
    nl.

