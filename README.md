<p align="center"><img src="game/art/avatar.png" width=125></p>
<h1 align="center">Moritur</h1>

<img src="https://user-images.githubusercontent.com/73172589/183405355-0a9b248e-6927-4ce8-acba-3ff291dfc6fd.gif" align="right" width=50>

**Moritur** is a _2D action top-down roguelike game_ written during the 48 hours GMTK Game Jam 2022. The jam main theme to implement was **Roll of the Dice**, so the _randomness_ of the dice is the crucial mechanics of the game.

<img src="https://user-images.githubusercontent.com/73172589/183412432-59c95f1b-56a7-4a4d-9e2e-1410bf594705.gif" width=200 align="left">

The game is inspired by a board games concept. You start at a game board filled with different kinds of rooms represented as a tiles on the board, and rolling the dice decides the cell player will face. Every upgrade and game progression is random for the player. The goal is to reach the last boss level and defeat him.

## Board cells

There are different types of tiles on the board, each representing a certain room to be entered by the player:

- [x] **combat** ![](game/art/Cells/combat_filled.png): a random room full of the enemies to kill to pass it. There are two types of enemies: range and melee

  <img src="game/art/decorations/candle.png" width=10> <img src="game/art/decorations/bloody_pillar.png" width=72>
  <img src="https://user-images.githubusercontent.com/73172589/183416376-5db62d74-4e48-4fa0-b7dc-84648bbf3128.gif" width=100>
  <img src="https://user-images.githubusercontent.com/73172589/183421628-8b0f1bb6-d638-4bb0-80d2-ef3a5a4c06b8.gif" width=150>
  <img src="https://user-images.githubusercontent.com/73172589/183424014-fe643cea-be0c-4a3f-a43e-f80caeff9345.gif" width=175>
  <img src="https://user-images.githubusercontent.com/73172589/183428307-7adde6d7-73ec-419d-8663-3827d319f567.gif" height=128>
  <img src="https://user-images.githubusercontent.com/73172589/183431488-70b61dac-d1cc-4225-b59d-9a503b7c55ec.gif" width=175>
  <img src="game/art/decorations/bloody_pillar.png" width=72> <img src="game/art/decorations/candle.png" width=10>

- [x] **loot** ![](game/art/Cells/loot_filled.png): a random power-up or weapon.
  
  <img src="https://user-images.githubusercontent.com/73172589/183409180-e3218cdc-8874-443d-90cc-ff9afb930240.gif" width=200 align="right">

  There are 9 different possible power-ups for your character:

  * _Elements_: fire ![](game/art/PowerUps/16x16_fire.png) / poison ![](game/art/PowerUps/16x16_poison.png) / ice ![](game/art/PowerUps/16x16_ice.png) attacks
  * _Health_: heal ![](game/art/PowerUps/heal.png) / encrease max lifes ![](game/art/PowerUps/health_up.png)
  * _Increase projectile_: damage ![](game/art/PowerUps/encrease_dmg.png) / speed ![](game/art/PowerUps/encrease_speed.png) / size ![](game/art/PowerUps/projectile_size.png)
  * _CD_: Decrease cool-down of the attacks ![](game/art/PowerUps/cd_reduction.png)
  
  <img src="https://user-images.githubusercontent.com/73172589/183419483-cafdaa0b-a86e-40a0-af94-8ba577b5ec30.gif" width=200 align="right">

  There are also 5 different weapons, each depending on the power-up element (fire / poison / ice / none):
  * _Swords_ dealing the AOE damage ![](game/art/Weapons/sword/Wind%20Element.png) ![](game/art/Weapons/sword.png) ![](game/art/Weapons/sword/Ice-Water%20Element.png) ![](game/art/Weapons/sword/Earth%20Element.png)
  * _Bows_ piercing the enemies ![](https://user-images.githubusercontent.com/73172589/183414786-7e803142-4964-4096-b84a-bcdf245f42fc.png)
  * 3 types of range-attacking _wands_ each with different characteristics: a strong ![l0_sprite_1](https://user-images.githubusercontent.com/73172589/183401097-fc839c25-8ee2-42ae-b6ee-43e8b598d38b.png), medium ![l0_sprite_2](https://user-images.githubusercontent.com/73172589/183401101-ce722691-3595-4c9b-ae0a-58ead0c51346.png), and weak ![l0_sprite_3](https://user-images.githubusercontent.com/73172589/183401105-d615e0ca-6949-4457-bd4e-971231cfe49c.png)

- [x] **rollback** ![](game/art/Cells/random_effect_filled.png): you move your current position on the board randomly forwards / backwards on an arbitrary number of steps

- [ ] **shop** ![](game/art/Cells/shop_filled.png): to buy the upgrades for the character

- [x] **final boss** ![](game/art/Cells/boss.png) room as the very last tile of the game.

## Contributors:
* Player mechanics and power-ups / weapons: [Ostap Trush](https://github.com/Adeon18)
* Enemy design: [Oleksiy Hoyev](https://github.com/alexg-lviv)
* Room and random board generation: [Bohdan Ruban](https://github.com/iamthewalrus67)
* Art and visuals: [Alina Bondarets](https://github.com/alorthius)
