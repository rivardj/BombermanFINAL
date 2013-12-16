part of bomberman;

class Players {
  Player player;
  Board board;
  List<Player> list;
  
  Timer timer;
  
  Players(this.board) {
    list = new List<Player>();
  }

  void add(Player player) {
    list.add(player);
  }
  
  void restart() {
    while (list.isEmpty) {
      list.removeLast();
    }
  }
  
  void draw() { ///This method is used to draw all the players.
   
    for (var i = 0; i < list.length; i++) {    
      list[i].nextMove();
    }
    for (var j = 0; j < list.length; j++) {    
      board.Intersects();
    }
    for (var k = 0; k < list.length; k++) {
      list[k].draw();
    }
    for (var l = 0; l < list.length; l++) {
      if (list[l].keepPlaying == 0) {
        list[l].keepPlaying = 1;
       timer = new Timer.periodic(new Duration(milliseconds: 1000), (Timer timer) => endGame());
      }
    }
  }
  void endGame() {
    timer.cancel();
    board.endGame = 1;
  }
} 

class Player {
  Board board;
  
  int number;
  
  final height = 32;
  final width = 32;
  
  var startRow;
  var startCol;
  var row;
  var col;
  
  var arrowKey;
  
  var newRow;
  var newCol;
  
  int bombDropped;    /// This is a bool, see note in bomberman.dart.
  
  int keepPlaying;    /// This is a bool, see note in bomberman.dart.
  int alive;          /// This is a bool, see note in bomberman.dart.
  
  static const DEFAULT_LIFE = 3;
  int lifeCount = DEFAULT_LIFE;
  
  ImageElement player, death;

  Player(this.board, this.number) {
    try {
      bombDropped = 0;    /// 0: no bomb dropped, 1: bomb dropped.
      keepPlaying = 1;    /// 0: game ends, 1: keep playing.
      alive = 1;          /// 0: no life lost, 1: the player lost a life.
      death = document.querySelector('#death');
    
      if (number == 1) { /// Places player 1 at (1,1)
        startRow = 1;
        startCol = 1;
       
        row = startRow;
        col = startCol;
      
        player = document.querySelector('#player');
        document.onKeyDown.listen(_onKeyDown0);
      } else if (number == 2) { /// Places player 2 at (1,1)
        startRow = board.canvasMaxRow - 1;
        startCol = board.canvasMaxCol - 1;
      
        row = startRow;
        col = startCol;
      
        player = document.querySelector('#enemy');
        document.onKeyDown.listen(_onKeyDown1);
      }
      if (number > 2) {
        throw new RangeError('MaxPlayer is limited to 2');
      }
    
      arrowKey = 'noMove';
    
      newRow = row;
      newCol = col;
    } catch(e) {
      print(e);
    }
  }

  draw() { /// Draw the players
    try {
      if (alive != 0 && alive != 1) {
        throw new RangeError('alive is a bool');
      }
      if (alive == 0) {
        board.context.drawImageToRect(death, new Rectangle(row*Tile.size, col*Tile.size, width, height));
        new Future.delayed(const Duration(milliseconds: 1000), () => resetPlayer());
      } else {
        board.context.drawImageToRect(player, new Rectangle(row*Tile.size, col*Tile.size, width, height));
      }
    } catch(e) {
      print(e);
    }
  }
  
  resetPlayer() { /// Reset players after death
    noMove();
    alive = 1;
    row = startRow;
    col = startCol;
  }
  
  _onKeyDown0(event) {
    try {
      if (alive != 0 && alive != 1) {
        throw new RangeError('alive is a bool');
      }
     
      if (keepPlaying != 0 && keepPlaying != 1) {
        throw new RangeError('keepPlaying is a bool');
      }
    
      if (alive == 1 && keepPlaying == 1) {
        switch (event.keyCode) {
      
          case KeyCode.UP:
            arrowKey = 'topDown';
          break;
      
          case KeyCode.RIGHT:
            arrowKey = 'rightDown';
          break;
      
          case KeyCode.DOWN:
            arrowKey = 'bottomDown';
          break;
      
          case KeyCode.LEFT:
            arrowKey = 'leftDown';
          break;
      
          case KeyCode.SPACE:
            arrowKey = 'spaceDown';
          break;
        }
      }
    } catch (e) {
      print(e);
    }
  }
  
  _onKeyDown1(event) {
    try {
      if (alive != 0 && alive != 1) {
        throw new RangeError('alive is a bool');
      }
    
      if (keepPlaying != 0 && keepPlaying != 1) {
        throw new RangeError('keepPlaying is a bool');
      }
    
      if (alive == 1 && keepPlaying == 1) {
        switch (event.keyCode) {
      
          case KeyCode.W:
            arrowKey = 'wDown';
          break;
      
          case KeyCode.D:
            arrowKey = 'dDown';
          break;
      
          case KeyCode.S:
            arrowKey = 'sDown';
          break;
       
          case KeyCode.A:
            arrowKey = 'aDown';
          break;
      
          case KeyCode.Q:
            arrowKey = 'qDown';
          break; 
        }
      }
    } catch (e) {
      print(e);
    }
  }
  
 void move() { /// Moves the player on the grid after 'nextMove' method was evoked.
    switch (this.arrowKey) {
      
      case 'topDown': // for player 1
        this.col -= 1;
        break;
        
      case 'rightDown':
        this.row += 1;
        break;
        
      case 'bottomDown':
        this.col += 1;
        break;
        
      case 'leftDown':
        this.row -= 1;
        break;
        
      case 'spaceDown':
        board.dropBomb(this.number);
        break;  
          
      case 'wDown': // for player 2
        this.col -= 1;
        break;  
        
      case 'dDown':
        this.row += 1;
        break;  
        
      case 'sDown':
        this.col += 1;
        break;
        
      case 'aDown':
        this.row -= 1;
        break; 
        
      case 'qDown':
        if (this.bombDropped == 0) {
          board.dropBomb(this.number);
          bombDropped += 1; 
          }
        break;  
    }
    noMove();
  }
    
 void noMove() { /// Prevents player from moving
    this.arrowKey = 'noMove';
  }
  
 void nextMove() { /// Computes the player's future position.
   this.newRow = this.row;
   this.newCol = this.col;
   
    switch (this.arrowKey) {   // player 1
      case 'topDown':
        this.newCol -= 1;
        break; 
      
      case 'rightDown':
        this.newRow += 1;
        break;
        
      case 'bottomDown':
        this.newCol += 1;
        break;
        
      case 'leftDown':
        this.newRow -= 1;
        break;          
        
      case 'wDown':     // player 2
        this.newCol -= 1;
        break;     
        
      case 'dDown':
        this.newRow += 1;
        break;   
        
      case 'sDown':
        this.newCol += 1;
        break;
        
      case 'aDown':
        this.newRow -= 1;
        break;  
    }
  }
}