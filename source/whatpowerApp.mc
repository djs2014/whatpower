import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

var _wPower as WhatPower;
var _wHeartrate as WhateHeartrate;
var _wCadence as WhatCadence;
var _wGrade as WhatGrade;
var _wDistance as WhatDistance;
var _wAltitude as WhatAltitude;
var _wSpeed as WhatSpeed;
var _wPowerressure as WhatPressure;
var _wCalories as WhatCalories;
var _wTrainingEffect as WhatTrainingEffect;
var _wTime as WhatTime;
var _wHeading as WhatHeading;

var _showInfoMain = ShowInfoPower;
var _showInfoLeft = ShowInfoNothing;
var _showInfoRight = ShowInfoNothing;
var _showInfoBottom = ShowInfoNothing;
var _showInfoHrFallback = ShowInfoNothing;

var _showSealevelPressure = true;

class whatpowerApp extends Application.AppBase {
  function initialize() {
    AppBase.initialize();

    _wPower = new WhatPower(); 
    _wHeartrate = new WhateHeartrate();
    _wCadence = new WhatCadence();
    _wDistance = new WhatDistance();
    _wAltitude = new WhatAltitude();
    _wGrade = new WhatGrade();
    _wSpeed = new WhatSpeed();
    _wPowerressure = new WhatPressure();
    _wCalories = new WhatCalories();
    _wTrainingEffect = new WhatTrainingEffect();
    _wTime = new WhatTime();
    _wHeading = new WhatHeading();
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
        $._showInfoMain = getNumberProperty("showInfoMain", ShowInfoPower);
        $._showInfoLeft = getNumberProperty("showInfoLeft", ShowInfoHeartrate);
        $._showInfoRight = getNumberProperty("showInfoRight", ShowInfoCadence);
        $._showInfoBottom = getNumberProperty("showInfoBottom", ShowInfoSpeed);
        $._showInfoHrFallback =
            getNumberProperty("showInfoHrFallback", ShowInfoSpeed);

        _wPower.setFtp(getNumberProperty("ftpValue", 200));
        _wPower.setPerSec(getNumberProperty("powerPerSecond", 3));

        _wPowerressure.setShowSeaLevelPressure(
            getBooleanProperty("showSeaLevelPressure", true));
        _wPowerressure.setPerMin(getNumberProperty("calcAvgPressurePerMinute", 30));
        _wPowerressure.reset();  //@@ QnD start activity

        _wHeartrate.initZones();
        _wSpeed.setTargetSpeed(getNumberProperty("targetSpeed", 30));
        _wCadence.setTargetCadence(getNumberProperty("targetCadence", 95));
        _wDistance.setTargetDistance(getNumberProperty("targetDistance", 150));
        _wCalories.setTargetCalories(getNumberProperty("targetCalories", 2000));

        System.println("Settings loaded");
      } catch (ex) {
        ex.printStackTrace();
      }
    }
}

function getApp() as whatpowerApp {
  return Application.getApp() as whatpowerApp;
}