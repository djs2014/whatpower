import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

class WhatDisplay {
  hidden var dc;
  hidden var margin = 1;
  hidden var nightMode = false;

  hidden var mFontLabel = Graphics.FONT_TINY;
  hidden var mFontValue = Graphics.FONT_LARGE;
  hidden var mFontValueSmall = Graphics.FONT_MEDIUM;
  hidden var mFontValueWideField = Graphics.FONT_NUMBER_MILD;
  hidden var mFontBottomLabel = Graphics.FONT_TINY;
  hidden var mFontBottomValue = Graphics.FONT_TINY;
  hidden var mFontUnits = Graphics.FONT_XTINY;
  hidden var mFontAdditional = Graphics.FONT_XTINY;
  hidden var mFontAdditionalLarger = Graphics.FONT_TINY;

  hidden var widthAdditionalInfo = 15;
  hidden var fontAdditionalInfo = mFontAdditional;

  var width = 0;
  var height = 0;
  var field = SmallField;

   function initialize() { }

  function isSmallField() { return field == SmallField; }
  function isWideField() { return field == WideField; }
  function isOneField() { return field == OneField; }
  function isNightMode() { return nightMode; }
  function setNightMode(nightMode) { self.nightMode = nightMode; }
  function onLayout(dc as Dc) {
    self.dc = dc;

    self.width = dc.getWidth();
    self.height = dc.getHeight();
    self.field = SmallField;

    if (self.width >= 246) {
      self.field = WideField;
      if (self.height >= 322) {
        self.field = OneField;
      }
    }

    // if (self.height < 80) {
    //   self.field = SmallField;
    // }

    // 1 large field: w[246] h[322]
    // 2 fields: w[246] h[160]
    // 3 fields: w[246] h[106]

    widthAdditionalInfo = 28;
    fontAdditionalInfo = mFontAdditionalLarger;
    if (isSmallField()) {
      widthAdditionalInfo = widthAdditionalInfo - 10;
      fontAdditionalInfo = mFontAdditional;
    }
  }
  function onUpdate(dc as Dc) {
    if (dc has : setAntiAlias) {
      dc.setAntiAlias(true);
    }
    onLayout(dc);
  }

  function clearDisplay(color, backColor) {
    dc.setColor(color, backColor);
    dc.clear();
  }

  function drawPercentageCircle(x, y, radius, perc) {
    if (perc == null || perc == 0) {
      return;
    }

    if (perc >= 100.0) {
      dc.fillCircle(x, y, radius);
      return;
    }
    var degrees = 3.6 * perc;

    var degreeStart = 180;                  // 180deg == 9 o-clock
    var degreeEnd = degreeStart - degrees;  // 90deg == 12 o-clock

    dc.setPenWidth(radius);
    dc.drawArc(x, y, radius / 2, Graphics.ARC_CLOCKWISE, degreeStart,
               degreeEnd);
    dc.setPenWidth(1.0);
  }
  function drawPercentageLine(x, y, maxwidth, percentage) {
    var wPercentage = maxwidth / 100.0 * percentage;
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawLine(x, y, x + wPercentage, y);
    dc.drawPoint(x + maxwidth, y);
  }
  
