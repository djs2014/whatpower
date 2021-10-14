import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

class WhatHeading extends WhatBase {
  hidden var currentHeading = 0;

  function initialize() { WhatBase.initialize(); }

  function setCurrent(info as Activity.Info) {
    if (info has : currentHeading) {
      // skip 0 and null values
      if (info.currentHeading) {
        currentHeading = info.currentHeading;
      }
    }
  }

  function getCurrentHeading() {
    if (currentHeading == null) {
      return 0;
    }
    return self.currentHeading;
  }

  function getUnitsLong() as String { return ""; }

  function getUnits() as String { return ""; }

  function getFormatString(fieldType) as String {
    switch (fieldType) {
      case OneField:
      case WideField:
        return "%.2f";
      case SmallField:
      default:
        return "%.1f";
    }
  }

  function convertToDisplayFormat(value, fieldType) as string {
    if (value == null) {
      return "";
    }

    var degrees = rad2deg(value);
    return getCompassDirection(degrees);
  }

  function getZoneInfo(rpm) {
    return new ZoneInfo(0, "Heading", Graphics.COLOR_WHITE,
                        Graphics.COLOR_BLACK, 0);
  }
}