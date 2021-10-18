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
    mWD.clearDisplay(getBackgroundColor(), getBackgroundColor());

    $._wiMain = getShowInformation($._showInfoMain, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, null);
    $._wiBottom = getShowInformation($._showInfoBottom, $._showInfoHrFallback,
                                     $._showInfoTrainingEffectFallback, null);
    $._wiLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback,
                                   $._showInfoTrainingEffectFallback, null);
    $._wiRight = getShowInformation($._showInfoRight, $._showInfoHrFallback,
                                    $._showInfoTrainingEffectFallback, null);

    var mainFontColor = null;    
    mWD.setShowMainCircle($._wiMain != null);
    if ($._wiMain == null) {
      if (mWD.isNightMode()) {
        mainFontColor = Graphics.COLOR_WHITE;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      } else {
        mainFontColor = Graphics.COLOR_BLACK;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      }
      drawAdditonalData(dc);
    } else {
      var zone = $._wiMain.zoneInfoValue();
      mainFontColor = zone.fontColor;
      mWD.clearDisplay(zone.fontColor, zone.color);

      var avgZone = $._wiMain.zoneInfoAverage();
      var radius = dc.getHeight() / 2;
      if (mWD.isWideField()) {
        radius = radius + dc.getHeight() / 5;
      }
      mWD.drawMainInfoCircle(radius, avgZone.color, zone.color, zone.perc, zone.color100perc);

      drawAdditonalData(dc);

      var value = $._wiMain.formattedValue(mWD.field);  // @@ rename to fieldType
      mWD.drawMainInfo(zone.fontColor, zone.name, value, $._wiMain.units());
    }
    
    if ($._wiBottom != null) {
      var value = $._wiBottom.formattedValue(mWD.field);
      var color = mainFontColor;
      var backColor = null;
      var zone = $._wiBottom.zoneInfoValue();
      var label = zone.name;  // @@ should be short

      color = zone.fontColor;
      backColor = zone.color;

      mWD.drawBottomInfo(color, label, value, $._wiBottom.units(), backColor,
                         zone.perc, zone.color100perc);
    }
  }

  function drawAdditonalData(dc) {
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
