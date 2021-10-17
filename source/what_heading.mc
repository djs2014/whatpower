import Toybox.Lang;
import Toybox.System;
import Toybox.Activity;

class WhatHeading extends WhatBase {
  hidden var calculatedHeading = null;
  hidden var track = 0;

  hidden var previousLocation = null;
  hidden var currentLocation = null;
  hidden var usePosition = true;

  function initialize() { WhatBase.initialize(); }
  
  function setCurrent(info as Activity.Info) {
    if (info has : track) {
      // skip 0 and null values
      if (info.track) {
        track = info.track;
      }
      //System.println(track);
    }

    if (info has : currentLocation) {
      if (info.currentLocation) {
        previousLocation = currentLocation;
        currentLocation = info.currentLocation;
        //System.println("loc: " +  currentLocation.toDegrees());
      }
    }
  }

  function getCurrentHeading() {
    if (usePosition) {
      return self.calculatedHeading;
    } else {
      return self.track;
    }
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
    var degrees = null;
    if (usePosition) {
      degrees = getCalculatedHeading();
    } else {
      if (track != null) {
        degrees = rad2deg(track);
      }
    }
    if (degrees == null) {
      return "";
    }

    return getCompassDirection(degrees);
  }

  function getCalculatedHeading() {
    if (previousLocation == null || currentLocation == null) {
      return null;
    }

    var llFrom = previousLocation.toDegrees();
    var lat1 = llFrom[0];
    var lon1 = llFrom[1];
    var llTo = currentLocation.toDegrees();
    var lat2 = llTo[0];
    var lon2 = llTo[1];
    return getRhumbLineBearing(lat1, lon1, lat2, lon2);
  }

  function getZoneInfo(rpm) {
    return new ZoneInfo(0, "Heading", Graphics.COLOR_WHITE,
                        Graphics.COLOR_BLACK, 0);
  }
}