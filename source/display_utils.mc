import Toybox.Graphics;
import Toybox.System;
import Toybox.Lang;

class WhatDisplay {
  hidden var dc;
  hidden var margin = 1;  // y @@
  hidden var marginLeft = 1;
  hidden var marginRight = 1;
  hidden var backgroundColor = Graphics.COLOR_WHITE;
  hidden var nightMode = false;
  hidden var showMainCircle = true;

  hidden var mFontLabel = Graphics.FONT_TINY;
  hidden var mFontValue = Graphics.FONT_LARGE;
  hidden var mFontValueSmall = Graphics.FONT_MEDIUM;
  hidden var mFontValueWideField = Graphics.FONT_NUMBER_MILD;
  hidden var mFontBottomLabel = Graphics.FONT_TINY;
  hidden var mFontBottomValue = Graphics.FONT_TINY;
  hidden var mFontUnits = Graphics.FONT_XTINY;

  hidden var mFontLabelAdditional = Graphics.FONT_XTINY;
  hidden var mFontValueAdditionalIndex = 1;
  hidden var mFontValueAdditional = [
    Graphics.FONT_SYSTEM_SMALL, Graphics.FONT_SYSTEM_MEDIUM,
    Graphics.FONT_SYSTEM_LARGE, Graphics.FONT_NUMBER_MILD
  ];
  hidden var _widthAdditionalInfo = 15;

  var width = 0;
  var height = 0;
  var field = SmallField;

  function initialize() {}

