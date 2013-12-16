part of bomberman;

class Board {

  CanvasRenderingContext2D context;
  int x = 0;
  int y = 0;
  
  var width;
  var height;
  var size;
  
  var canvasMinRow; 
  var canvasMaxRow;
  
  var canvasMinCol;
  var canvasMaxCol;
  
  int restart; /// This is a bool, see note in bomberman.dart.
  int endGame; /// This is a bool, see note in bomberman.dart.
  
  final int maxPlayers = 2; /// Sets the number of players. Works only with 2.
  
  Tile tile;
  Tiles tiles;
  
  Players players;
  Player player;
  
  Bombs bombs;
  Bomb bomb;
  
  /// Defines a new board to play the game.
  Board(CanvasElement canvas) {
    restart = 0;
    endGame = 0;

    context = canvas.getContext('2d');
    
    width = canvas.width;
    height = canvas.height;
    size = width * height;
    
    canvasMinRow = 0;
    canvasMaxRow = (width - Tile.size)/Tile.size;
    
    canvasMinCol = 0;
    canvasMaxCol = (height - Tile.size)/Tile.size;
    
    tiles = new Tiles(this); 
    players = new Players(this);
    bombs = new Bombs(this);
       
    genTiles();
    genPlayers();
    document.onClick.listen(_onMouseClick);
    
    window.animationFrame.then(gameLoop); ///redraw the board
  }
  
/// This method fills the board with tiles (walls, crates).
  void genTiles () { 
    
/// Generates the center walls.
    for (var i = 0; i <= canvasMaxRow; i++) {
      for (var j = 0; j <= canvasMaxCol; j++) {
        if (i%2 == 0 && j%2 == 0) { 
          tile = new Tile(this, i, j, 'wall');
          tiles.add(tile);
        } else if (i == canvasMinRow || /// Generates the boundary walls.
                   j == canvasMinCol ||
                   i == canvasMaxRow || 
                   j == canvasMaxCol) {
          tile = new Tile(this, i, j, 'wall'); 
          tiles.add(tile);
        } else if (i == canvasMinRow + 1 && /// Clears player and enemy start.
                  j == canvasMinCol + 1 ||
                  i == canvasMaxRow - 1 && 
                  j == canvasMaxCol - 1) {  
          tile = new Tile(this, i, j, 'floor'); 
          tiles.add(tile);
        } else if (i%2 != 0 && j%2 != 0) { /// Generates the crates on each odd numbered tiles that are not boundary or start.
          tile = new Tile(this, i, j, 'crate');
          tiles.add(tile);
        } else { /// Generates the rest of the board grid with floor tiles.
          tile = new Tile(this, i, j, 'floor'); 
          tiles.add(tile);
        }
      }
    }
  }
  
/// Method to create the two players. 
  void genPlayers() {
    try {
      for(var i = 1; i <= maxPlayers; i++) {
        if (maxPlayers > 2) {
          throw new RangeError('MaxPlayer limited to 2');
        }
        if (i == 1) {
          player = new Player(this, i);
          players.add(player);
        } else {
          player = new Player(this, i);
          players.add(player);
        }
      }
    } catch (e) {
      print(e);
    }
  }
  
  void gameLoop(num delta) {
    try {
      if (endGame != 0 && endGame != 1) {
        throw new RangeError('endGame is a bool');
      }
        if (endGame == 1) {
          gameOver();
        } else if (endGame == 0){  
          draw();
        }
        window.animationFrame.then(gameLoop);
    } catch (e) {
      print(e);
    }
  }  
  
/// This method clears the whole canvas before it's redrawn.
  void clear() { 
    context.clearRect(x, y, width, height);
  }
  
/// Draw all the sprites (players, tiles, walls, crates, etc.).
  void draw() {
      clear();
      tiles.draw();
      scoreBoard();
      bombs.draw();
      players.draw();
  }
  
/// Displays the scoreboard with the number of lives remaining to each player.
  scoreBoard() { 
    var posX; 
    var posY = 5; 
    
    var counter;
    
    var headWidth = 64;
    var headHeight = 22;
    ImageElement head;
    
    for (var i = 0; i < players.list.length; i++) {
        if(players.list[i].number == 1) {
          head = document.querySelector('#player_head');
          counter = players.list[i].lifeCount;
          posX = 40;
        } else if (players.list[i].number == 2) {
          head = document.querySelector('#enemy_head');
          counter = players.list[i].lifeCount;
          posX = width - 130;
        } 
      context.font = "12pt Verdana";
      context.fillStyle = "#FFF";
      context.textAlign = "center";
      context.drawImageToRect(head, new Rectangle(posX, posY, headWidth, headHeight));
      context.fillText("$counter", posX + 80, posY + 16);
    }
  }
  
