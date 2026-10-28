{ lib, pkgs }:
let
  mimeTypes = [
    "inode/directory"
    "x-scheme-handler/trash"
    "x-scheme-handler/sftp"
    "x-scheme-handler/smb"
    "x-scheme-handler/ftp"
    "x-scheme-handler/webdav"
    "x-scheme-handler/dav"
    "x-scheme-handler/davs"
    "application/zip"
    "application/x-tar"
    "application/gzip"
    "application/x-compressed-tar"
    "application/x-bzip2"
    "application/x-bzip2-compressed-tar"
    "application/x-xz"
    "application/x-xz-compressed-tar"
    "application/zstd"
    "application/x-zstd-compressed-tar"
    "application/x-lzma"
    "application/x-lzma-compressed-tar"
    "application/x-7z-compressed"
    "application/vnd.rar"
    "application/x-cpio"
  ];

  resolve =
    { fileManager, duxFiles }:
    let
      enabled = fileManager.enable;
      package =
        if !enabled then
          null
        else if fileManager.package == "dux-files" then
          duxFiles
        else if fileManager.package == "nautilus" then
          pkgs.nautilus
        else
          fileManager.customPackage;
      desktopId =
        if !enabled then
          null
        else if fileManager.package == "dux-files" then
          "dev.duxlabs.files.desktop"
        else if fileManager.package == "nautilus" then
          "org.gnome.Nautilus.desktop"
        else
          null;
      command =
        if fileManager.package == "dux-files" then
          "dfiles open"
        else if fileManager.package == "nautilus" then
          "nautilus --new-window"
        else
          fileManager.customCommand;
      portal = enabled && fileManager.portal && fileManager.package == "dux-files";
      mimeApplications = lib.genAttrs mimeTypes (_: [ desktopId ]);
    in
    {
      inherit
        package
        desktopId
        command
        portal
        ;
      mimeApplications = if desktopId == null then { } else mimeApplications;
    };
in
{
  inherit mimeTypes resolve;
}
