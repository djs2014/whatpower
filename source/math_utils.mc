import Toybox.System;

function min(a as Lang.Number, b as Lang.Number) {
  if (a <= b) {
    return a;
  } else {
    return b;
  }
}

function max(a as Lang.Number, b as Lang.Number) {
  if (a >= b) {
    return a;
  } else {
    return b;
  }
}

function compareTo(numberA, numberB) {
  if (numberA > numberB) {
    return 1;
  } else if (numberA < numberB) {
    return -1;
  } else {
    return 0;
  }
}

function percentageOf(value, max) {
  if (max == 0 || max < 0) {
    return 0;
  }
  return value / (max / 100.0);
}