/* Sons of the Forest: The Last Bunker Adventure */

:- dynamic i_am_at/1, at/2, holding/1, unlocked/1.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)), retractall(unlocked(_)).

/* Starting location */
i_am_at(cave_entrance).

/* Define the available paths */
path(cave_entrance, forward, cave_1).
path(cave_1, forward, cave_2).
path(cave_2, forward, demon_lair).
path(cave_2, right, cave_3).
path(cave_3, forward, bunker_entrance).

/* Initialize the game state */
initialize :-
    assert(at(torch, cave_entrance)),
    assert(at(rope, cave_entrance)),
    assert(at(key, cave_2)),
    assert(at(cross, cave_1)),
    assert(at(door, bunker_entrance)),
    assert(unlocked(door, false)).

/* These rules describe how to pick up an object */
take(X) :-
    holding(X),
    write('You''re already holding it!'), !, nl.

take(X) :-
    i_am_at(Place),
    at(X, Place),
    retract(at(X, Place)),
    assert(holding(X)),
    write('You take the '), write(X), write('.'), !, nl.

take(_) :-
    write('I don''t see it here.'), nl.

/* These rules describe how to put down an object */
drop(X) :-
    holding(X),
    i_am_at(Place),
    retract(holding(X)),
    assert(at(X, Place)),
    write('You drop the '), write(X), write('.'), !, nl.

drop(_) :-
    write('You aren''t holding it!'), nl.

/* These rules define the direction letters as calls to go/1 */
forward :- go(forward).
backward :- go(backward).
left :- go(left).
right :- go(right).

/* This rule tells how to move in a given direction */
go(Direction) :-
    i_am_at(Here),
    path(Here, Direction, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    look.

go(_) :-
    write('You can''t go that way.'), nl.

/* This rule tells how to look about you */
look :-
    i_am_at(Place),
    describe(Place),
    nl,
    notice_objects_at(Place),
    nl.

/* These rules set up a loop to mention all the objects in your vicinity */
notice_objects_at(Place) :-
    at(X, Place),
    write('There is a '), write(X), write(' here.'), nl,
    fail.

notice_objects_at(_).

/* Unlock the bunker door */
unlock_door(Code) :-
    i_am_at(bunker_entrance),
    at(key, _),
    (Code = 1234 -> assert(unlocked(door, true)), write('You hear a satisfying click. The bunker door is now unlocked.'), nl;
    write('The code is incorrect. The door remains locked.'), nl).

/* Interact with the objects */
interact(torch) :-
    holding(torch),
    write('You light the torch, illuminating your path.'), nl.

interact(torch) :-
    write('You need to pick up the torch first.'), nl.

interact(rope) :-
    holding(rope),
    write('You tie the rope securely, ready to climb if necessary.'), nl.

interact(rope) :-
    write('You need to pick up the rope first.'), nl.

interact(cross) :-
    holding(cross),
    write('You hold the cross tightly, feeling its protective energy.'), nl.

interact(cross) :-
    write('You need to find the cross first.'), nl.

/* These rules define the various rooms */
describe(cave_entrance) :-
    write('You find yourself at the entrance of a dark cave. The path ahead is narrow and winding.'), nl,
    write('There is a torch lying on the ground and a rope nearby.'), nl.

describe(cave_1) :-
    write('You enter a small chamber within the cave. The air feels heavy, and a faint glow can be seen in the distance.'), nl,
    write('There is a cross lying on a pedestal.'), nl.

describe(cave_2) :-
    write('You continue deeper into the cave, the darkness engulfing you. The sound of dripping water echoes in the distance.'), nl,
    write('A menacing presence can be felt in the room.'), nl.

describe(demon_lair) :-
    write('You step into a large chamber, illuminated by an eerie glow. A terrifying creature resembling a demon stands before you.'), nl,
    write('You must defeat the demon to proceed further. The cross may provide protection.'), nl.

describe(bunker_entrance) :-
    unlocked(door, true),
    write('You arrive at the entrance of an underground bunker. The heavy metal door stands unlocked.'), nl.

describe(bunker_entrance) :-
    write('You arrive at the entrance of an underground bunker. The heavy metal door is securely locked.'), nl.

/* Fight the demon creature */
fight_demon :-
    i_am_at(demon_lair),
    holding(cross),
    write('You hold the cross up high, warding off the demon creature. Its horrifying form begins to fade away, vanishing into thin air.'), nl,
    write('The path ahead is now clear. You continue on your journey.'), nl.

fight_demon :-
    i_am_at(demon_lair),
    write('You stand defenseless before the demon creature. Its piercing gaze strikes fear into your heart. The creature lunges at you, overpowering your defenses.'), nl,
    write('Your journey ends here. Game over.'), nl.

/* Game over */
game_over :-
    write('Your journey has come to an end. Thank you for playing!'), nl,
    finish.

/* These rules just write out game instructions */
instructions :-
    nl,
    write('Enter commands using standard Prolog syntax.'), nl,
    write('Available commands are:'), nl,
    write('start.              -- to start the game.'), nl,
    write('n. s. e. w.         -- to go in that direction.'), nl,
    write('take(Object).       -- to pick up an object.'), nl,
    write('drop(Object).       -- to put down an object.'), nl,
    write('look.               -- to look around you again.'), nl,
    write('interact(Object).   -- to interact with an object.'), nl,
    write('unlock_door(Code).  -- to unlock the bunker door with a code.'), nl,
    write('fight_demon.        -- to engage in a fight with the demon creature.'), nl,
    write('instructions.       -- to see this message again.'), nl,
    write('halt.               -- to end the game and quit.'), nl,
    nl.

/* This rule prints out instructions and tells where you are */
start :-
    instructions,
    initialize,
    look.

/* This rule tells how to end the game */
finish :-
    halt.

/* Start the game */
start.
