
- default output package when run with `nix run` will start the desktop nested

- both DMS and mangoWM have their integrated configurations when started with `nix run`

- nixos module exposes all user-relevant mangoWM and DMS settings as options, sometimes in an indirect way

- mango binds and rules use options space `binds.<mode>.<name>.(modifier/keys/dispatcher/args)` and `rule.<type>.<name>.(filter/args)` (will probably need other stuff in front of it)

- some options are synced between mangowm and dms

- stylix integration

- comes with terminal, file browser, nix-apps, vscodium, micro, git and other neccesities/dependencies (valent, nom, etc) by default

- has optional "default apps" setting that installs additional default apps

-
