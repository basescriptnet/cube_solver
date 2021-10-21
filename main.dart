// import 'Solver.dart';
import 'dart:html';
import 'dart:math';

int width = 600;
int height = 350;
int cell = 50;
double verticalScale = .515;
double horizontalScale = -.7;
String m(String string, int index, String newValue) {
  return string.substring(0, index) + newValue + string.substring(index + 1);
}

void log(final message) {
  window.console.log('$message');
}

String rotateFace(String string, int direction) {
  if (direction == -1) {
    return [
      string[6],
      string[3],
      string[0],
      string[7],
      string[4],
      string[1],
      string[8],
      string[5],
      string[2]
    ].join();
  }
  return [
    string[2],
    string[5],
    string[8],
    string[1],
    string[4],
    string[7],
    string[0],
    string[3],
    string[6]
  ].join();
}

void writeToUI() {
  querySelector('#cube')?.innerHtml = '''
             ${top.substring(0, 3).split('').join(' ')}
             ${top.substring(3, 6).split('').join(' ')}
             ${top.substring(6, 9).split('').join(' ')}
${left.substring(0, 3).split('').join(' ')} ${front.substring(0, 3).split('').join(' ')} ${right.substring(0, 3).split('').join(' ')} ${back.substring(0, 3).split('').join(' ')}
${left.substring(3, 6).split('').join(' ')} ${front.substring(3, 6).split('').join(' ')} ${right.substring(3, 6).split('').join(' ')} ${back.substring(3, 6).split('').join(' ')}
${left.substring(6, 9).split('').join(' ')} ${front.substring(6, 9).split('').join(' ')} ${right.substring(6, 9).split('').join(' ')} ${back.substring(6, 9).split('').join(' ')}
             ${bottom.substring(0, 3).split('').join(' ')}
             ${bottom.substring(3, 6).split('').join(' ')}
             ${bottom.substring(6, 9).split('').join(' ')}
 
             ${back.substring(0, 3).split('').join(' ')}
             ${back.substring(3, 6).split('').join(' ')}
             ${back.substring(6, 9).split('').join(' ')}
  '''
      .replaceAll(RegExp(r'\bw\b'), '<span class="white">w</span>')
      .replaceAll(RegExp(r'\bg\b'), '<span class="green">g</span>')
      .replaceAll(RegExp(r'\br\b'), '<span class="red">r</span>')
      .replaceAll(RegExp(r'\bb\b'), '<span class="blue">b</span>')
      .replaceAll(RegExp(r'\by\b'), '<span class="yellow">y</span>')
      .replaceAll(RegExp(r'\bo\b'), '<span class="orange">o</span>')
      .replaceAll(RegExp(r'\*'), '<span class="blank"> </span>');
}

String getColor(String char) {
  // window.console.log(top);
  switch (char) {
    case 'w':
      return 'white';
    case 'y':
      return 'yellow';
    case 'r':
      return 'red';
    case 'o':
      return 'orange';
    case 'g':
      return 'green';
    case 'b':
      return 'blue';
    default:
      return 'black';
  }
}

String top = 'wwwwwwwww';
String bottom = 'yyyyyyyyy';
String right = 'rrrrrrrrr';
String left = 'ooooooooo';
String front = 'ggggggggg';
String back = 'bbbbbbbbb';

Map<String, String> sides() {
  return {
    'top': top,
    'bottom': bottom,
    'left': left,
    'right': right,
    'front': front,
    'back': back
  };
}

