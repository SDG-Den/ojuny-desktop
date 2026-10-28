let
  defaultBar = {

    position = 0;

    showOnLastDisplay = true;

    screenPreferences = [ "all" ];

    centerWidgets = [
      "music"
      "clock"
      "weather"
    ];

    openOnOverview = false;

    autoHide = false;

    autoHideDelay = 250;

    attachToScreenEdge = false;

    useOverlayLayer = false;

    transparency = 1;

    widgetTransparency = 1;

    followInterfaceStyle = false;
    surfaceColor = "sch";
    widgetFollowInterfaceStyle = true;

    iconScale = 0.9;

    fontScale = 0.9;

    spacing = 0;

    bottomGap = 0;

    innerPadding = 0;

    widgetPadding = 9;

    squareCorners = true;

    noBackground = false;

    widgetOutlineEnabled = true;

    borderEnabled = false;

    borderColor = "primary";

    borderOpacity = 1;

    borderThickness = 1;

    shadowIntensity = 0;

    shadowOpacity = 60;

    popupGapsAuto = true;

    popupGapsManual = 4;

    island = true;

    islandCompactThickness = 31;

    islandOuterGap = 3;

    islandSatelliteGap = 4;

    islandSatelliteBackground = false;

    islandSatelliteGothCorners = false;

    islandSatelliteHoverGap = 5;

    islandHoverOpenDelay = 350;

    islandHoverCloseDelay = 350;

    islandSpringStiffness = 760;

    islandSpringDamping = 47;

    islandSpringMass = 2;

    islandWidgetPadding = 0;

    islandWidgetOutlineEnabled = true;

    islandWidgetOutlineColor = "surfaceText";

    islandWidgetOutlineOpacity = 0.5;

    gothCornersEnabled = false;

    gothCornerRadiusOverride = false;

    gothCornerRadiusValue = 12;

    leftWidgets = {

      workspaceSwitcher = {
        enabled = true;
        _order = 10;
        showOccupiedWorkspacesOnly = true;
        showWorkspaceIndex = true;
        showWorkspacePadding = true;
        workspacePaddingCount = 5;
        workspaceIndicatorCompact = true;
        dwlShowAllTags = false;
      };

      dankKDEConnect = {
        enabled = true;
        _order = 20;
      };

      layout = {
        enabled = true;
        _order = 30;
      };

      scratchpadHelper = {
        enabled = true;
        _order = 40;
      };

    };

    rightWidgets = {

      systemTray = {
        enabled = true;
        _order = 10;
      };

      clipboard = {
        enabled = true;
        _order = 20;
      };

      developerUtilities = {
        enabled = true;
        _order = 30;
      };

      nixMonitor = {
        enabled = true;
        _order = 40;
      };

      localServices = {
        enabled = true;
        _order = 50;
      };

      controlCenterButton = {
        enabled = true;
        showAudioPercent = true;
        showBatteryIcon = true;
        showBrightnessIcon = true;
        showBrightnessPercent = true;
        showDoNotDisturbIcon = true;
        showIdleInhibitorIcon = true;
        showMicIcon = true;
        showMicPercent = true;
        _order = 60;
      };

    };
  };

  sidebarBar = {
    name = "Sidebar";
    _order = 40;
    leftWidgets = {
      workspaceSwitcher = {
        enabled = true;
        overflowMode = "always";
        showWorkspaceIndex = false;
        showWorkspaceApps = true;
        workspaceIndicatorStyle = "lines";
        workspaceAppIconSizeOffset = 4;
        showOccupiedWorkspacesOnly = true;
        _order = 10;
      };

      network_speed_monitor = {
        enabled = true;
        _order = 20;
      };

      cpuUsage = {
        enabled = true;
        minimumWidth = true;
        _order = 30;
      };

      memUsage = {
        enabled = true;
        showInGb = false;
        showSwap = false;
        _order = 40;
      };

      diskUsage = {
        enabled = true;
        mountPath = "/";
        _order = 50;
      };

      nixMonitor = {
        enabled = true;
        _order = 60;
      };
    };
    centerWidgets = [ ];
    rightWidgets = {
      island = {
        enabled = true;
        islandHomeLayout = [
          {
            id = "media";
            enabled = true;
          }
          {
            id = "notifications";
            enabled = true;
          }
          {
            id = "weather";
            enabled = true;
          }
          {
            id = "volume";
            enabled = true;
          }
          {
            id = "brightness";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "status";
            enabled = true;
          }
        ];
        islandHomeStatusContent = "battery";
        islandBatteryStyle = "ring";
        islandHomeCompactTight = false;
        islandWidgetBackground = true;
        islandRouteLauncher = "island";
        islandRouteControlCenter = "island";
        islandRouteNotificationCenter = "island";
        islandRouteClipboard = "island";
        _order = 10;
      };
    };
    attachToScreenEdge = false;
    autoHide = false;
    autoHideDelay = 250;
    barLengthMode = "full";
    batteryColorMode = "level";
    borderColor = "surfaceText";
    borderEnabled = false;
    borderOpacity = 1;
    borderThickness = 2;
    bottomGap = 0;
    dot = false;
    followInterfaceStyle = false;
    fontScale = 0.9;
    gothCornerRadiusOverride = false;
    gothCornerRadiusValue = 12;
    gothCornersEnabled = false;
    hoverPopouts = true;
    iconScale = 0.9;
    innerPadding = 24;
    island = false;
    islandCompactThickness = 31;
    islandHoverCloseDelay = 350;
    islandHoverOpenDelay = 350;
    islandOuterGap = 3;
    islandSatelliteBackground = false;
    islandSatelliteGap = 4;
    islandSatelliteGothCorners = false;
    islandSpringDamping = 47;
    islandSpringMass = 2;
    islandSpringStiffness = 760;
    leftOverflowPosition = 0;
    maximizeWidgetIcons = false;
    maximizeWidgetText = false;
    noBackground = true;
    openOnOverview = false;
    popupGapsAuto = true;
    popupGapsManual = 4;
    position = 2;
    screenPreferences = [
      "all"
    ];
    shadowIntensity = 0;
    shadowOpacity = 60;
    showOnLastDisplay = true;
    spacing = 0;
    squareCorners = true;
    surfaceColor = "sch";
    transparency = 1;
    useOverlayLayer = false;
    widgetFollowInterfaceStyle = true;
    widgetOutlineEnabled = true;
    widgetPadding = 0;
    widgetStyle = "pills";
    widgetTransparency = 1;
  };
