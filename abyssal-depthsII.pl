/* Abyssal Depths, by OpenAI */

:- dynamic i_am_at/1, at/2, holding/1, unlocked/2.
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(holding(_)), retractall(unlocked(_, _)).

i_am_at(cave_entrance).

path(cave_entrance, forward, narrow_passage).
path(narrow_passage, left, skull_room).
path(narrow_passage, forward, big_cave).
path(big_cave, left, chest_room).
path(big_cave, forward, demon_room).
path(demon_room, forward, cave_room).
path(cave_room, forward, cube_room).

at(flashlight, cave_entrance).
at(skull, skull_room).
at(spider, skull_room).
at(skeleton, skull_room).
at(cross, skull_room).
at(bats, big_cave).
at(chest, chest_room).
at(demon, demon_room).
at(dripstone, cave_room).
at(bridge, cave_room).
at(cube, cube_room).

/* These rules describe how to pick up an object. */
take(X) :-
    holding(X),
    write('You''re already holding it!'), !, nl.

take(X) :-
    i_am_at(Place),
    at(X, Place),
    retract(at(X, Place)),
    assert(holding(X)),
    write('You pick up the '), write(X), write('.'), !, nl.

take(_) :-
    write('I don''t see it here.'), nl.

/* These rules describe how to put down an object. */
drop(X) :-
    holding(X),
    i_am_at(Place),
    retract(holding(X)),
    assert(at(X, Place)),
    write('You drop the '), write(X), write('.'), !, nl.

drop(_) :-
    write('You aren''t holding it!'), nl.

/* These rules define the direction letters as calls to go/1. */
n :- go(n).
s :- go(s).
e :- go(e).
w :- go(w).

/* This rule tells how to move in a given direction. */
go(Direction) :-
    i_am_at(Here),
    path(Here, Direction, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    !, look.

go(_) :-
    write('You can''t go that way.'), nl.

/* This rule tells how to look about you. */
look :-
    i_am_at(Place),
    describe(Place),
    nl,
    notice_objects_at(Place),
    nl.

/* These rules set up a loop to mention all the objects in your vicinity. */
notice_objects_at(Place) :-
    at(X, Place),
    write('There is a '), write(X), write(' here.'), nl,
    fail.

notice_objects_at(_).

/* Fight the demon creature */
fight_demon :-
    i_am_at(demon_room),
    holding(cross),
    write('You hold the cross up high, warding off the demon creature. It goes up in flames and vanishes.'), nl,
    write('As the demon burns down, a key falls from its stomach.'), nl,
    assert(holding(key)),
    write('You pick up the key.'), nl,
    retract(at(demon, demon_room)),
    !, nl.

fight_demon :-
    i_am_at(demon_room),
    write('You stand defenseless before the demon creature. It lunges at you, overpowering your defenses.'), nl,
    write('Your journey ends here. Game over.'), nl,
    finish.

/* Open the chest with the key */
open_chest :-
    holding(key),
    i_am_at(chest_room),
    unlocked(chest, chest_room),
    write('You use the key to unlock the chest. It creaks open, revealing a golden armored arm.'), nl,
    assert(holding(golden_arm)),
    write('You pick up the golden armored arm.'), nl,
    !, nl.

open_chest :-
    holding(key),
    i_am_at(chest_room),
    write('The chest is locked. You need a key to open it.'), nl,
    !, nl.

open_chest :-
    write('There is no chest here.'), nl,
    !, nl.

/* Insert the golden arm into the cube */
insert_arm :-
    holding(golden_arm),
    i_am_at(cube_room),
    write('You place the golden armored arm into the print on the golden cube.'), nl,
    write('The cube begins to hum and opens, revealing a passage inside.'), nl,
    retract(at(cube, cube_room)),
    assert(at(opened_cube, cube_room)),
    !, nl.

insert_arm :-
    i_am_at(cube_room),
    write('You need the golden armored arm to activate the cube.'), nl,
    !, nl.

insert_arm :-
    write('There is no cube here.'), nl,
    !, nl.

/* These rules describe the various rooms. */
describe(cave_entrance) :-
    write('You are at the entrance of a dark cave. The way behind you is blocked by falling rocks.'), nl,
    write('You can see a faint light in the distance.'), nl.

describe(narrow_passage) :-
    write('You find yourself in a narrow passage. It splits into two directions: left and forward.'), nl.

describe(skull_room) :-
    write('You enter a room filled with skulls and spiders. A skeleton lies in the corner, holding a cross.'), nl.

describe(big_cave) :-
    write('You step into a bigger cave. Your flashlight can barely light up the room.'), nl,
    write('Dripstone formations hang from the ceiling, and bats are suspended in between.'), nl.

describe(chest_room) :-
    write('You are in a room with a large chest. It appears to be locked.'), nl.

describe(demon_room) :-
    write('You enter a dimly lit room. A terrifying creature that looks like a scorpion-human hybrid is waiting for you.'), nl,
    write('Its pale skin glistens under the faint light.'), nl.

describe(cave_room) :-
    write('You find yourself in a cavernous room. A massive canyon stretches out before you.'), nl,
    write('A rickety bridge hangs over the canyon, leading to the other side.'), nl.

describe(cube_room) :-
    write('You reach the final room of the cave. A big golden cube sits in the center, with a print shaped like a golden armored arm.'), nl,
    write('A sense of foreboding fills the air.'), nl.

/* Start the game */
initialize :-
    assert(i_am_at(cave_entrance)),
    assert(at(flashlight, cave_entrance)),
    instructions,
    look.

/* This rule just writes out game instructions. */
instructions :-
    nl,
    write('Welcome to Abyssal Depths!'), nl,
    write('Enter commands using standard Prolog syntax.'), nl,
    write('Available commands are:'), nl,
    write('start.                    -- to start the game.'), nl,
    write('n.  s.  e.  w.            -- to go in that direction.'), nl,
    write('take(Object).             -- to pick up an object.'), nl,
    write('drop(Object).             -- to put down an object.'), nl,
    write('open_chest.               -- to open the chest with the key.'), nl,
    write('fight_demon.              -- to fight the demon creature.'), nl,
    write('insert_arm.               -- to insert the golden arm into the cube.'), nl,
    write('look.                     -- to look around you again.'), nl,
    nl.

/* Finish the game */
finish :-
    write('You have finished your journey through the Abyssal Depths.'), nl,
    write('Thank you for playing!'), nl.

start :- initialize.
