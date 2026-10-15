{
  # DMS settings. Scalar/attr keys live in `settings`; the collection keys
  # (barConfigs, dockConfigs, controlCenterWidgets, dashCards, dashTabs,
  # dashOptions) are stored as attrs keyed by id with an extra `_order`
  # field and are rendered back to arrays by lib/mk-config.nix.

    settings = {
      animationDuration = 350;
      barElevationEnabled = false;
      builtInPluginSettings = {
        dms_clipboard_search = {
          trigger = "cb";
        };
        dms_power = {
          trigger = "pw";
        };
        dms_qr_generator = {
          trigger = "qrg";
        };
        dms_settings_search = {
          trigger = "?";
        };
      };
      configVersion = 36;
      dmsWindowsFloatingSeeded = [ "mango" "mango" ];
      launcherStyle = "island";
      modalAnimationDuration = 231;
      motionEffect = 1;
      muxType = "zellij";
      notificationAnimationDuration = 400;
      notificationBodyFontSize = 10;
      notificationCompactMode = true;
      notificationFocusedMonitor = true;
      notificationOverlayEnabled = true;
      notificationShowTimeoutBar = true;
      notificationSummaryFontSize = 16;
      osdAlwaysShowValue = true;
      popoutAnimationDuration = 476;
      spotlightBarShowModeChips = true;
      syncComponentAnimationSpeeds = false;
      systemTrayIconTintMode = "primary";
      widgetBackgroundColor = "sch";
    };
    barConfigs = {
      default = {
        attachToScreenEdge = false;
        autoHide = false;
        autoHideDelay = 250;
        borderColor = "primary";
        borderEnabled = false;
        borderOpacity = 1;
        borderThickness = 1;
        bottomGap = 0;
        centerWidgets = [ "music" "clock" "weather" ];
        enabled = true;
        fontScale = 0.9;
        gothCornerRadiusOverride = false;
        gothCornerRadiusValue = 12;
        gothCornersEnabled = false;
        iconScale = 0.9;
        innerPadding = 0;
        island = true;
        islandCompactThickness = 31;
        islandGothCornerRadiusOverride = false;
        islandGothCornerRadiusValue = 20;
        islandGothCornersEnabled = false;
        islandHoverCloseDelay = 350;
        islandHoverOpenDelay = 350;
        islandOuterGap = 3;
        islandSatelliteGap = 8;
        islandSatelliteHoverGap = 5;
        islandSatelliteHoverSize = 30;
        islandSatelliteHoverSizeExpanded = 24;
        islandSatelliteSize = 26;
        islandSatelliteSizeExpanded = 20;
        islandWidgetOutlineColor = "surfaceText";
        islandWidgetOutlineEnabled = true;
        islandWidgetOutlineOpacity = 0.5;
        islandWidgetPadding = 0;
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
        name = "Main Bar";
        noBackground = false;
        openOnOverview = false;
        popupGapsAuto = true;
        popupGapsManual = 4;
        position = 0;
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
        screenPreferences = [ "all" ];
        shadowIntensity = 0;
        shadowOpacity = 60;
        showOnLastDisplay = true;
        spacing = 0;
        squareCorners = true;
        transparency = 1;
        useOverlayLayer = false;
        visible = true;
        widgetOutlineEnabled = true;
        widgetPadding = 9;
        widgetTransparency = 1;
        _order = 10;
      };
    };
    dockConfigs = {
      dock = {
        autoHide = false;
        borderColor = "secondary";
        borderEnabled = true;
        borderOpacity = 1;
        borderThickness = 1;
        bottomGap = 0;
        editOnRightClick = false;
        enabled = false;
        followInterfaceStyle = true;
        groupByApp = true;
        iconSize = 40;
        indicatorStyle = "line";
        isolateDisplays = true;
        itemSpacing = 4;
        launcherEnabled = true;
        launcherLogoBrightness = 0.5;
        launcherLogoColorOverride = "primary";
        launcherLogoContrast = 1;
        launcherLogoCustomPath = "";
        launcherLogoMode = "os";
        launcherLogoSizeOffset = 0;
        magnification = false;
        magnificationProfile = "parabolic";
        magnificationScale = 130;
        margin = 0;
        maxVisibleApps = 0;
        maxVisibleRunningApps = 0;
        mode = "compact";
        name = "Dock";
        openOnOverview = false;
        order = [ ];
        position = 1;
        restoreSpecialWorkspaceOnClick = false;
        screenPreferences = [ "all" ];
        separatePinnedAndRunningApps = true;
        showOnFullscreen = false;
        showOnLastDisplay = true;
        showOverflowBadge = true;
        showTrash = false;
        smartAutoHide = false;
        spacing = 7;
        taskbarAlign = "center";
        transparency = 1;
        trashCustomCommand = "";
        trashFileManager = "default";
        useOverlayLayer = true;
        widgetExpansion = "popout";
        widgets = {
          dock_launcher = {
            enabled = true;
            widgetId = "dockLauncher";
            _order = 10;
          };
          dock_apps = {
            enabled = true;
            widgetId = "appsDock";
            _order = 20;
          };
          dock_trash = {
            enabled = true;
            widgetId = "dockTrash";
            _order = 30;
          };
        };
        _order = 10;
      };
    };
    controlCenterWidgets = {
      user = {
        col = 0;
        enabled = true;
        h = 1;
        row = 0;
        w = 4;
        _order = 10;
      };
      battery = {
        col = 4;
        enabled = true;
        h = 1;
        row = 0;
        w = 1;
        _order = 20;
      };
      settings = {
        col = 5;
        enabled = true;
        h = 1;
        row = 0;
        small = true;
        w = 1;
        _order = 30;
      };
      lock = {
        col = 6;
        enabled = true;
        h = 1;
        row = 0;
        small = true;
        w = 1;
        _order = 40;
      };
      power = {
        col = 7;
        enabled = true;
        h = 1;
        row = 0;
        small = true;
        w = 1;
        _order = 50;
      };
      brightnessSlider = {
        col = 0;
        enabled = true;
        h = 5;
        row = 1;
        w = 1;
        _order = 60;
      };
      volumeSlider = {
        col = 1;
        enabled = true;
        h = 5;
        row = 1;
        w = 1;
        _order = 70;
      };
      inputVolumeSlider = {
        col = 2;
        enabled = true;
        h = 5;
        row = 1;
        w = 1;
        _order = 80;
      };
      wifi = {
        col = 3;
        enabled = true;
        h = 1;
        row = 1;
        w = 5;
        _order = 90;
      };
      bluetooth = {
        col = 3;
        enabled = true;
        h = 1;
        row = 2;
        w = 5;
        _order = 100;
      };
      builtin_vpn = {
        col = 3;
        enabled = true;
        h = 1;
        row = 3;
        w = 5;
        _order = 110;
      };
      plugin_dankKDEConnect = {
        col = 3;
        enabled = true;
        h = 1;
        row = 4;
        w = 5;
        _order = 120;
      };
      diskUsage = {
        col = 3;
        enabled = true;
        h = 1;
        mountpath = "/";
        row = 5;
        w = 5;
        _order = 130;
      };
      nightMode = {
        col = 4;
        enabled = true;
        footer = true;
        footerW = 1;
        h = 1;
        row = 6;
        w = 2;
        _order = 140;
      };
      doNotDisturb = {
        col = 4;
        enabled = true;
        footer = true;
        footerW = 1;
        h = 1;
        row = 7;
        w = 2;
        _order = 150;
      };
      idleInhibitor = {
        col = 4;
        enabled = true;
        footer = true;
        footerW = 1;
        h = 1;
        row = 6;
        w = 2;
        _order = 160;
      };
      runningApps = {
        enabled = true;
        footer = true;
        h = 1;
        w = 4;
        _order = 170;
      };
    };
    dashCards = {
      clock = {
        col = 2;
        h = 1;
        row = 0;
        w = 1;
        _order = 10;
      };
      weather = {
        col = 0;
        h = 1;
        row = 0;
        w = 2;
        _order = 20;
      };
      notifications = {
        col = 0;
        h = 2;
        row = 4;
        w = 6;
        _order = 30;
      };
      calendar = {
        col = 0;
        h = 3;
        row = 1;
        w = 3;
        _order = 40;
      };
      media = {
        col = 3;
        h = 1;
        row = 3;
        w = 3;
        _order = 50;
      };
      sysmon = {
        col = 3;
        h = 1;
        row = 1;
        w = 3;
        _order = 60;
      };
      network = {
        col = 3;
        h = 1;
        row = 2;
        w = 3;
        _order = 70;
      };
      user = {
        col = 3;
        h = 1;
        row = 0;
        w = 3;
        _order = 80;
      };
    };
    dashTabs = {
      overview = {
        enabled = false;
        _order = 10;
      };
      media = {
        enabled = true;
        _order = 20;
      };
      wallpaper = {
        enabled = true;
        _order = 30;
      };
      weather = {
        enabled = true;
        _order = 40;
      };
      wellbeing = {
        enabled = true;
        _order = 50;
      };
      notifications = {
        enabled = true;
        _order = 60;
      };
    };
    dashOptions = {
      calendar = {
        weekends = true;
      };
      media = {
        playerStyle = "material";
      };
      weather = {
        widgets = {
          conditions = {
            city = false;
            col = 0;
            h = 2;
            row = 2;
            tone = "primary";
            w = 2;
            _order = 10;
          };
          hourly = {
            col = 2;
            forecast = "chart";
            h = 2;
            row = 2;
            w = 2;
            _order = 20;
          };
          humidity = {
            col = 2;
            graphics = true;
            h = 2;
            row = 4;
            tone = "";
            w = 1;
            _order = 30;
          };
          wind = {
            col = 3;
            graphics = true;
            h = 2;
            row = 4;
            tone = "";
            w = 1;
            _order = 40;
          };
          "daily " = {
            col = 0;
            forecast = "chart";
            h = 2;
            row = 0;
            w = 4;
            _order = 50;
          };
          precipitation = {
            col = 1;
            graphics = true;
            h = 2;
            row = 4;
            tone = "";
            w = 1;
            _order = 60;
          };
          uv = {
            col = 0;
            graphics = true;
            h = 2;
            row = 4;
            tone = "";
            w = 1;
            _order = 70;
          };
        };
      };
    };
  }