 /// Allows a player to drop a bomb once the previous has exploded.
  void allowBombs(int owner) {
    for (var i = 0; i < players.list.length; i++) {
      if (owner == players.list[i].number) {
        players.list[i].bombDropped = 0;
      }
    }
  }
  
/// If a player has pressed the dropBomb key and is allowed to drop bombs, add a bomb at his position.
  void dropBomb(int playerNumber) {
    for (var i = 0; i < players.list.length; i++) { 
      if (playerNumber == players.list[i].number) {
        if (players.list[i].bombDropped == 0) {
          bomb = new Bomb(this, players.list[i].row, players.list[i].col, players.list[i].number);
          bomb.state = 'start';
          players.list[i].bombDropped = 1;
          bombs.add(bomb);
        }
      }
    }
  }
 
/// This method prevents the players from walking on eachother, on bombs and on walls.
/// It registers the player's next move and checks for conflicts.
  void Intersects() { 
    for (var i = 0; i < players.list.length; i++) {
      for (var j = 0; j < players.list.length; j++) {
        if (i != j &&
             players.list[i].newRow == players.list[j].newRow && 
             players.list[i].newCol == players.list[j].newCol) {
          this.players.list[i].noMove();
        }
      }
      for (var i = 0; i < bombs.list.length; i++) {
        if(players.list[i].newRow == bombs.list[i].row &&
            players.list[i].newCol == bombs.list[i].col) {
          this.players.list[i].noMove();  
        }
      }
      for (var k = 0; k < tiles.list.length; k++) {
        if (players.list[i].newRow == tiles.list[k].row &&
             players.list[i].newCol == tiles.list[k].col) {
          if (tiles.list[k].walkable == 1) { 
              players.list[i].move();
          } else {
            players.list[i].noMove();
          }
        }
      }
    }
  }
  
  /// Once a bomb has exploded, checks for crates to destroy (change to floor).
  void checkCrates(row, col) {
    for (var i = 0; i < tiles.list.length; i++) {
      if ((row == tiles.list[i].row + 1 ||
          row == tiles.list[i].row - 1 ||
          row == tiles.list[i].row) &&
          (col == tiles.list[i].col + 1 ||
          col == tiles.list[i].col - 1 ||
          col == tiles.list[i].col) &&
          tiles.list[i].type == 'crate') {
        tiles.list[i].type = 'floor';
        tiles.list[i].exploded = 1;
      }
    }
  }
  
  ///Returns the type of a tile. It is used to prevent flames from burning on walls.
  getTileType(row, col) {
    for (var i = 0; i < tiles.list.length; i++) {
      if (row == tiles.list[i].row &&
          col == tiles.list[i].col) {
        return tiles.list[i].type;
      }
    }
  }
  
///This method checks if a bomb has killed a player. If so, it removes one life.
  void playerKill(row, col) { 
    for (var i = 0; i < players.list.length; i++) {
      if ((row == players.list[i].row && 
          (col - 1 == players.list[i].col ||
          col == players.list[i].col ||
          col + 1 == players.list[i].col)) ||
          (col == players.list[i].col && 
          (row - 1 == players.list[i].row ||
          row == players.list[i].row ||
          row + 1 == players.list[i].row))) {

        if(players.list[i].lifeCount == 0) {
          players.list[i].keepPlaying = 0;
        } else {
          players.list[i].lifeCount -= 1;
          players.list[i].alive = 0;
          players.list[i].noMove();
        }
      }
    }
  }
  
  ///Once a player has lost all his lives, the game ends.
  gameOver() {
    clear();
    var Rwidth = 260;
    var Rheight = 100;
    var fontSize = 36;
    context.rect((width - Rwidth)/2, (height- Rheight -fontSize)/2, Rwidth, Rheight);
    context.fillStyle = "#003366";
    context.fill();
    context.lineWidth = 4;
    context.strokeStyle = '#FFF';
    context.stroke();
    context.font = "36pt Impact";
    context.fillStyle = "#FFF";
    context.textAlign = "center";
    context.fillText("GAME OVER", width/2, height/2 - 10);
    context.font = "12pt Verdana";
    context.fillText("Click to play again", width/2, height/2 + 15);
  }
  
  /// Once the game is over, this method listens for clicks to restart. 
  _onMouseClick (event) {
    try {
      if (restart != 0 && restart != 1) {
        throw new RangeError('restart is a bool');
      }
      if(endGame == 1) {
      endGame = 0;
      restart = 1;
      newGame();
      }
    } catch (e) {
      restart = 1;
    }
  }
 
 ///Clears the players, tiles, bombs and restart. 
  void newGame() {
    clear();    
    tiles.restart;
    genTiles();
    players.restart;
    for(var i = 0; i < players.list.length; i++) {
      players.list[i].lifeCount = Player.DEFAULT_LIFE;
      players.list[i].row = players.list[i].startRow;
      players.list[i].col = players.list[i].startCol;
    }
    bombs.restart;
  }
}