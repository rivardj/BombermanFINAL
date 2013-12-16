/// Game developped by Olivier Daneau and Jean-François Rivard
/// For the course SIO 2109 - Intro to Prog Laval University
/// Code samples taken from https://github./dzenanr/invaders and https://github.com/dzenanr/ping_pong
/// Based on the game http://www.jeu.fr/jeu/fire-and-bombs
/// Total developping time : 80+ hours.
library bomberman;

import 'dart:html';
import 'dart:async';
import 'dart:math';

part 'lib/board.dart';
part 'lib/players.dart';
part 'lib/tiles.dart';
part 'lib/bombs.dart';

void main() {
  new Board(document.querySelector('#canvas'));
}

/**TODO : Adapt the methods for more than 2 players.

 There seems to be a problem when getting/setting bool from class.list[i].bool.
 We used int of 0 and 1 instead of bool where necessary to fix the issue temporarily. 
 All the int that acts as bool have been protected with appropriate exception handling.*/