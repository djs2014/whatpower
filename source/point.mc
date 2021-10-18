class Point {
  var x;
  var y;
  function asArray() { return [ x, y ]; }
  function toString() { return "[" + x + "," + y + "]"; }
  function initialize(x, y) {
    self.x = x;
    self.y = y;
  }
}