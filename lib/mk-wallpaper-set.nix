{ lib, pkgs }:
{
  presets,
  colors ? null,
  userDirectory ? null,
  selectedPreset ? "everforest",
  defaultPreset ? "everforest",
  selectedImage ? null,
  cycleIncludeBuiltins ? true,
}:
let
  imageExtensions = [
    "png"
    "jpg"
    "jpeg"
    "webp"
  ];

  extension =
    name:
    let
      match = builtins.match ".*\\.([A-Za-z0-9]+)$" name;
    in
    if match == null then "" else builtins.head match;

  isImage = name: builtins.elem (lib.toLower (extension name)) imageExtensions;

  directoryFiles =
    if userDirectory == null || !(builtins.pathExists userDirectory) then
      { }
    else
      lib.filterAttrs (name: type: (type == "regular" || type == "symlink") && isImage name) (
        builtins.readDir userDirectory
      );

  safeName = name: lib.strings.sanitizeDerivationName name;

  selectedImageRawName = if selectedImage == null then null else baseNameOf (toString selectedImage);
  selectedImageName = if selectedImageRawName == null then null else safeName selectedImageRawName;

  asPath = value: if builtins.isPath value then value else /. + value;

  storeFile =
    name: value:
    builtins.path {
      path = asPath value;
      name = safeName name;
    };

  userSources =
    lib.mapAttrs' (
      name: _: lib.nameValuePair (safeName name) (storeFile name (userDirectory + "/${name}"))
    ) directoryFiles
    // lib.optionalAttrs (selectedImageRawName != null && !(directoryFiles ? ${selectedImageRawName})) {
      ${selectedImageName} = storeFile selectedImageName selectedImage;
    };

  presetFile =
    name: preset:
    if colors == null then
      preset.file
    else
      import ./mk-recolored-image.nix { inherit lib pkgs; } {
        name = "${name}.png";
        base = preset.file;
        inherit (preset) fills;
        inherit colors;
      };

  presetEntries = lib.mapAttrsToList (name: preset: ''
    cp ${lib.escapeShellArg "${presetFile name preset}"} "$out/builtin/"${lib.escapeShellArg "${name}.png"}
  '') presets;

  userEntries = lib.mapAttrsToList (name: source: ''
    cp ${lib.escapeShellArg "${source}"} "$out/user/"${lib.escapeShellArg name}
  '') userSources;

  wallpaperSet = pkgs.runCommand "ojuny-wallpapers" { } ''
    mkdir -p "$out/builtin" "$out/user"
    ${lib.concatStringsSep "\n" presetEntries}
    ${lib.concatStringsSep "\n" userEntries}
    ln -s ../builtin "$out/user/builtin"
  '';

  userPath = name: "${wallpaperSet}/user/${name}";
  builtinPath = name: "${wallpaperSet}/user/builtin/${name}.png";

  selectedPath =
    if selectedImageName != null then userPath selectedImageName else builtinPath selectedPreset;

  defaultPath =
    let
      entry = presets.${defaultPreset} or null;
    in
    if entry == null then "" else builtinPath defaultPreset;
in
{
  set = wallpaperSet;
  directory = "${wallpaperSet}/user";
  selected = selectedPath;
  default = defaultPath;
  recursive = cycleIncludeBuiltins;
  presets = lib.mapAttrs (name: preset: {
    label = preset.label or name;
    path = builtinPath name;
  }) presets;
  userWallpapers =
    lib.mapAttrs (name: _: userPath (safeName name)) directoryFiles
    // lib.optionalAttrs (selectedImageRawName != null && !(directoryFiles ? ${selectedImageRawName})) {
      ${selectedImageName} = userPath selectedImageName;
    };
}