  function drawMainInfoCircle(radius, outlineColor, inlineColor, percentage) {
    var x = dc.getWidth() / 2;
    var y = dc.getHeight() / 2;

    dc.setColor(outlineColor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(x, y, radius + 2);

    dc.setColor(inlineColor, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(x, y, radius);

    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

    dc.fillCircle(x, y, radius - 4);

    dc.setColor(WhatColor.COLOR_WHITE_GRAY_2, Graphics.COLOR_TRANSPARENT);
    drawPercentageCircle(x, y, radius - 4, percentage);
  }

  function drawMainInfo(color, label, value, units) {
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

    var fontValue = mFontValueWideField;
    if (isSmallField()) {
      fontValue = mFontValue;
    }
    var wv = dc.getTextWidthInPixels(value, fontValue);
    if (wv >= (dc.getWidth() - (4 * widthAdditionalInfo))) {
      fontValue = mFontValueSmall;
      wv = dc.getTextWidthInPixels(value, fontValue);
    }

    var hl = dc.getFontHeight(mFontLabel);
    var hv = dc.getFontHeight(fontValue);
    var yl = dc.getHeight() / 2 - hv + margin;  //(hv / 2) - 1;
    var wp = dc.getTextWidthInPixels(units, mFontUnits);
    var xv = dc.getWidth() / 2 - (wv + wp) / 2;

    if (isSmallField()) {
      // label
      yl = dc.getHeight() / 2 - hl - 2;  // (hv / 2) - margin;
      dc.drawText(dc.getWidth() / 2, yl, mFontLabel, label,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      // value
      dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, fontValue, value,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
      // units
      dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + (hv / 2), mFontUnits,
                  units,
                  Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    } else {
      // label
      // var wl = dc.getTextWidthInPixels(label, mFontLabel);
      // drawPercentageCircle(dc.getWidth() / 2 - wl / 2 - 7, yl + hl/2, 5,
      // perc);

      dc.drawText(dc.getWidth() / 2, yl, mFontLabel, label,
                  Graphics.TEXT_JUSTIFY_CENTER);
      // value
      dc.drawText(xv, dc.getHeight() / 2, fontValue, value,
                  Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

      dc.drawText(xv + wv + 1, dc.getHeight() / 2, mFontUnits, units,
                  Graphics.TEXT_JUSTIFY_LEFT);
    }
  }

  function drawBottomInfo(color, label, value, units, backColor, percentage) {
    var hv = dc.getFontHeight(mFontBottomValue);

    var wBottomBar = dc.getWidth() - (4 * widthAdditionalInfo + margin);

    var wl = dc.getTextWidthInPixels(label, mFontBottomLabel);
    var wv = dc.getTextWidthInPixels(value, mFontBottomValue);
    var wp = dc.getTextWidthInPixels(units, mFontUnits);

    var marginleft1 = 2;
    var marginleft2 = 2;
    if (isSmallField()) {
      // no label
      marginleft1 = 0;
      wl = 0;
    }
    var wtot = wl + marginleft1 + wv + marginleft2 + wp;

    var xv = dc.getWidth() / 2 - wtot / 2;
    var y = dc.getHeight() - (hv / 2);

    if (backColor != null) {
      dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
    }
    var xb = 2 * widthAdditionalInfo + margin;
    var yb = dc.getHeight() - hv + 2;
    var yPercentage = dc.getHeight() - 2;
    var wPercentage = wBottomBar / 100.0 * percentage;
    if (isSmallField()) {
      yb = dc.getHeight() - 5;
      dc.fillRoundedRectangle(xb, yb, wBottomBar, 5, 3);
    } else {
      dc.fillRoundedRectangle(xb, yb, wBottomBar, hv, 3);
    }
    drawPercentageLine(xb, yPercentage, wBottomBar, percentage);

    if (isSmallField()) {
      return;
    }

    if (color != null) {
      dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    }

    dc.drawText(xv, y, mFontBottomLabel, label,
                Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

    dc.drawText(xv + wl + marginleft1, y, mFontBottomValue, value,
                Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

    if (wtot < wBottomBar) {
      // There is room for units
      dc.drawText(xv + wl + marginleft1 + wv + marginleft2, y, mFontUnits,
                  units,
                  Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
  }

  function drawLeftInfo(color, value, backColor, units, outlineColor,
                        percentage) {
    var barX = widthAdditionalInfo + margin;

    // circle back color
    drawAdditonalInfoBG(barX, widthAdditionalInfo, backColor, percentage);
    
    // units + value color
    if (units == null || units.length() == 0) {
      drawAdditonalInfoFGNoUnits(barX, widthAdditionalInfo, color, value);
    } else {
      drawAdditonalInfoFG(barX, widthAdditionalInfo, color, value,
                          fontAdditionalInfo, units, fontAdditionalInfo);
    }
    // outline
    drawAdditonalInfoOutline(barX, widthAdditionalInfo, outlineColor);
  }

  function drawRightInfo(color, value, backColor, units, outlineColor,
                         percentage) {
    var barX = dc.getWidth() - widthAdditionalInfo - margin;
    // circle back color
    drawAdditonalInfoBG(barX, widthAdditionalInfo, backColor, percentage);

    // units + value color
    if (units == null || units.length() == 0) {
      drawAdditonalInfoFGNoUnits(barX, widthAdditionalInfo, color, value);
    } else {
      drawAdditonalInfoFG(barX, widthAdditionalInfo, color, value,
                          fontAdditionalInfo, units, fontAdditionalInfo);
    }
    // outline
    drawAdditonalInfoOutline(barX, widthAdditionalInfo, outlineColor);
  }
  hidden function drawAdditonalInfoBG(x, width, color, percentage) {
    dc.setColor(WhatColor.COLOR_WHITE_GRAY_1, Graphics.COLOR_TRANSPARENT);
    dc.fillCircle(x, dc.getHeight() - 2 * margin - width, width);

    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    drawPercentageCircle(x, dc.getHeight() - 2 * margin - width, width,
                         percentage);
  }

  hidden function drawAdditonalInfoFG(x, width, color, value, fontValue, label,
                                      fontLabel) {
    var ha = dc.getFontHeight(fontValue);
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, dc.getHeight() - 2 * margin - width - ha, fontLabel, label,
                Graphics.TEXT_JUSTIFY_CENTER);

    dc.drawText(x, dc.getHeight() - 2 * margin - width, fontValue, value,
                Graphics.TEXT_JUSTIFY_CENTER);
  }

  hidden function drawAdditonalInfoFGNoUnits(x, width, color, value) {
    var fontValue = mFontAdditionalLarger;
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    dc.drawText(x, dc.getHeight() - 2 * margin - width, fontValue, value,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  hidden function drawAdditonalInfoOutline(x, width, color) {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    dc.drawCircle(x, dc.getHeight() - 2 * margin - width, width);
  }
}

enum {
  SmallField = 0,
  WideField = 1,
  OneField = 2
}
