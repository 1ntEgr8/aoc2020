import "dart:io";
import "dart:async";
import "dart:math";

getInstructions(from) async {
  String contents = await File(from).readAsString();
  return contents.trim().split("\n");
}

final directions = ['E', 'N', 'W', 'S'];

class State_pt1 {
  int x, y, dir;
  State_pt1(this.x, this.y, this.dir);

  update(msg, val) {
    switch (msg) {
      case 'N':
        y += val;
        break;
      case 'S':
        y -= val;
        break;
      case 'E':
        x += val;
        break;
      case 'W':
        x -= val;
        break;
      case 'L':
        dir = (dir + (val ~/ 90)) % directions.length;
        break;
      case 'R':
        dir = (dir - (val ~/ 90)) % directions.length;
        break;
      case 'F':
        update(directions[dir], val);
        break;
    }
  }
}

class Point {
  int x, y;
  Point(this.x, this.y);

  rotate(deg) {
    var rad = deg * pi / 180;
    var new_x = x * cos(rad) - y * sin(rad);
    var new_y = x * sin(rad) + y * cos(rad);
    x = new_x.round();
    y = new_y.round();
  }

  toString() {
    return "($x,$y)";
  }
}

class State_pt2 {
  Point ship;
  Point waypoint;

  State_pt2(this.ship, this.waypoint);

  update(msg, val) {
    switch (msg) {
      case 'N':
        waypoint.y += val;
        break;
      case 'S':
        waypoint.y -= val;
        break;
      case 'E':
        waypoint.x += val;
        break;
      case 'W':
        waypoint.x -= val;
        break;
      case 'L':
        waypoint.rotate(val);
        break;
      case 'R':
        waypoint.rotate(-val);
        break;
      case 'F':
        ship.x += (waypoint.x * val);
        ship.y += (waypoint.y * val);
        break;
    }
  }
}

void main() async {
  final instructions = await getInstructions("input.txt");
  // final state = State_pt1(0, 0, 0);
  final state = State_pt2(Point(0, 0), Point(10, 1));

  for (var instr in instructions) {
    state.update(instr[0], int.parse(instr.substring(1)));
  }
  // print(state.x.abs() + state.y.abs());
  print(state.ship.x.abs() + state.ship.y.abs());
}
