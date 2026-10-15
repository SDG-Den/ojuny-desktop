ojuny is a "distro" / set of dotfiles based on nixOS in response to omarchy.

omarchy is an opinionated "distribution" that is effectively just a set of dotfiles on arch with hyprland and a custom vibe-coded quickshell.

it is coded almost entirely by AI, and as such has many security vulnerabilities on top of being really hard to troubleshoot and being absolutely *drenched* in AI tooling.

Ojuny will provide the same experience but better, by using nix and by making use of non-vibecoded tooling.


Ojuny will have a layered shape:

- wrapped desktop package providing an ojuny "desktop" package, which provides pre-configured mangoWM and DankMaterial Shell (this repo)

- nixos and home-manager module, exposing many options for DMS and mangoWM in different ways (this repo), this is effectively a wrapper module around DankMaterialShell, DMS + plugins, mangoWM and some of my custom nix applications (see ~/repos), settings exposed in a way it can interact with the nix settings gui easily

- template flake in a git repo to be forked, including a setup script to generate hardware.nix and user.nix, this one also is set up to use my nix settings gui (template repo)

- installer iso with a custom installer that basically just does the same things as the template flake (installer repo, still has to be created)

the goal is for ojuny to be *effectively* deployable on any OS using nix, but primarily be nixOS-based


ojuny is based on the mangoWM desktop config at ~/repos/nixos-configs/dendrite, and the template config will use the same dendritic pattern. ojuny will not include any g13 stuff.




