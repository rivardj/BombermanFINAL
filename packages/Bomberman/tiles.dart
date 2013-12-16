part of bomberman;

class Tiles {
  Tile tile;
  Board board;
  List<Tile> list;
  
  Tiles(this.board) {
    list = new List<Tile>();
  }

  void add(Tile tile) {
    list.add(tile);
  }
  
  void restart() {
    while (list.isEmpty) {
      list.removeLast();
    }
  }
  
  void draw() {
    for (var m = 0; m < list.length; m++) {
      list[m].draw();
    }
  }
} 

class Tile {
  Board board;
  
  var row;
  var col;
  String type; /// Can be 'wall', 'crate' or 'floor'.
  
  int walkable; /// This is a bool, see note in bomberman.dart.
  int exploded; /// This is a bool, see note in bomberman.dart.
  
  var sprite;
  ImageElement crate, destroyCrate, floor, wall;
  
  static final num size = 32; /// Tiles will be 32px square.
  
  Tile(this.board, this.row, this.col, this.type) {
    crate = document.querySelector('#crate');
    destroyCrate = document.querySelector('#destroy_crate');
    floor = document.querySelector('#floor');
    wall = document.querySelector('#wall');
    exploded = 0;
  }
 
  void draw() {
    try {
    
      switch (this.type) {
      
        case 'crate' : 
          sprite = crate;
          walkable = 0;
          break;
        case 'destroyCrate' : 
          sprite = destroyCrate;
          walkable = 1;
          type = 'floor';
          break;
        case 'floor' : 
          sprite = floor;
          walkable = 1;
          break;
        case 'wall' : 
          sprite = wall;
          walkable = 0;
          break;
      }
    
      if (walkable != 0 && walkable != 1) {
        throw new RangeError('walkable is a bool');
      }
      if (exploded != 0 && exploded != 1) {
        throw new RangeError('exploded is a bool');
      }
    
      board.context.drawImageToRect(sprite, new Rectangle(row*size, col*size, size, size));
    } catch(e) { 
      print(e);
    }
  }
}

