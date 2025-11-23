# Scopa 36
The classic italian game of scopone scientifico

## Game loop
The game manager and the players exchange messages back and forth trough signals.

The game manager signals the action and the player that needs to perform it to all the players.

The player with the signaled id perform the action, the other players ignore it.

The game loop consists of the following phases:

- shuffling: a player shuffles the deck
- splitting: a player divides the deck in half by some index and the two halfes are inverted
- picking: a player picks a card of those he has in hand
- preference: a player specifies a preference in case it's possible to pick more than one combination with the played card
