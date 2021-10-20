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
    $._wiMain = getShowInformation($._showInfoMain, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, info);
    $._wiBottom = getShowInformation($._showInfoBottom, $._showInfoHrFallback,
                                     $._showInfoTrainingEffectFallback, info);
    $._wiLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, info);
    $._wiRight = getShowInformation($._showInfoRight, $._showInfoHrFallback,
                                    $._showInfoTrainingEffectFallback, info);

    if ($._wiMain != null) {
      $._wiMain.updateInfo(info);
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
    mWD.setNightMode((getBackgroundColor() == Graphics.COLOR_BLACK));

    $._wiMain = getShowInformation($._showInfoMain, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, null);
    $._wiBottom = getShowInformation($._showInfoBottom, $._showInfoHrFallback,
                                     $._showInfoTrainingEffectFallback, null);
    $._wiLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, null);
    $._wiRight = getShowInformation($._showInfoRight, $._showInfoHrFallback,
                                    $._showInfoTrainingEffectFallback, null);

    // layout options
    // if main then set background color whole field
    // - main & left & right & bottom (main center is slightly bigger)
    // - left & right => larger circles closer to center (1/4 distance)
    // - left & right & bottom (bottom = default/triangle)
    // - main or left or right or bottom => large circle in center
    var showMain = $._wiMain != null;
    var showLeft = $._wiLeft != null;
    var showRight = $._wiRight != null;
    var showBottom = $._wiBottom != null;

    var isTriangleLayout = $._showInfoLayout == LayoutMiddleTriangle;

    mWD.setShowMainInfo(showMain);
    mWD.setShowLeftInfo(showLeft);
    mWD.setShowRightInfo(showRight);
    mWD.setShowBottomInfo(showBottom);

    var mainFontColor = null;
    if (!showMain) {
      mWD.clearDisplay(getBackgroundColor(), getBackgroundColor());
      if (mWD.isNightMode()) {
        mainFontColor = Graphics.COLOR_WHITE;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      } else {
        mainFontColor = Graphics.COLOR_BLACK;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      }

      if (showBottom && isTriangleLayout) {
        // draw in background
        drawBottomDataTriangle(dc);
      }

      drawAdditonalData(dc);

      if (showBottom && !isTriangleLayout) {
        // draw in foreground
        drawBottomDataDefault(dc);
      }
    } else {
      var zone = $._wiMain.zoneInfoValue();
      mWD.clearDisplay(zone.fontColor, zone.color);

      var avgZone = $._wiMain.zoneInfoAverage();
      var radius = dc.getHeight() / 2;
      if (mWD.isWideField()) {
        radius = radius + dc.getHeight() / 5;
      }
      mWD.drawMainInfoCircle(radius, avgZone.color, zone.color, zone.perc,
                             zone.color100perc);

      if (showBottom) {
        drawBottomDataDefault(dc);
      }
      drawAdditonalData(dc);

      var value =
          $._wiMain.formattedValue(mWD.fieldType); 
      mWD.drawMainInfo(zone.fontColor, zone.name, value, $._wiMain.units());

    }
  }

  function drawBottomDataDefault(dc) {
    var value = $._wiBottom.formattedValue(mWD.fieldType);
    var zone = $._wiBottom.zoneInfoValue();
    var label = zone.name;  // @@ should be short

    var color = zone.fontColor;
    var backColor = zone.color;
    var units = $._wiBottom.units();
    mWD.drawBottomInfo(color, label, value, units, backColor, zone.perc,
                       zone.color100perc);
  }
  
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