  function isSmallField() { return field == SmallField; }
  function isWideField() { return field == WideField; }
  function isOneField() { return field == OneField; }
  function isNightMode() { return nightMode; }
  function setNightMode(nightMode) { self.nightMode = nightMode; }
  function setShowMainCircle(showMainCircle) {
    self.showMainCircle = showMainCircle;
  }

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
    if (showMainCircle) {
      _widthAdditionalInfo = 32.0f;
      mFontValueAdditionalIndex = 2;
      if (isSmallField()) {
        _widthAdditionalInfo = _widthAdditionalInfo - 10.0f;
        mFontValueAdditionalIndex = 1;
      }
    } else {
      _widthAdditionalInfo = min(dc.getWidth() / 4, dc.getHeight() / 2 + 10);
      mFontValueAdditionalIndex = 3;
      if (isSmallField()) {
        _widthAdditionalInfo = 29.0f;
        mFontValueAdditionalIndex = 1;
      }
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

  function drawMainInfoCircle(radius, outlineColor, inlineColor, percentage, color100perc) {
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
    var widthValue = dc.getTextWidthInPixels(value, fontValue);
    if (widthValue >= (dc.getWidth() - (4 * _widthAdditionalInfo))) {
      fontValue = mFontValueSmall;
      widthValue = dc.getTextWidthInPixels(value, fontValue);
    }

    var hl = dc.getFontHeight(mFontLabel);
    var hv = dc.getFontHeight(fontValue);
    var yl = dc.getHeight() / 2 - hv + margin;
    var widthUnits = dc.getTextWidthInPixels(units, mFontUnits);
    var xv =
        dc.getWidth() / 2 -
        (widthValue) / 2;  // dc.getWidth() / 2 - (widthValue + widthUnits) / 2;

    if (isSmallField()) {
      // label
      yl = dc.getHeight() / 2 - hl - 2;
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
      // var widthLabel = dc.getTextWidthInPixels(label, mFontLabel);
      // drawPercentageCircle(dc.getWidth() / 2 - widthLabel / 2 - 7, yl + hl/2,
      // 5, perc);

      dc.drawText(dc.getWidth() / 2, yl, mFontLabel, label,
                  Graphics.TEXT_JUSTIFY_CENTER);
      // value
      dc.drawText(xv, dc.getHeight() / 2, fontValue, value,
                  Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

      dc.drawText(xv + widthValue + 1, dc.getHeight() / 2, mFontUnits, units,
                  Graphics.TEXT_JUSTIFY_LEFT);
    }
  }

  function drawBottomInfo(color, label, value, units, backColor, percentage,
                          color100perc) {
    if (showMainCircle) {
      drawBottomInfoBarThingy(color, label, value, units, backColor,
                              percentage);
    } else {
      drawBottomInfoTriangleThingy(color, label, value, units, backColor,
                                   percentage, color100perc);
    }
  }

  // @@ add parameter calc 100% color and  backColor100perc to left/right/main
  function drawBottomInfoTriangleThingy(color, label, value, units, backColor,
                                        percentage, color100perc) {
    // polygon
    var wBottomBar =
        dc.getWidth() - (3 * _widthAdditionalInfo) + marginLeft + marginRight;

    var top = new Point(dc.getWidth() / 2, margin);
    var left =
        new Point(dc.getWidth() / 2 - wBottomBar / 2, dc.getHeight() - margin);
    var right =
        new Point(dc.getWidth() / 2 + wBottomBar / 2, dc.getHeight() - margin);
    var pts = [ top.asArray(), right.asArray(), left.asArray(), top.asArray() ];

    if (percentage < 100 || color100perc == null) {
      dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    } else {
      dc.setColor(color100perc, Graphics.COLOR_TRANSPARENT);
      percentage = percentage - 100;
    }
    dc.fillPolygon(pts);

    // perc triangle
    var columnHeight = dc.getHeight() - 2 * margin;
    var y = percentageToYpostion(percentage, margin, columnHeight);

    var slopeLeft = slopeOfLine(left.x, left.y, top.x, top.y);
    var slopeRight = slopeOfLine(right.x, right.y, top.x, top.y);

    // System.println("top" + top + "left" + left + " right" + right +
    //                " slopeLeft:" + slopeLeft + " slopeRight:" + slopeRight);
    if (slopeLeft != 0.0 and slopeRight != 0.0) {
      var x1 = (y - left.y) / slopeLeft;
      x1 = x1 + left.x;
      var x2 = (y - right.y) / slopeRight;
      x2 = x2 + right.x;

      // System.println("slopeLeft:" + slopeLeft + " slopeRight:" + slopeRight +
      //                " y:" + y + " x1:" + x1 + " x2:" + x2);

      pts = [[x1, y], [x2, y], right.asArray(), left.asArray(), [x1, y]];
      dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
      dc.fillPolygon(pts);
    }
    // @@ > 100% bg == 100% color => calc perc - 100;
    // @@
  }

  function drawBottomInfoBarThingy(color, label, value, units, backColor,
                                   percentage) {
    var hv = dc.getFontHeight(mFontBottomValue);

    var wBottomBar =
        dc.getWidth() - (3 * _widthAdditionalInfo) + marginLeft + marginRight;

    var widthLabel = dc.getTextWidthInPixels(label, mFontBottomLabel);
    var widthValue = dc.getTextWidthInPixels(value, mFontBottomValue);
    var widthUnits = dc.getTextWidthInPixels(units, mFontUnits);

    var marginleft1 = 2;
    var marginleft2 = 2;
    if (isSmallField()) {
      if (!showMainCircle) {
        wBottomBar = dc.getWidth() - (2 * _widthAdditionalInfo);
      }
      // no label
      marginleft1 = 0;
      widthLabel = 0;
    }
    var wtot = widthLabel + marginleft1 + widthValue + marginleft2 + widthUnits;
    var drawUnits = (wtot < wBottomBar);
    if (!drawUnits) {
      wtot = widthLabel + marginleft1 + widthValue;
    }

    var xv = dc.getWidth() / 2 - wtot / 2;
    var y = dc.getHeight() - (hv / 2);

    if (backColor != null) {
      dc.setColor(backColor, Graphics.COLOR_TRANSPARENT);
    }
    var xb = dc.getWidth() / 2 -
             wBottomBar / 2;  // 2 * _widthAdditionalInfo + margin;
    var yb = dc.getHeight() - hv + 2;
    var yPercentage = dc.getHeight() - 2;
    var wPercentage = wBottomBar / 100.0 * percentage;
    if (isSmallField()) {
      yb = dc.getHeight() - 5;
      dc.fillRoundedRectangle(xb, yb, wBottomBar, hv / 2, 3);
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

    dc.drawText(xv + widthLabel + marginleft1, y, mFontBottomValue, value,
                Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

    if (drawUnits) {
      dc.drawText(xv + widthLabel + marginleft1 + widthValue + marginleft2, y,
                  mFontUnits, units,
                  Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
    }
  }

  function drawLeftInfo(color, value, backColor, units, outlineColor,
                        percentage, color100perc) {
    var barX = _widthAdditionalInfo + marginLeft;

    // circle back color
    drawAdditonalInfoBG(barX, _widthAdditionalInfo, backColor, percentage, color100perc);

    var fontValue = getFontAdditionalInfo(_widthAdditionalInfo * 2, value);
    // units + value color
    if (units == null || units.length() == 0) {
      drawAdditonalInfoFGNoUnits(barX, _widthAdditionalInfo, color, value,
                                 fontValue);
    } else {
      drawAdditonalInfoFG(barX, _widthAdditionalInfo, color, value, fontValue,
                          units, mFontLabelAdditional);
    }
    // outline
    drawAdditonalInfoOutline(barX, _widthAdditionalInfo, outlineColor);
  }

  function drawRightInfo(color, value, backColor, units, outlineColor,
                         percentage, color100perc) {
    var barX = dc.getWidth() - _widthAdditionalInfo - marginRight;
    // circle
    drawAdditonalInfoBG(barX, _widthAdditionalInfo, backColor, percentage, color100perc);

    // outline
    drawAdditonalInfoOutline(barX, _widthAdditionalInfo, outlineColor);

    // units + value
    var fontValue = getFontAdditionalInfo(_widthAdditionalInfo * 2, value);
    if (units == null || units.length() == 0) {
      drawAdditonalInfoFGNoUnits(barX, _widthAdditionalInfo, color, value,
                                 fontValue);
    } else {
      drawAdditonalInfoFG(barX, _widthAdditionalInfo, color, value, fontValue,
                          units, mFontLabelAdditional);
    }
  }

  hidden function getCenterYcoordCircleAdditionalInfo(width) {
    if (showMainCircle) {
      return dc.getHeight() - 2 * margin - width;
    } else {
      return dc.getHeight() / 2;
    }
  }
  hidden function drawAdditonalInfoBG(x, width, color, percentage, color100perc) {

    var y = getCenterYcoordCircleAdditionalInfo(width);

    if (percentage < 100 || color100perc == null) {
      dc.setColor(WhatColor.COLOR_WHITE_GRAY_1, Graphics.COLOR_TRANSPARENT);
    } else {
      dc.setColor(color100perc, Graphics.COLOR_TRANSPARENT);
      percentage = percentage - 100;
    }

    dc.fillCircle(x, y, width);

    if (color == backgroundColor) {
      color = WhatColor.COLOR_WHITE_GRAY_1;
    }
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    drawPercentageCircle(x, y, width, percentage);
  }

  hidden function getFontAdditionalInfo(maxwidth, value) {
    var font = mFontValueAdditional[mFontValueAdditionalIndex];
    var widthValue = dc.getTextWidthInPixels(value, font);

    if (widthValue > maxwidth && mFontValueAdditionalIndex > 0) {
      font = mFontValueAdditional[mFontValueAdditionalIndex - 1];
    }
    return font;
  }

  hidden function drawAdditonalInfoFG(x, width, color, value, fontValue, label,
                                      fontLabel) {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    // value
    var y = getCenterYcoordCircleAdditionalInfo(width);
    dc.drawText(x, y, fontValue, value,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    // label
    var ha = dc.getFontHeight(fontValue);
    y = y + ha / 2;
    dc.drawText(x, y, fontLabel, label,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  hidden function drawAdditonalInfoFGNoUnits(x, width, color, value,
                                             fontValue) {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    var y = getCenterYcoordCircleAdditionalInfo(width);
    dc.drawText(x, y, fontValue, value,
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
  }

  hidden function drawAdditonalInfoOutline(x, width, color) {
    dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    var y = getCenterYcoordCircleAdditionalInfo(width);
    dc.drawCircle(x, y, width);
  }

  //! Get correct y position based on a percentage
  hidden function percentageToYpostion(percentage, marginTop, columnHeight) {
    return marginTop + columnHeight - (columnHeight * (percentage / 100.0));
  }
}

enum {
  SmallField = 0,
  WideField = 1,
  OneField = 2
}
