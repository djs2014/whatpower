import Toybox.Activity;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class whatpowerView extends WatchUi.DataField {
  hidden var mFontLabel = Graphics.FONT_TINY;
  hidden var mFontValue = Graphics.FONT_LARGE;
  hidden var mFontValueWideField = Graphics.FONT_NUMBER_MILD;
  hidden var mFontPostfix = Graphics.FONT_XTINY;
  hidden var mFontAdditional = Graphics.FONT_XTINY;
  hidden var mFontAdditionalLarger = Graphics.FONT_TINY;
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
    _wHeartrate.setCurrent(info);
    _wPower.setCurrent(info);
    _wCadence.setCurrent(info);
    _wDistance.setCurrent(info);
    _wAltitude.setCurrent(info);
    _wGrade.setCurrent(info);
    _wSpeed.setCurrent(info);
    _wPowerressure.setCurrent(info);
    _wCalories.setCurrent(info);
    _wTrainingEffect.setCurrent(info);
    _wTime.setCurrent(info);
    _wHeading.setCurrent(info);
    _wEngergyExpenditure.setCurrent(info);
  }

  // Display the value you computed here. This will be called
  // once a second when the data field is visible.
  function onUpdate(dc as Dc) as Void {
    mWD.onUpdate(dc);
    mWD.setNightMode((getBackgroundColor() == Graphics.COLOR_BLACK));
    mWD.clearDisplay(getBackgroundColor(), getBackgroundColor());

    // @@ Show right metric

    var mainFontColor = null;
    var wInfo = getShowInformation($._showInfoMain, $._showInfoHrFallback);
    if (wInfo == null) {
      if (mWD.isNightMode()) {
        mainFontColor = Graphics.COLOR_WHITE;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
      } else {
        mainFontColor = Graphics.COLOR_BLACK;
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
      }
      drawAdditonalData(dc);
    } else {
      var zone = wInfo.zoneInfoValue();
      mainFontColor = zone.fontColor;
      mWD.clearDisplay(zone.fontColor, zone.color);

      var avgZone = wInfo.zoneInfoAverage();
      var radius = dc.getHeight() / 2;
      if (mWD.isWideField()) {
        radius = radius + dc.getHeight() / 5;
      }
      mWD.drawMainInfoCircle(radius, avgZone.color, zone.color, zone.perc);

      drawAdditonalData(dc);

      var value = wInfo.formattedValue(mWD.field);  // @@ rename to fieldType
      mWD.drawMainInfo(zone.fontColor, zone.name, value, wInfo.units());
    }

    var wInfoBottom =
        getShowInformation($._showInfoBottom, $._showInfoHrFallback);
    if (wInfoBottom != null) {
      var value = wInfoBottom.formattedValue(mWD.field);
      var color = mainFontColor;
      var backColor = null;
      var zone = wInfoBottom.zoneInfoValue();
      var label = zone.name;  // @@ should be short

      color = zone.fontColor;
      backColor = zone.color;

      mWD.drawBottomInfo(color, label, value, wInfoBottom.units(), backColor,
                         zone.perc);
    }
  }

  function drawAdditonalData(dc) {
    var wInfoLeft = getShowInformation($._showInfoLeft, $._showInfoHrFallback);
    if (wInfoLeft != null) {
      var value = wInfoLeft.formattedValue(SmallField);
      var zone = wInfoLeft.zoneInfoValue();
      var avgZone = wInfoLeft.zoneInfoAverage();
      mWD.drawLeftInfo(zone.fontColor, value, zone.color, wInfoLeft.units(),
                       avgZone.color, zone.perc);
    }

    var wInfoRight =
        getShowInformation($._showInfoRight, $._showInfoHrFallback);
    if (wInfoRight != null) {
      var value = wInfoRight.formattedValue(SmallField);
      var zone = wInfoRight.zoneInfoValue();
      var avgZone = wInfoRight.zoneInfoAverage();
      mWD.drawRightInfo(zone.fontColor, value, zone.color, wInfoRight.units(),
                        avgZone.color, zone.perc);
    }
  }
}
