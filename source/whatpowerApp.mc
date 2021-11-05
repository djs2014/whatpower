import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
using WhatAppBase;

class whatpowerApp extends Application.AppBase {
  var whatApp = null as WhatAppBase.WhatApp;

  function initialize() {
    AppBase.initialize();
    whatApp = new WhatAppBase.WhatApp();
    var appName = Application.loadResource(Rez.Strings.AppName) as Lang.String;
    whatApp.setAppName(appName);
  }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
    }

    function getInitialView() as Array<Views or InputDelegates> ? {
      return whatApp.getInitialView();
    }

    function onSettingsChanged() { whatApp.onSettingsChanged(); }
}

function getApp() as whatpowerApp {
  return Application.getApp() as whatpowerApp;
}