void main(List<String> args) {
  // Solver solver = new Solver();
  CanvasElement canvas = new CanvasElement();
  document.body?.children.add(canvas);

  canvas.width = width;
  canvas.height = height;
  CanvasRenderingContext2D ctx = canvas.context2D;
  ctx.lineWidth = 3;

  double resetX = 200;
  double beginX = resetX;
  double beginY = 90;
  double saveY = beginY;
  void draw_top() {
    ctx.save();
    ctx.setTransform(1, 0, horizontalScale, verticalScale, cell, 0);
    for (int i = 1; i <= 9; i++) {
      ctx.fillStyle = getColor(top[i - 1]);
      ctx.fillRect(beginX, beginY, cell, cell * horizontalScale.abs());
      ctx.strokeRect(beginX, beginY, cell, cell * horizontalScale.abs());
      beginX += cell;
      if (i % 3 == 0) {
        beginX = resetX;
        beginY += cell * horizontalScale.abs();
      }
    }
    ctx.restore();
  }

  void draw_front() {
    beginY = beginY * verticalScale + 2; // 2 is half of the border width
    // resetX = resetX / cell / verticalScale - 4; // 4 is full border width
    resetX =
        resetX / cell * 3 + cell * 2; // resetX / cell * 3 = first element.x
    beginX = resetX;
    saveY = beginY;
    for (int i = 1; i <= 9; i++) {
      ctx.fillStyle = getColor(front[i - 1]);
      ctx.fillRect(beginX, beginY, cell, cell);
      ctx.strokeRect(beginX, beginY, cell, cell);
      beginX += cell;
      if (i % 3 == 0) {
        beginX = resetX;
        beginY += cell;
      }
    }
  }

  void draw_right() {
    // ctx.restore();
    ctx.save();
    ctx.setTransform(.51, -.37, 0, 1, cell * 2 + 28, cell * 3 * .655 - 1);
    beginY = saveY;
    resetX += cell * 3;
    beginX = resetX;
    ctx.fillStyle = 'red';
    for (int i = 1; i <= 9; i++) {
      ctx.fillStyle = getColor(right[i - 1]);
      ctx.fillRect(beginX, beginY, cell, cell);
      ctx.strokeRect(beginX, beginY, cell, cell);
      beginX += cell;
      if (i % 3 == 0) {
        beginX = resetX;
        beginY += cell;
      }
    }
  }

  void draw() {
    // resetting everything back
    resetX = 200;
    beginX = resetX;
    beginY = 90;
    saveY = beginY;

    ctx.clearRect(0, 0, width, height);
    ctx.restore();
    draw_top();
    draw_front();
    draw_right();
    writeToUI();
    // var timer = new Timer(new Duration(milliseconds: 100), draw);
  }

  // rotations

  // right and left
  void rotateX(String side, int direction) {
    int fst = 0;
    if (side == 'right') fst = 2;
    int scd = fst + 3;
    int trd = scd + 3;
    Map<String, dynamic> objs = {
      'front': front,
      'top': top,
      'back': back,
      'bottom': bottom
    };
    if (side == 'right' && direction == 1 || side == 'left' && direction == 1) {
      // for (int j = 0; j < 3; j++) {
      //   front = m(front, fst + j * 3, '${changes[0][j]}');
      //   top = m(top, fst + j * 3, '${changes[1][j]}');
      //   back = m(back, fst + j * 3, '${changes[2][j]}');
      //   bottom = m(bottom, fst + j * 3, '${changes[3][j]}');
      // front = m(front, fst, '${objs[3][fst]}');
      front = m(front, fst, '${objs['bottom'][trd]}');
      front = m(front, scd, '${objs['bottom'][scd]}');
      front = m(front, trd, '${objs['bottom'][fst]}');

      bottom = m(bottom, fst, '${objs['back'][fst]}');
      bottom = m(bottom, scd, '${objs['back'][scd]}');
      bottom = m(bottom, trd, '${objs['back'][trd]}');

      top = m(top, fst, '${objs['front'][fst]}');
      top = m(top, scd, '${objs['front'][scd]}');
      top = m(top, trd, '${objs['front'][trd]}');

      back = m(back, fst, '${objs['top'][trd]}');
      back = m(back, scd, '${objs['top'][scd]}');
      back = m(back, trd, '${objs['top'][fst]}');
      // }
    } else if (side == 'right' && direction == -1 ||
        side == 'left' && direction == -1) {
      front = m(front, fst, '${objs['top'][fst]}');
      front = m(front, scd, '${objs['top'][scd]}');
      front = m(front, trd, '${objs['top'][trd]}');
      // front = m(front, trd, '${objs[1][trd]}');

      // bottom = m(bottom, fst, '${objs[0][trd]}');
      bottom = m(bottom, fst, '${objs['front'][trd]}');
      bottom = m(bottom, scd, '${objs['front'][scd]}');
      bottom = m(bottom, trd, '${objs['front'][fst]}');

      // top = m(top, fst, '${objs[2][trd]}');
      top = m(top, fst, '${objs['back'][trd]}');
      top = m(top, scd, '${objs['back'][scd]}');
      top = m(top, trd, '${objs['back'][fst]}');
      // top = m(top, trd, '*');

      // back = m(back, fst, '${objs[3][fst]}');
      back = m(back, fst, '${objs['bottom'][fst]}');
      back = m(back, scd, '${objs['bottom'][scd]}');
      back = m(back, trd, '${objs['bottom'][trd]}');
      //   // for (int j = 0; j < 3; j++) {
      //   //   front = m(front, fst + j * 3, '${objs[1][fst + j * 3]}');
      //   //   bottom = m(bottom, fst + j * 3, '${objs[0][trd - j * 3]}');
      //   //   top = m(top, fst + j * 3, '${objs[2][trd - j * 3]}');
      //   //   back = m(back, fst + j * 3, '${objs[3][fst + j * 3]}');
      //   // }
    }
    if (side == 'right') {
      // right
      if (direction == 1) {
        right = rotateFace(right, -1);
      } else {
        right = rotateFace(right, 1);
      }
    } else if (side == 'left') {
      // left
      if (direction == 1) {
        left = rotateFace(left, 1);
      } else {
        left = rotateFace(left, -1);
      }
    }
    draw();
    // solver.feed(sides());
    // solver.isSolved();
  }

  String flipStringY(String string) {
    return [
      string.substring(6, 9),
      string.substring(3, 6),
      string.substring(0, 3)
    ].join();
  }

  String flipStringX(String string) {
    return [
      string[2],
      string[1],
      string[0],
      string[5],
      string[4],
      string[3],
      string[8],
      string[7],
      string[6],
    ].join();
  }

  void rotateXself() {
    Map<String, dynamic> objs = {
      'front': front,
      'top': flipStringY(top),
      'back': back,
      'bottom': flipStringY(bottom),
      'left': left,
      'right': right
    };
    right = rotateFace(objs['right'], -1);
    left = rotateFace(objs['left'], 1);
    front = objs['bottom'];
    top = objs['front'];
    back = objs['top'];
    bottom = objs['back'];

    draw();
  }

  void rotateYself() {
    Map<String, dynamic> objs = {
      'front': front,
      'top': rotateFace(top, -1),
      'back': flipStringX(back),
      'bottom': rotateFace(bottom, -1),
      'left': flipStringX(left),
      'right': right
    };
    right = objs['back'];
    front = objs['right'];
    left = objs['front'];
    back = objs['left'];
    top = objs['top'];
    bottom = objs['bottom'];

    draw();
  }

  void rotateZself() {
    rotateXself();
    rotateYself();
    rotateXself();
    rotateXself();
    rotateXself();
    draw();
  }

  void rotateY(String side, int direction) {
    int fst = 0;
    if (side == 'bottom') fst = 6;
    int scd = fst + 1;
    int trd = scd + 1;
    Map<String, dynamic> objs = {
      'front': front,
      'left': left,
      'back': back,
      'right': right
    };

    if (side == 'top' && direction == 1 || side == 'bottom' && direction == 1) {
      front = m(front, fst, '${objs['right'][fst]}');
      front = m(front, scd, '${objs['right'][scd]}');
      front = m(front, trd, '${objs['right'][trd]}');

      right = m(right, fst, '${objs['back'][trd]}');
      right = m(right, scd, '${objs['back'][scd]}');
      right = m(right, trd, '${objs['back'][fst]}');

      left = m(left, fst, '${objs['front'][fst]}');
      left = m(left, scd, '${objs['front'][scd]}');
      left = m(left, trd, '${objs['front'][trd]}');

      back = m(back, fst, '${objs['left'][trd]}');
      back = m(back, scd, '${objs['left'][scd]}');
      back = m(back, trd, '${objs['left'][fst]}');
    } else if (side == 'top' && direction == -1 ||
        side == 'bottom' && direction == -1) {
      front = m(front, fst, '${objs['left'][fst]}');
      front = m(front, scd, '${objs['left'][scd]}');
      front = m(front, trd, '${objs['left'][trd]}');

      right = m(right, fst, '${objs['front'][fst]}');
      right = m(right, scd, '${objs['front'][scd]}');
      right = m(right, trd, '${objs['front'][trd]}');

      left = m(left, fst, '${objs['back'][trd]}');
      left = m(left, scd, '${objs['back'][scd]}');
      left = m(left, trd, '${objs['back'][fst]}');

      back = m(back, fst, '${objs['right'][trd]}');
      back = m(back, scd, '${objs['right'][scd]}');
      back = m(back, trd, '${objs['right'][fst]}');
    }
    if (side == 'top') {
      // top
      if (direction == 1) {
        top = rotateFace(top, -1);
      } else {
        top = rotateFace(top, 1);
      }
    } else if (side == 'bottom') {
      // bottom
      if (direction == 1) {
        bottom = rotateFace(bottom, -1);
      } else {
        bottom = rotateFace(bottom, 1);
      }
    }
    draw();
    // solver.feed(sides());
    // solver.isSolved();
  }

  void rotateZ(String side, int direction) {
    int fst = 0;
    if (side == 'front') fst = 6;
    int scd = fst + 1;
    int trd = scd + 1;
    Map<String, dynamic> objs = {
      'top': top,
      'left': left,
      'bottom': bottom,
      'right': right
    };
    if (side == 'front' && direction == 1) {
      top = m(top, 6, '${objs['left'][8]}');
      top = m(top, 7, '${objs['left'][5]}');
      top = m(top, 8, '${objs['left'][2]}');

      right = m(right, 0, '${objs['top'][6]}');
      right = m(right, 3, '${objs['top'][7]}');
      right = m(right, 6, '${objs['top'][8]}');

      bottom = m(bottom, 8, '${objs['right'][0]}');
      bottom = m(bottom, 7, '${objs['right'][3]}');
      bottom = m(bottom, 6, '${objs['right'][6]}');

      left = m(left, 8, '${objs['bottom'][8]}');
      left = m(left, 5, '${objs['bottom'][7]}');
      left = m(left, 2, '${objs['bottom'][6]}');
    } else if (side == 'back' && direction == 1) {
      top = m(top, 0, '${objs['left'][6]}');
      top = m(top, 1, '${objs['left'][3]}');
      top = m(top, 2, '${objs['left'][0]}');

      right = m(right, 2, '${objs['top'][0]}');
      right = m(right, 5, '${objs['top'][1]}');
      right = m(right, 8, '${objs['top'][2]}');

      bottom = m(bottom, 2, '${objs['right'][2]}');
      bottom = m(bottom, 1, '${objs['right'][5]}');
      bottom = m(bottom, 0, '${objs['right'][8]}');

      left = m(left, 6, '${objs['bottom'][2]}');
      left = m(left, 3, '${objs['bottom'][1]}');
      left = m(left, 0, '${objs['bottom'][0]}');
    } else if (side == 'front' && direction == -1) {
      top = m(top, 6, '${objs['right'][0]}');
      top = m(top, 7, '${objs['right'][3]}');
      top = m(top, 8, '${objs['right'][6]}');

      right = m(right, 0, '${objs['bottom'][8]}');
      right = m(right, 3, '${objs['bottom'][7]}');
      right = m(right, 6, '${objs['bottom'][6]}');

      bottom = m(bottom, 6, '${objs['left'][2]}');
      bottom = m(bottom, 7, '${objs['left'][5]}');
      bottom = m(bottom, 8, '${objs['left'][8]}');

      left = m(left, 2, '${objs['top'][8]}');
      left = m(left, 5, '${objs['top'][7]}');
      left = m(left, 8, '${objs['top'][6]}');
    } else if (side == 'back' && direction == -1) {
      top = m(top, 0, '${objs['right'][2]}');
      top = m(top, 1, '${objs['right'][5]}');
      top = m(top, 2, '${objs['right'][8]}');

      right = m(right, 2, '${objs['bottom'][2]}');
      right = m(right, 5, '${objs['bottom'][1]}');
      right = m(right, 8, '${objs['bottom'][0]}');

      bottom = m(bottom, 2, '${objs['left'][6]}');
      bottom = m(bottom, 1, '${objs['left'][3]}');
      bottom = m(bottom, 0, '${objs['left'][0]}');

      left = m(left, 6, '${objs['top'][0]}');
      left = m(left, 3, '${objs['top'][1]}');
      left = m(left, 0, '${objs['top'][2]}');
    }
    if (side == 'front') {
      // front
      if (direction == 1) {
        front = rotateFace(front, -1);
      } else {
        front = rotateFace(front, 1);
      }
    } else if (side == 'back') {
      // back
      if (direction == 1) {
        back = rotateFace(back, -1);
      } else {
        back = rotateFace(back, 1);
      }
    }
    draw();
    // solver.feed(sides());
    // solver.isSolved();
  }

  // event listeners
  querySelector('#right')?.onClick.listen((event) {
    rotateX('right', 1);
  });
  querySelector('#right_shtrih')?.onClick.listen((event) {
    rotateX('right', -1);
  });

  querySelector('#left')?.onClick.listen((event) {
    rotateX('left', -1);
  });
  querySelector('#left_shtrih')?.onClick.listen((event) {
    rotateX('left', 1);
  });

  querySelector('#x')?.onClick.listen((event) {
    rotateXself();
  });
  querySelector('#x_shtrih')?.onClick.listen((event) {
    rotateXself();
    rotateXself();
    rotateXself();
  });

  querySelector('#y')?.onClick.listen((event) {
    rotateYself();
  });
  querySelector('#y_shtrih')?.onClick.listen((event) {
    rotateYself();
    rotateYself();
    rotateYself();
  });

  querySelector('#z')?.onClick.listen((event) {
    rotateZself();
  });
  querySelector('#z_shtrih')?.onClick.listen((event) {
    rotateZself();
    rotateZself();
    rotateZself();
  });

  querySelector('#top')?.onClick.listen((event) {
    rotateY('top', 1);
  });
  querySelector('#top_shtrih')?.onClick.listen((event) {
    rotateY('top', -1);
  });

  querySelector('#bottom')?.onClick.listen((event) {
    rotateY('bottom', -1);
  });
  querySelector('#bottom_shtrih')?.onClick.listen((event) {
    rotateY('bottom', 1);
  });

  querySelector('#front')?.onClick.listen((event) {
    rotateZ('front', 1);
  });
  querySelector('#front_shtrih')?.onClick.listen((event) {
    rotateZ('front', -1);
  });

  querySelector('#back')?.onClick.listen((event) {
    rotateZ('back', -1);
  });
  querySelector('#back_shtrih')?.onClick.listen((event) {
    rotateZ('back', 1);
  });
  // shuffle
  querySelector('#shuffle')?.onClick.listen((event) {
    // reset faces
    top = 'wwwwwwwww';
    bottom = 'yyyyyyyyy';
    right = 'rrrrrrrrr';
    left = 'ooooooooo';
    front = 'ggggggggg';
    back = 'bbbbbbbbb';

    // create a list to shuffle
    List<String> notes = [
      'R',
      'R\'',
      'L',
      'L\'',
      'U',
      'U\'',
      'D',
      'D\'',
      'F',
      'F\'',
      'B',
      'B\''
    ];
    String last = '';
    List result = [];
    for (int i = 0; i < 10; i++) {
      var rng = new Random();
      int r = rng.nextInt(notes.length);
      while (last.length > 0 && notes[r][0] == last[0]) {
        r = rng.nextInt(notes.length);
      }
      int rs = rng.nextInt(3);
      if (rs == 0) {
        last = notes[r][0] + '2';
      } else {
        last = notes[r];
      }
      result.add(last);
    }
    // log(result);
    querySelector('#shuffle_result')?.text = result.join(' ');
    String side(String char) {
      switch (char) {
        case 'R':
          return 'right';
        case 'U':
          return 'top';
        case 'L':
          return 'left';
        case 'D':
          return 'bottom';
        case 'F':
          return 'front';
        case 'B':
          return 'back';
      }
      return char;
    }

    for (String i in result) {
      String face = side(i[0]);
      if (i.length > 1) {
        if (i[1] == '\'') {
          querySelector('#${face}_shtrih')?.click();
        } else if (i[1] == '2') {
          querySelector('#${face}')?.click();
          querySelector('#${face}')?.click();
        }
      } else {
        querySelector('#${face}')?.click();
      }
      // log(face);
    }
    draw();
    writeToUI();
  });
  draw();
}
