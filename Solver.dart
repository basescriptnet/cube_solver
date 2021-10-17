import 'dart:html';
import 'dart:math';

void log(message) {
  window.console.log('${message}');
}
/* edges and corners are represented as numbers
  , where white is considered as the first layer
---
  the id might be eighter the index of the element, or the element itself
  @representation
    @white:
      0 1 2
      3 4 5
      6 7 8
    @green:
      9 10 11
      12 13 14
      15 16 17
    @blue:
      18 19 20
      21 22 23
      24 25 26
    @orange
      27 28 29
      30 31 32
      33 34 35
    @red
      36 37 38
      39 40 41
      42 43 44
    @yellow
      45 46 47
      48 49 50
      51 52 53
*/

class Solver {
  String left = 'ooooooooo';
  String right = 'rrrrrrrrr';
  String top = 'wwwwwwwww';
  String bottom = 'yyyyyyyyy';
  String front = 'ggggggggg';
  String back = 'bbbbbbbbb';
  Map sides = {};

  feed(Map sides) {
    this.top = sides['top'];
    this.bottom = sides['bottom'];
    this.left = sides['left'];
    this.right = sides['right'];
    this.front = sides['front'];
    this.back = sides['back'];
    this.sides = sides;
  }

  getElementById(int index) {
    String primary = '';
    String secondary = '';
    String? tertiary = null;
    switch (index) {
      // top
      case 0:
        primary = this.top[0];
        secondary = this.left[0];
        tertiary = this.back[0];
        break;
      case 1:
        primary = this.top[1];
        secondary = this.back[1];
        break;
      case 2:
        primary = this.top[2];
        secondary = this.right[2];
        tertiary = this.back[2];
        break;
      case 3:
        primary = this.top[3];
        secondary = this.left[1];
        break;
      // white center
      case 4:
        primary = this.top[4];
        break;
      case 5:
        primary = this.top[5];
        secondary = this.right[1];
        break;
      case 6:
        primary = this.top[6];
        secondary = this.left[2];
        tertiary = this.front[0];
        break;
      case 7:
        primary = this.top[7];
        secondary = this.front[1];
        break;
      case 8:
        primary = this.top[8];
        secondary = this.left[0];
        tertiary = this.top[2];
        break;
      case 9:
        primary = this.front[0];
        secondary = this.top[6];
        tertiary = this.left[2];
        break;
      case 10:
        primary = this.front[1];
        secondary = this.top[7];
        break;
      // here needs to be an angle
      case 12:
        primary = this.front[3];
        secondary = this.left[5];
        break;
      case 13:
        primary = this.front[4];
        break;
      case 14:
        primary = this.front[5];
        secondary = this.right[3];
        break;
      case 16:
        primary = this.front[7];
        secondary = this.bottom[7];
        break;
      // back
      case 19:
        primary = this.back[1];
        secondary = this.top[1];
        break;
      case 21:
        primary = this.back[3];
        secondary = this.left[3];
        break;
      case 22:
        primary = this.back[4];
        break;
      case 23:
        primary = this.back[3];
        secondary = this.right[3];
        break;
      case 25:
        primary = this.back[7];
        secondary = this.bottom[1];
        break;
      // left
      case 28:
        primary = this.left[1];
        secondary = this.top[3];
        break;
      case 30:
        primary = this.left[3];
        secondary = this.back[3];
        break;
      case 31:
        primary = this.left[4];
        break;
      case 32:
        primary = this.left[5];
        secondary = this.front[3];
        break;
      case 34:
        primary = this.left[7];
        secondary = this.bottom[3];
        break;
      // right
      case 37:
        primary = this.right[1];
        secondary = this.top[5];
        break;
      case 39:
        primary = this.right[3];
        secondary = this.front[5];
        break;
      case 40:
        primary = this.right[4];
        break;
      case 41:
        primary = this.right[5];
        secondary = this.back[5];
        break;
      case 43:
        primary = this.right[7];
        secondary = this.bottom[5];
        break;
      // bottom
      case 46:
        primary = this.bottom[1];
        secondary = this.back[7];
        break;
      case 48:
        primary = this.bottom[3];
        secondary = this.left[7];
        break;
      case 49:
        primary = this.bottom[4];
        break;
      case 50:
        primary = this.bottom[5];
        secondary = this.right[7];
        break;
      case 52:
        primary = this.bottom[7];
        secondary = this.front[7];
        break;
    }
    if (tertiary == null) {
      if (secondary == '') {
        return {'primary': primary};
      } else {
        return {'primary': primary, 'secondary': secondary};
      }
    } else {
      return {'primary': primary, 'secondary': secondary, 'tertiary': tertiary};
    }
  }

  int findEdge(String first, String second) {
    // pass through edges
    int j = 0;
    int index = -1;
    this.sides.forEach((key, value) {
      for (int i = 1; i < 8; i += 2) {
        var r = this.getElementById(j + i);
        // window.console.log('Index ${j + i}: ${r['primary']}_${r['secondary']}');
        if (r['primary'] == first && r['secondary'] == second) {
          index = j + i;
          break;
        }
      }
      j += 9;
    });
    return index;
  }

  int faceFromTo(int relativeIndex, int destination) {
    if (relativeIndex == destination)
      return 0;
    else if (relativeIndex == 1 && destination == 7 ||
        relativeIndex == 7 && destination == 1 ||
        relativeIndex == 3 && destination == 5 ||
        relativeIndex == 5 && destination == 3) {
      return 2;
    } else if (relativeIndex == 1 && destination == 5 ||
        relativeIndex == 3 && destination == 1 ||
        relativeIndex == 5 && destination == 7 ||
        relativeIndex == 7 && destination == 3) {
      return 1;
    }
    return -1;
  }