in
{
  customBase = defaultBar;

  presets = {
    default = {
      name = "Default";
      _order = 5;
      leftWidgets = {
        workspaceSwitcher = {
          dwlShowAllTags = false;
          enabled = true;
          showOccupiedWorkspacesOnly = true;
          showWorkspaceIndex = true;
          showWorkspacePadding = true;
          workspacePaddingCount = 5;
          _order = 10;
        };

        dankKDEConnect = {
          enabled = true;
          _order = 20;
        };

        layout = {
          enabled = true;
          _order = 30;
        };

        scratchpadHelper = {
          enabled = true;
          _order = 40;
        };
      };
      centerWidgets = [
        "music"
        "clock"
        "weather"
      ];
      rightWidgets = {
        systemTray = {
          _order = 10;
        };

        clipboard = {
          _order = 20;
        };

        developerUtilities = {
          enabled = true;
          _order = 30;
        };

        nixMonitor = {
          enabled = true;
          _order = 40;
        };

        localServices = {
          enabled = true;
          _order = 50;
        };

        controlCenterButton = {
          enabled = true;
          showAudioPercent = true;
          showBatteryIcon = true;
          showBrightnessIcon = true;
          showBrightnessPercent = true;
          showDoNotDisturbIcon = true;
          showIdleInhibitorIcon = true;
          showMicIcon = true;
          showMicPercent = true;
          _order = 60;
        };
      };
      attachToScreenEdge = false;
      autoHide = false;
      autoHideDelay = 250;
      borderColor = "primary";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 1;
      bottomGap = 0;
      followInterfaceStyle = false;
      fontScale = 0.9;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = false;
      iconScale = 0.9;
      innerPadding = 0;
      island = true;
      islandCompactThickness = 31;
      islandHoverCloseDelay = 350;
      islandHoverOpenDelay = 350;
      islandOuterGap = 3;
      islandSatelliteBackground = false;
      islandSatelliteGap = 4;
      islandSatelliteGothCorners = false;
      islandSpringDamping = 47;
      islandSpringMass = 2;
      islandSpringStiffness = 760;
      noBackground = false;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 0;
      screenPreferences = [
        "all"
      ];
      shadowIntensity = 0;
      shadowOpacity = 60;
      showOnLastDisplay = true;
      spacing = 0;
      squareCorners = true;
      surfaceColor = "sch";
      transparency = 1;
      useOverlayLayer = false;
      widgetFollowInterfaceStyle = true;
      widgetOutlineEnabled = true;
      widgetPadding = 9;
      widgetTransparency = 1;
    };

    taskbar = {
      name = "Taskbar";
      _order = 20;
      leftWidgets = {
        launcherButton = {
          enabled = true;
          overflowMode = "bar";
          launcherLogoMode = "os";
          launcherLogoColorOverride = "primary";
          launcherLogoSizeOffset = 12;
          _order = 10;
        };

        runningApps = {
          enabled = true;
          runningAppsCompactMode = false;
          runningAppsGroupByApp = false;
          runningAppsCurrentMonitor = true;
          _order = 20;
        };
      };
      centerWidgets = [ ];
      rightWidgets = {
        systemTray = {
          enabled = true;
          _order = 10;
        };

        controlCenterButton = {
          enabled = true;
          showAudioPercent = true;
          showMicIcon = true;
          showMicPercent = true;
          showBrightnessIcon = true;
          showBrightnessPercent = true;
          showBatteryIcon = true;
          showIdleInhibitorIcon = true;
          showDoNotDisturbIcon = true;
          _order = 20;
        };

        clock = {
          enabled = true;
          _order = 30;
        };

        notificationButton = {
          enabled = true;
          _order = 40;
        };
      };
      attachToScreenEdge = false;
      autoHide = false;
      autoHideDelay = 250;
      borderColor = "primary";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 1;
      bottomGap = 0;
      dot = false;
      followInterfaceStyle = false;
      fontScale = 0.9;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = false;
      iconScale = 0.9;
      innerPadding = 6;
      island = false;
      islandCompactThickness = 31;
      islandHoverCloseDelay = 350;
      islandHoverOpenDelay = 350;
      islandOuterGap = 3;
      islandSatelliteBackground = false;
      islandSatelliteGap = 4;
      islandSatelliteGothCorners = false;
      islandSpringDamping = 47;
      islandSpringMass = 2;
      islandSpringStiffness = 760;
      maximizeWidgetIcons = true;
      maximizeWidgetText = true;
      noBackground = true;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 1;
      screenPreferences = [
        "all"
      ];
      shadowIntensity = 0;
      shadowOpacity = 60;
      showOnLastDisplay = true;
      spacing = 0;
      squareCorners = true;
      surfaceColor = "default";
      transparency = 1;
      useOverlayLayer = false;
      widgetFollowInterfaceStyle = true;
      widgetOutlineEnabled = true;
      widgetPadding = 9;
      widgetStyle = "segments";
      widgetTransparency = 1;
    };

    status = {
      name = "Status";
      _order = 30;
      leftWidgets = {
        workspaceSwitcher = {
          enabled = true;
          workspaceIndicatorStyle = "pills";
          showWorkspaceIndex = false;
          showWorkspaceName = false;
          showWorkspaceApps = false;
          showOccupiedWorkspacesOnly = true;
          workspaceFocusedBorderEnabled = false;
          _order = 10;
        };

        layout = {
          enabled = true;
          _order = 20;
        };

        systemTray = {
          enabled = true;
          _order = 30;
        };

        music = {
          enabled = true;
          _order = 40;
        };
      };
      centerWidgets = [
        {
          id = "dankKDEConnect";
          enabled = true;
        }
        {
          id = "focusedWindow";
          enabled = true;
        }
        {
          id = "notificationButton";
          enabled = true;
        }
      ];
      rightWidgets = {
        nixMonitor = {
          enabled = true;
          _order = 10;
        };

        controlCenterButton = {
          enabled = true;
          showAudioPercent = true;
          showMicIcon = true;
          showMicPercent = true;
          showBrightnessIcon = true;
          showBrightnessPercent = true;
          showIdleInhibitorIcon = true;
          showDoNotDisturbIcon = true;
          _order = 20;
        };

        battery = {
          enabled = true;
          showBatteryTime = true;
          showBatteryTimeOnlyOnBattery = false;
          showBatteryPowerCharging = false;
          batteryStyle = "ring";
          _order = 30;
        };

        clock = {
          enabled = true;
          _order = 40;
        };
      };
      attachToScreenEdge = true;
      autoHide = false;
      autoHideDelay = 250;
      barLengthMode = "full";
      batteryColorMode = "level";
      borderColor = "primary";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 1;
      bottomGap = 0;
      dot = false;
      followInterfaceStyle = false;
      fontScale = 0.9;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = false;
      hoverPopouts = true;
      iconScale = 0.9;
      innerPadding = -6;
      island = false;
      islandCompactThickness = 31;
      islandHoverCloseDelay = 350;
      islandHoverOpenDelay = 350;
      islandOuterGap = 3;
      islandSatelliteBackground = false;
      islandSatelliteGap = 4;
      islandSatelliteGothCorners = false;
      islandSpringDamping = 47;
      islandSpringMass = 2;
      islandSpringStiffness = 760;
      maximizeWidgetIcons = true;
      maximizeWidgetText = true;
      noBackground = true;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 0;
      screenPreferences = [
        "all"
      ];
      shadowIntensity = 0;
      shadowOpacity = 60;
      showOnLastDisplay = true;
      spacing = 0;
      squareCorners = false;
      surfaceColor = "sch";
      transparency = 1;
      useOverlayLayer = false;
      widgetFollowInterfaceStyle = true;
      widgetOutlineEnabled = true;
      widgetPadding = 9;
      widgetStyle = "segments";
      widgetTransparency = 1;
    };

    caelestia = {
      name = "Caelestia";
      _order = 60;
      leftWidgets = {
        layout = {
          enabled = true;
          _order = 10;
        };

        workspaceSwitcher = {
          enabled = true;
          workspaceIndicatorStyle = "pills";
          showOccupiedWorkspacesOnly = true;
          showWorkspaceIndex = true;
          reverseScrolling = true;
          _order = 20;
        };

        music = {
          enabled = true;
          _order = 30;
        };
      };
      centerWidgets = [ ];
      rightWidgets = {
        dankKDEConnect = {
          enabled = true;
          _order = 10;
        };

        controlCenterButton = {
          enabled = true;
          _order = 20;
        };

        nixMonitor = {
          enabled = true;
          _order = 30;
        };

        clock = {
          enabled = true;
          _order = 40;
        };

        notificationButton = {
          enabled = true;
          _order = 50;
        };
      };
      attachToScreenEdge = false;
      autoHide = false;
      autoHideDelay = 250;
      barLengthMode = "full";
      batteryColorMode = "level";
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 2;
      bottomGap = 0;
      dot = false;
      followInterfaceStyle = false;
      fontScale = 0.9;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = false;
      hoverPopouts = true;
      iconScale = 0.9;
      innerPadding = 24;
      island = false;
      islandCompactThickness = 31;
      islandHoverCloseDelay = 350;
      islandHoverOpenDelay = 350;
      islandOuterGap = 3;
      islandSatelliteBackground = false;
      islandSatelliteGap = 4;
      islandSatelliteGothCorners = false;
      islandSpringDamping = 47;
      islandSpringMass = 2;
      islandSpringStiffness = 760;
      leftOverflowMode = "bar";
      leftOverflowPosition = 0;
      maximizeWidgetIcons = false;
      maximizeWidgetText = true;
      noBackground = true;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 2;
      screenPreferences = [
        "all"
      ];
      shadowIntensity = 0;
      shadowOpacity = 60;
      showOnLastDisplay = true;
      spacing = 0;
      squareCorners = false;
      surfaceColor = "sch";
      transparency = 1;
      useOverlayLayer = false;
      widgetFollowInterfaceStyle = true;
      widgetOutlineEnabled = true;
      widgetPadding = 0;
      widgetStyle = "flat";
      widgetTransparency = 1;
    };

    goth = {
      name = "Goth";
      _order = 70;
      leftWidgets = {
        workspaceSwitcher = {
          enabled = true;
          showWorkspaceIndex = true;
          workspaceIndicatorStyle = "cards";
          showWorkspaceApps = true;
          showOccupiedWorkspacesOnly = true;
          _order = 10;
        };
      };
      centerWidgets = [
        {
          id = "runningApps";
          enabled = true;
          runningAppsCompactMode = false;
          runningAppsGroupByApp = true;
          runningAppsCurrentWorkspace = true;
          runningAppsCurrentMonitor = true;
        }
      ];
      rightWidgets = {
        controlCenterButton = {
          enabled = true;
          showAudioPercent = true;
          showMicIcon = true;
          showMicPercent = true;
          showBrightnessIcon = true;
          showBrightnessPercent = true;
          showBatteryIcon = false;
          showIdleInhibitorIcon = true;
          showDoNotDisturbIcon = true;
          _order = 10;
        };

        battery = {
          enabled = true;
          batteryStyle = "ring";
          _order = 20;
        };

        notificationButton = {
          enabled = true;
          _order = 30;
        };
      };
      attachToScreenEdge = false;
      autoHide = false;
      autoHideDelay = 250;
      barLengthMode = "full";
      batteryColorMode = "level";
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 2;
      bottomGap = 0;
      dot = false;
      followInterfaceStyle = false;
      fontScale = 0.9;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = true;
      hoverPopouts = true;
      iconScale = 0.9;
      innerPadding = 0;
      island = false;
      islandCompactThickness = 31;
      islandHoverCloseDelay = 350;
      islandHoverOpenDelay = 350;
      islandOuterGap = 3;
      islandSatelliteBackground = false;
      islandSatelliteGap = 4;
      islandSatelliteGothCorners = false;
      islandSpringDamping = 47;
      islandSpringMass = 2;
      islandSpringStiffness = 760;
      leftOverflowMode = "bar";
      leftOverflowPosition = 0;
      maximizeWidgetIcons = false;
      maximizeWidgetText = true;
      noBackground = false;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 0;
      screenPreferences = [
        "all"
      ];
      shadowIntensity = 0;
      shadowOpacity = 60;
      showOnLastDisplay = true;
      spacing = 0;
      squareCorners = true;
      surfaceColor = "sch";
      transparency = 1;
      useOverlayLayer = false;
      widgetFollowInterfaceStyle = true;
      widgetOutlineEnabled = false;
      widgetPadding = 0;
      widgetStyle = "segments";
      widgetTransparency = 1;
    };

    simple-island = {
      name = "Simple Island";
      _order = 80;
      leftWidgets = { };
      centerWidgets = [
        {
          id = "runningApps";
          enabled = true;
          runningAppsCompactMode = false;
          runningAppsGroupByApp = true;
          runningAppsCurrentWorkspace = true;
          runningAppsCurrentMonitor = true;
        }
      ];
      rightWidgets = { };
      attachToScreenEdge = false;
      autoHide = false;
      autoHideDelay = 250;
      barLengthMode = "full";
      batteryColorMode = "theme";
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 2;
      bottomGap = 0;
      dot = false;
      followInterfaceStyle = false;
      fontScale = 0.9;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = true;
      hoverPopouts = true;
      iconScale = 0.9;
      innerPadding = 0;
      island = true;
      islandBatteryStyle = "ring";
      islandCompactThickness = 31;
      islandFloating = true;
      islandHighContrast = false;
      islandHomeClockDisplay = "time";
      islandHomeCompactTight = false;
      islandHomeLayout = [
        {
          id = "media";
          enabled = true;
        }
        {
          id = "notifications";
          enabled = true;
        }
        {
          id = "weather";
          enabled = true;
        }
        {
          id = "clock";
          enabled = true;
        }
        {
          id = "volume";
          enabled = true;
        }
        {
          id = "brightness";
          enabled = true;
        }
        {
          id = "status";
          enabled = true;
        }
      ];
      islandHomeVolumeDisplay = "both";
      islandHoverCloseDelay = 350;
      islandHoverOpenDelay = 350;
      islandOuterGap = 6;
      islandPalette = "default";
      islandPlacement = "edge";
      islandRouteClipboard = "island";
      islandRouteControlCenter = "island";
      islandRouteLauncher = "island";
      islandRouteNotificationCenter = "island";
      islandSatelliteBackground = false;
      islandSatelliteGap = 4;
      islandSatelliteGothCorners = false;
      islandSatellitesEnabled = false;
      islandSpringDamping = 47;
      islandSpringMass = 2;
      islandSpringStiffness = 760;
      leftOverflowMode = "bar";
      leftOverflowPosition = 0;
      maximizeWidgetIcons = false;
      maximizeWidgetText = true;
      noBackground = false;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 0;
      screenPreferences = [
        "all"
      ];
      shadowIntensity = 0;
      shadowOpacity = 60;
      showOnLastDisplay = true;
      spacing = 0;
      squareCorners = true;
      surfaceColor = "sch";
      transparency = 1;
      useOverlayLayer = false;
      widgetFollowInterfaceStyle = true;
      widgetOutlineEnabled = false;
      widgetPadding = 0;
      widgetStyle = "segments";
      widgetTransparency = 1;
    };

    simple-bar = {
      name = "Simple Bar";
      _order = 90;
      leftWidgets = {
        layout = {
          enabled = true;
          _order = 10;
        };

        workspaceSwitcher = {
          enabled = true;
          _order = 20;
        };

        music = {
          enabled = true;
          _order = 30;
        };

        systemTray = {
          enabled = true;
          _order = 40;
        };
      };
      centerWidgets = [
        {
          id = "runningApps";
          enabled = true;
          runningAppsCompactMode = false;
          runningAppsGroupByApp = true;
          runningAppsCurrentMonitor = true;
        }
      ];
      rightWidgets = {
        controlCenterButton = {
          enabled = true;
          _order = 10;
        };

        battery = {
          enabled = true;
          batteryStyle = "ring";
          _order = 20;
        };

        notificationButton = {
          enabled = true;
          _order = 30;
        };

        clock = {
          enabled = true;
          _order = 40;
        };

        powerMenuButton = {
          enabled = true;
          _order = 50;
        };
      };
      attachToScreenEdge = false;
      autoHide = false;
      autoHideDelay = 250;
      barInsetPadding = 10;
      barLengthMode = "percent";
      barLengthPercent = 99;
      batteryColorMode = "theme";
      borderColor = "surfaceText";
      borderEnabled = false;
      borderOpacity = 1;
      borderThickness = 2;
      bottomGap = 0;
      dot = false;
      followInterfaceStyle = false;
      fontScale = 0.9;
      gothCornerRadiusOverride = false;
      gothCornerRadiusValue = 12;
      gothCornersEnabled = false;
      hoverPopouts = true;
      iconScale = 0.9;
      innerPadding = 0;
      island = false;
      islandBatteryStyle = "ring";
      islandCompactThickness = 31;
      islandFloating = true;
      islandHighContrast = false;
      islandHomeClockDisplay = "time";
      islandHomeCompactTight = false;
      islandHomeLayout = [
        {
          id = "media";
          enabled = true;
        }
        {
          id = "notifications";
          enabled = true;
        }
        {
          id = "weather";
          enabled = true;
        }
        {
          id = "clock";
          enabled = true;
        }
        {
          id = "volume";
          enabled = true;
        }
        {
          id = "brightness";
          enabled = true;
        }
        {
          id = "status";
          enabled = true;
        }
      ];
      islandHomeVolumeDisplay = "both";
      islandHoverCloseDelay = 350;
      islandHoverOpenDelay = 350;
      islandOuterGap = 6;
      islandPalette = "default";
      islandPlacement = "edge";
      islandRouteClipboard = "island";
      islandRouteControlCenter = "island";
      islandRouteLauncher = "island";
      islandRouteNotificationCenter = "island";
      islandSatelliteBackground = false;
      islandSatelliteGap = 4;
      islandSatelliteGothCorners = false;
      islandSatellitesEnabled = false;
      islandSpringDamping = 47;
      islandSpringMass = 2;
      islandSpringStiffness = 760;
      leftOverflowMode = "bar";
      leftOverflowPosition = 0;
      maximizeWidgetIcons = false;
      maximizeWidgetText = true;
      noBackground = false;
      openOnOverview = false;
      popupGapsAuto = true;
      popupGapsManual = 4;
      position = 0;
      screenPreferences = [
        "all"
      ];
      shadowIntensity = 0;
      shadowOpacity = 60;
      showOnLastDisplay = true;
      spacing = 4;
      squareCorners = false;
      surfaceColor = "sch";
      transparency = 1;
      useOverlayLayer = false;
      widgetFollowInterfaceStyle = true;
      widgetOutlineColor = "surfaceText";
      widgetOutlineEnabled = false;
      widgetPadding = 8;
      widgetStyle = "pills";
      widgetTransparency = 1;
    };

    sidebar-left = sidebarBar // {
      name = "Sidebar Left";
      _order = 40;
      position = 2;
    };

    sidebar-right = sidebarBar // {
      name = "Sidebar Right";
      _order = 50;
      position = 3;
    };

    none = {
      name = "None";
      _order = 100;
      position = 0;
      island = false;
      leftWidgets = { };
      centerWidgets = [ ];
      rightWidgets = { };
    };
  };
}
