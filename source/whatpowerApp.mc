import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatUtils as Utils;
using WhatAppBase;

var _wiTop as WhatInformation;
var _wiLeft as WhatInformation;
var _wiRight as WhatInformation;
var _wiBottom as WhatInformation;

var _wPower as WhatPower;
var _wHeartrate as WhateHeartrate;
var _wCadence as WhatCadence;
var _wGrade as WhatGrade;
var _wDistance as WhatDistance;
var _wAltitude as WhatAltitude;
var _wSpeed as WhatSpeed;
var _wPressure as WhatPressure;
var _wCalories as WhatCalories;
var _wTrainingEffect as WhatTrainingEffect;
var _wTime as WhatTime;
var _wHeading as WhatHeading;
var _wEngergyExpenditure as WhatEngergyExpenditure;

var _showInfoTop = WhatAppBase.ShowInfoPower;
var _showInfoLeft = WhatAppBase.ShowInfoNothing;
var _showInfoRight = WhatAppBase.ShowInfoNothing;
var _showInfoBottom = WhatAppBase.ShowInfoNothing;
var _showInfoHrFallback = WhatAppBase.ShowInfoNothing;
var _showInfoTrainingEffectFallback = WhatAppBase.ShowInfoNothing;
var _showInfoLayout = WhatAppBase.LayoutMiddleCircle;
var _showSealevelPressure = true;

class whatpowerApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();

    _wPower = new WhatAppBase.WhatPower();
    _wHeartrate = new WhatAppBase.WhateHeartrate();
    _wCadence = new WhatAppBase.WhatCadence();
    _wDistance = new WhatAppBase.WhatDistance();
    _wAltitude = new WhatAppBase.WhatAltitude();
    _wGrade = new WhatAppBase.WhatGrade();
    _wSpeed = new WhatAppBase.WhatSpeed();
    _wPressure = new WhatAppBase.WhatPressure();
    _wCalories = new WhatAppBase.WhatCalories();
    _wTrainingEffect = new WhatAppBase.WhatTrainingEffect();
    _wTime = new WhatAppBase.WhatTime();
    _wHeading = new WhatAppBase.WhatHeading();
    _wEngergyExpenditure = new WhatAppBase.WhatEngergyExpenditure();
  }

  // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    //! Return the initial view of your application here
    function getInitialView() as Array<Views or InputDelegates> ? {
      loadUserSettings();
      return [new whatpowerView()] as Array < Views or InputDelegates > ;
    }

    function onSettingsChanged() { loadUserSettings(); }

    function loadUserSettings() {
      try {
        $._showInfoTop = Utils.getNumberProperty("showInfoTop", WhatAppBase.ShowInfoTrainingEffect);
        $._showInfoLeft =
            Utils.getNumberProperty("showInfoLeft", WhatAppBase.ShowInfoPower);
        $._showInfoRight =
            Utils.getNumberProperty("showInfoRight", WhatAppBase.ShowInfoHeartrate);
        $._showInfoBottom =
            Utils.getNumberProperty("showInfoBottom", WhatAppBase.ShowInfoCalories);
        $._showInfoHrFallback =
            Utils.getNumberProperty("showInfoHrFallback", WhatAppBase.ShowInfoCadence);
        $._showInfoTrainingEffectFallback = Utils.getNumberProperty(
            "showInfoTrainingEffectFallback", WhatAppBase.ShowInfoEnergyExpenditure);

        $._showInfoLayout =
            Utils.getNumberProperty("showInfoLayout", WhatAppBase.LayoutMiddleCircle);

        _wPower.setFtp(Utils.getNumberProperty("ftpValue", 200));
        _wPower.setPerSec(Utils.getNumberProperty("powerPerSecond", 3));

        _wPressure.setShowSeaLevelPressure(
            Utils.getBooleanProperty("showSeaLevelPressure", true));
        _wPressure.setPerMin(
            Utils.getNumberProperty("calcAvgPressurePerMinute", 30));
        _wPressure.reset();  //@@ QnD start activity

        _wHeartrate.initZones();
        _wSpeed.setTargetSpeed(Utils.getNumberProperty("targetSpeed", 30));
        _wCadence.setTargetCadence(
            Utils.getNumberProperty("targetCadence", 95));
        _wDistance.setTargetDistance(
            Utils.getNumberProperty("targetDistance", 150));
        _wCalories.setTargetCalories(
            Utils.getNumberProperty("targetCalories", 2000));
        _wEngergyExpenditure.setTargetEngergyExpenditure(
            Utils.getNumberProperty("targetEnergyExpenditure", 15));
        _wHeading.setMinimalLocationAccuracy(
            Utils.getNumberProperty("minimalLocationAccuracy", 2));

        System.println("Settings loaded");
      } catch (ex) {
        ex.printStackTrace();
      }
    }
}

function getApp() as whatpowerApp {
  return Application.getApp() as whatpowerApp;
}