part of bomberman;

class Bombs {
  Bomb bomb;
  Board board;
  List<Bomb> list;
  
  Bombs(this.board) {
    list = new List<Bomb>();
  }

  void add(Bomb bomb) {
    list.add(bomb);
  }
  
  void restart() {
    while (list.isEmpty) {
      list.removeLast();
    }
  }
  
  void draw() { 
/// This loop is used when a bomb has exploded to remove it from the board.
    for (var i = 0; i < list.length; i++) { 
      if (list[i].state == 'removed') {
        list.remove(list[i]);
      }
    }
/// This loop is used to draw all the bombs on the board
    for (var j = 0; j < list.length; j++) { 
      list[j].draw();
    }
  }
} 

class Bomb {
  Board board;
  
  final height = 32;
  final width = 32;
  
  int owner; /// Assigns a [player.number] to the bomb.
  
  var row;
  var col;
  
  var newRow;
  var newCol;
  
  var state; /// Defines in which state the bomb currently is.
  
  var sprite; /// Defines which image to draw on the board.
  ImageElement idle, bomb, bomb2, bomb3, detonate, exploded;
  
  Bomb(this.board, this.row, this.col, this.owner) {
    idle = document.querySelector('#empty');
    bomb = document.querySelector('#bomb');
    bomb2 = document.querySelector('#bomb2');
    bomb3 = document.querySelector('#bomb3');
    detonate = document.querySelector('#detonate');
    exploded = document.querySelector('#empty');
    
    state = 'start';
    sprite = bomb;
    
    /// Redraw the bomb every 1 ms.
    new Timer.periodic(const Duration(milliseconds: 1000), (t) => trigger());
  }
   ///This trigger is used to change the bomb state and make it explode.
   trigger() {
     switch (this.state) {
       case 'start' :
         sprite = bomb;
         state = 'half';
         break;
       case 'half' :
         sprite = bomb2;
         state = 'quarter';
         break;
       case 'quarter' :
         sprite = bomb3; 
         state = 'detonate';
         break;
       case 'detonate' :
         sprite = detonate;
         
         board.Intersects;
         state = 'exploded';
         board.playerKill(this.row, this.col); /// Looks for players to kill.
         break;
       case 'exploded' : 
         sprite = exploded;
         state = 'removed';
         board.checkCrates(this.row, this.col); /// Looks for crates to destroy.
         board.allowBombs(this.owner); /// Once the bomb is exploded, player is allowed to drop another.
         break;
       case 'removed' : 
         sprite = idle;
         break;
     }
     draw();
   }

  draw() {
    ///If the bomb has exploded, we validate where to draw the flames.
    ///No flames are drawn on walls.
    if (state == 'exploded') {
      var topTile = board.getTileType(row, col - 1);
      var rightTile = board.getTileType(row + 1, col);
      var bottomTile = board.getTileType(row, col + 1);
      var leftTile = board.getTileType(row - 1, col);
      
      board.context.drawImageToRect(sprite, new Rectangle(row*Tile.size, col*Tile.size, width, height)); // middle
      if (topTile != 'wall') {
        board.context.drawImageToRect(sprite, new Rectangle((row)*Tile.size, (col - 1)*Tile.size, width, height)); // top
      }
      if (rightTile != 'wall') {
        board.context.drawImageToRect(sprite, new Rectangle((row + 1)*Tile.size, (col)*Tile.size, width, height)); // right
      }
      if (bottomTile != 'wall') {
        board.context.drawImageToRect(sprite, new Rectangle((row)*Tile.size, (col + 1)*Tile.size, width, height)); // bottom
      }
      if (leftTile != 'wall') {
        board.context.drawImageToRect(sprite, new Rectangle((row - 1)*Tile.size, (col)*Tile.size, width, height)); // left
      }
    }
    else { 
      board.context.drawImageToRect(sprite, new Rectangle(row*Tile.size, col*Tile.size, width, height));
    }
  }
}