  oppositeFlippedPathFinder(
      String rotator, String secondaryColor, int destination) {
    List path = [];
    // used only for white
    int index = findEdge('w', secondaryColor);
    if (index == 16) {
      if (destination == 5) {
        path.add('F\'');
        path.add('R');
        path.add('F');
      }
    }
    // return index;
    // int move = faceFromTo(relativeIndex, destination);
    // if (move == 0) {
    //   path.add('${rotator}2');
    // } else if (move == -1) {
    //   path.add('$from');
    //   path.add('${rotator}2');
    // } else if (move == 1) {
    //   path.add('$from\'');
    //   path.add('${rotator}2');
    // } else if (move == 2) {
    //   path.add('${from}2');
    //   path.add('${rotator}2');
    // }
    return path;
  }

  oppositePathFinder(
      String rotator, String from, int relativeIndex, int destination) {
    List path = [];
    int move = faceFromTo(relativeIndex, destination);
    if (move == 0) {
      path.add('${rotator}2');
    } else if (move == -1) {
      path.add('$from');
      path.add('${rotator}2');
    } else if (move == 1) {
      path.add('$from\'');
      path.add('${rotator}2');
    } else if (move == 2) {
      path.add('${from}2');
      path.add('${rotator}2');
    }
    return path;
  }

  whiteCross() {
    // if (this.isSolved()) return 'Solved';
    List result = [];
    // is white red correct
    // if (this.top[5] != 'w' || this.right[1] != 'r') {}
    // var whiteRed = this.getElementById(5);
    bool isOnTheBottom(int index) {
      if (index >= 45 && index < 54) {
        return true;
      }
      return false;
    }

    Map whiteEdges = {
      'whiteBlue': findEdge('w', 'b'),
      'whiteRed': findEdge('w', 'r'),
      'whiteGreen': findEdge('w', 'g'),
      'whiteOrange': findEdge('w', 'o'),
    };
    int whiteBlue = findEdge('w', 'b');
    int whiteRed = findEdge('w', 'r');
    int whiteOrange = findEdge('w', 'o');
    int whiteGreen = findEdge('w', 'g');
    List path = [];
    if (whiteEdges['whiteBlue'] != 1) {
      if (isOnTheBottom(whiteBlue) == true) {
        int index = whiteBlue % 9;
        List moves = oppositePathFinder('B', 'D', index, 1);
        // log('Path for white blue: $moves');
        path.addAll(moves);
      }
    }
    if (whiteEdges['whiteRed'] != 5) {
      if (isOnTheBottom(whiteRed) == true) {
        int index = whiteRed % 9;
        List moves = oppositePathFinder('R', 'D', index, 5);
        // log('Path for white red: $moves');
        path.addAll(moves);
      }
      //  else if (whiteRed == 14) {
      //   path.add('R');
      // }
      else if (whiteRed == 16) {
        path.add('F\'');
        path.add('R');
        path.add('F');
      } else if (whiteRed == 34) {
        path.add('D');
        path.add('F\'');
        path.add('R');
        path.add('F');
      } else if (whiteRed == 43) {
        path.add('D\'');
        path.add('F\'');
        path.add('R');
        path.add('F');
      } else if (whiteRed == 25) {
        // path.add('D');
        path.add('B');
        path.add('R\'');
        path.add('B\'');
      } else
        log(whiteRed);
    }
    if (whiteEdges['whiteOrange'] != 3) {
      if (isOnTheBottom(whiteOrange) == true) {
        int index = whiteOrange % 9;
        List moves = oppositePathFinder('L', 'D', index, 3);
        // log('Path for white red: $moves');
        path.addAll(moves);
      } else if (whiteOrange == 16) {
        path.add('F');
        path.add('L\'');
        path.add('F\'');
      } else if (whiteOrange == 34) {
        path.add('D\'');
        path.add('F');
        path.add('L\'');
        path.add('F\'');
      } else if (whiteOrange == 43) {
        path.add('D\'');
        path.add('F');
        path.add('L\'');
        path.add('F\'');
      } else if (whiteOrange == 25) {
        // path.add('D');
        path.add('B\'');
        path.add('L');
        path.add('B');
      }
    }
    if (whiteEdges['whiteGreen'] != 7) {
      if (isOnTheBottom(whiteGreen) == true) {
        int index = whiteGreen % 9;
        List moves = oppositePathFinder('F', 'D', index, 7);
        // log('Path for white red: $moves');
        path.addAll(moves);
      } else if (whiteGreen == 16) {
        path.add('D');
        path.add('R');
        path.add('F\'');
        path.add('R\'');
      } else if (whiteGreen == 34) {
        path.add('D\'');
        path.add('F');
        path.add('L\'');
        path.add('F\'');
      } else if (whiteGreen == 43) {
        path.add('R');
        path.add('F\'');
        path.add('R\'');
      } else if (whiteGreen == 25) {
        // path.add('D');
        path.add('D\'');
        path.add('R');
        path.add('F\'');
        path.add('R\'');
      }
    }
    log(path);
    // log(whiteEdges['whiteBlue']);

    // if (whiteEdges.whiteRed['primary'] != 'w' || whiteRed['secondary'] != 'r') {
    //   window.console.log(findEdge('w', 'r'));
    //   // findEdge('w', 'r');
    // }
    // result
    return result;
  }

  bool isSolved() {
    if (this.top == 'wwwwwwwww' &&
        this.bottom == 'yyyyyyyyy' &&
        this.left == 'ooooooooo' &&
        this.right == 'rrrrrrrrr' &&
        this.front == 'ggggggggg' &&
        this.back == 'bbbbbbbbb') return true;
    this.whiteCross();
    return false;
  }
}
