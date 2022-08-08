<p align="center"><img src="game/art/avatar.png" width=125></p>
<h1 align="center">Moritur</h1>

### Overview

Moritur is a 2D action top-down roguelike game written during the 48 hours GMTK Game Jam 2022. The jam theme was Roll of the Dice, so it's the crucial mechanics of the game.

The game is inspired by a board games concept. You start at a game board filled with different kinds of rooms and rolling the dice decides the cell on the board. There are different types of tiles on the board, each representing a certain room to be entered by the player:
- [x] **combat**: a random room full of the enemies to kill to pass it. There are two types of enemies: range and melee
- [x] **loot**: a random power-up or weapon.

  There are 9 different possible power-ups for your character:
  * Poison / fire / ice attacks
  * Heal current health / add additional life to max quantity
  * Increase projectile size / speed / damage
  * Decrease cool-down of the attacks 

  There are also 5 different weapons:
  * A sword
  * A bow
  * 3 types of range-attacking wands each with different characteristics: a weak, medium and strong wand

- [x] **rollback**: you move your current position on the board randomly forwards / backwards on an arbitrary number of steps
- [ ] **shop**: to buy the upgrades for the character
- [x] **final boss** room as the very last tile of the game.

### Contributors:
* Player mechanics and power-ups / weapons: [Ostap Trush](https://github.com/Adeon18)
* Enemy design: [Oleksiy Hoyev](https://github.com/alexg-lviv)
* Room and random board generation: [Bohdan Ruban](https://github.com/iamthewalrus67)
* Art and visuals: [Alina Bondarets](https://github.com/alorthius)
