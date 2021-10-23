import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class whatpowerView extends WatchUi.DataField {
  hidden var mWD;

  function initialize() {
    DataField.initialize();
    mWD = new WhatDisplay();
  }

  // Set your layout here. Anytime the size of obscurity of
  // the draw context is changed this will be called.
  function onLayout(dc as Dc) as Void { mWD.onLayout(dc); }

  // The given info object contains all the current workout information.
  // Calculate a value and save it locally in this method.
  // Note that compute() and onUpdate() are asynchronous, and there is no
  // guarantee that compute() will be called before onUpdate().
  function compute(info as Activity.Info) as Void {
    $._wiTop = getShowInformation($._showInfoTop, $._showInfoHrFallback,
                                  $._showInfoTrainingEffectFallback, info);
    $._wiBottom = getShowInformation($._showInfoBottom, $._showInfoHrFallback,
                                     $._showInfoTrainingEffectFallback, info);
    $._wiLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, info);
    $._wiRight = getShowInformation($._showInfoRight, $._showInfoHrFallback,
                                    $._showInfoTrainingEffectFallback, info);

    if ($._wiTop != null) {
      $._wiTop.updateInfo(info);
    }
    if ($._wiBottom != null) {
      $._wiBottom.updateInfo(info);
    }
    if ($._wiLeft != null) {
      $._wiLeft.updateInfo(info);
    }
    if ($._wiRight != null) {
      $._wiRight.updateInfo(info);
    }
  }

  // Display the value you computed here. This will be called
  // once a second when the data field is visible.
  function onUpdate(dc as Dc) as Void {
    mWD.onUpdate(dc);
    mWD.clearDisplay(getBackgroundColor(), getBackgroundColor());
    mWD.setNightMode((getBackgroundColor() == Graphics.COLOR_BLACK));
    var TopFontColor = null;
    if (mWD.isNightMode()) {  // @@ in mWD
      TopFontColor = Graphics.COLOR_WHITE;
      dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    } else {
      TopFontColor = Graphics.COLOR_BLACK;
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

    // if (mWD.isSmallField()) {
    //   $._wiTop = null;
    // } else {
    $._wiTop = getShowInformation($._showInfoTop, $._showInfoHrFallback,
                                  $._showInfoTrainingEffectFallback, null);
    // }
    $._wiBottom = getShowInformation($._showInfoBottom, $._showInfoHrFallback,
                                     $._showInfoTrainingEffectFallback, null);
    $._wiLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, null);
    $._wiRight = getShowInformation($._showInfoRight, $._showInfoHrFallback,
                                    $._showInfoTrainingEffectFallback, null);

    var showTop = $._wiTop != null;
    var showLeft = $._wiLeft != null;
    var showRight = $._wiRight != null;
    var showBottom = $._wiBottom != null;

    // var isTriangleLayout = $._showInfoLayout == LayoutMiddleTriangle;

    mWD.setShowTopInfo(showTop);
    mWD.setShowLeftInfo(showLeft);
    mWD.setShowRightInfo(showRight);
    mWD.setShowBottomInfo(showBottom);
    mWD.setMiddleLayout($._showInfoLayout);

    drawTopInfo(dc);
    drawLeftInfo(dc);
    drawRightInfo(dc);
    drawBottomInfo(dc);

    // if (!showTop) {
    //   var drawMiddleInfoInBackground =
    //   mWD.leftAndRightCircleFillWholeScreen(); if (showBottom &&
    //   drawMiddleInfoInBackground) {
    //     if (isTriangleLayout) {
    //       drawBottomDataTriangle(dc);
    //     } else {
    //       drawBottomDataDefault(dc);
    //     }
    //   }
    //   drawAdditonalData(dc);
    //   if (showBottom && !drawMiddleInfoInBackground) {
    //     if (isTriangleLayout) {
    //       drawBottomDataTriangle(dc);
    //     } else {
    //       drawBottomDataDefault(dc);
    //     }
    //   }
    // } else {
    //   var zone = $._wiTop.zoneInfoValue();
    //   mWD.clearDisplay(zone.fontColor, zone.color);

    //   var avgZone = $._wiTop.zoneInfoAverage();
    //   var radius = dc.getHeight() / 2;
    //   if (mWD.isWideField()) {
    //     radius = radius + dc.getHeight() / 5;
    //   }

    //   // TEST
    //   mWD.drawTopInfoCircle(radius, avgZone.color, zone.color, zone.perc,
    //                         zone.color100perc);

    //   drawAdditonalData(dc);

    //   if (showBottom) {
    //     drawBottomDataDefault(dc);
    //   }
    //   var value = $._wiTop.formattedValue(mWD.fieldType);
    //   mWD.drawTopInfo(zone.fontColor, zone.name, value, $._wiTop.units());
    // }
  }

  function drawLeftInfo(dc) {
    if ($._wiLeft == null) {
      return;
    }
    var value = $._wiLeft.formattedValue(SmallField);
    var zone = $._wiLeft.zoneInfoValue();
    var avgZone = $._wiLeft.zoneInfoAverage();
    mWD.drawLeftInfo(zone.fontColor, value, zone.color, $._wiLeft.units(),
                     avgZone.color, zone.perc, zone.color100perc);
  }
  function drawTopInfo(dc) {
    if ($._wiTop == null) {
      return;
    }
    var value = $._wiTop.formattedValue(SmallField);
    var zone = $._wiTop.zoneInfoValue();
    var avgZone = $._wiTop.zoneInfoAverage();
    mWD.drawTopInfo(zone.name, zone.fontColor, value, zone.color, $._wiTop.units(),
                    avgZone.color, zone.perc, zone.color100perc);
  }

  function drawRightInfo(dc) {
    if ($._wiRight == null) {
      return;
    }
    var value = $._wiRight.formattedValue(SmallField);
    var zone = $._wiRight.zoneInfoValue();
    var avgZone = $._wiRight.zoneInfoAverage();
    mWD.drawRightInfo(zone.fontColor, value, zone.color, $._wiRight.units(),
                      avgZone.color, zone.perc, zone.color100perc);
  }

  function drawBottomInfo(dc) {
    if ($._wiBottom == null) {
      return;
    }
    var value = $._wiBottom.formattedValue(mWD.fieldType);
    var zone = $._wiBottom.zoneInfoValue();
    var label = zone.name;  // @@ should be short
    mWD.drawBottomInfo(zone.fontColor, label, value, $._wiBottom.units(),
                       zone.color, zone.perc, zone.color100perc);
  }

  // function drawBottomDataDefault(dc) {
  //   var value = $._wiBottom.formattedValue(mWD.fieldType);
  //   var zone = $._wiBottom.zoneInfoValue();
  //   var label = zone.name;  // @@ should be short

  //   var color = zone.fontColor;
  //   var backColor = zone.color;
  //   var units = $._wiBottom.units();
  //   mWD.drawBottomInfo(color, label, value, units, backColor, zone.perc,
  //                      zone.color100perc);
  // }

  function drawBottomDataTriangle(dc) {
    var value = $._wiBottom.formattedValue(mWD.fieldType);
    var zone = $._wiBottom.zoneInfoValue();
    var label = zone.name;  // @@ should be short

    var color = zone.fontColor;
    var backColor = zone.color;

    mWD.drawInfoTriangleThingy(color, label, value, $._wiBottom.units(),
                               backColor, zone.perc, zone.color100perc);
  }

  function drawAdditonalData(dc) {
    // @@ set circle positions + circle width -> inside mWD based on what info
    // is displayed
    if ($._wiLeft != null) {
      var value = $._wiLeft.formattedValue(SmallField);
      var zone = $._wiLeft.zoneInfoValue();
      var avgZone = $._wiLeft.zoneInfoAverage();
      mWD.drawLeftInfo(zone.fontColor, value, zone.color, $._wiLeft.units(),
                       avgZone.color, zone.perc, zone.color100perc);
    }

    if ($._wiRight != null) {
      var value = $._wiRight.formattedValue(SmallField);
      var zone = $._wiRight.zoneInfoValue();
      var avgZone = $._wiRight.zoneInfoAverage();
      mWD.drawRightInfo(zone.fontColor, value, zone.color, $._wiRight.units(),
                        avgZone.color, zone.perc, zone.color100perc);
    }
  }
}
