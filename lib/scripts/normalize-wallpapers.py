#!/usr/bin/env python3
"""Normalize bundled wallpaper artwork to its source theme palette.

Run from the repository root with Pillow and numpy available:

  python3 lib/scripts/normalize-wallpapers.py

The script rewrites the non-Everforest PNGs in place and prints the Nix fill
entries for lib/wallpaper-presets.nix.
"""

from pathlib import Path

import numpy as np
from PIL import Image

WALLPAPERS = Path(__file__).resolve().parent.parent / "wallpapers"

PALETTES = {
    "catppuccin-floyd": [
        ("303446", "base00"),
        ("cdd6f4", "base05"),
        ("f38ba8", "base08"),
        ("fab387", "base09"),
        ("f9e2af", "base0A"),
        ("a6e3a1", "base0B"),
        ("74c7ec", "base0C"),
        ("cba6f7", "base0E"),
    ],
    "catppuccin-stripes": [
        ("1e1e2e", "base00"),
        ("f38ba8", "base08"),
        ("fab387", "base09"),
        ("f9e2af", "base0A"),
        ("a6e3a1", "base0B"),
        ("74c7ec", "base0C"),
        ("cba6f7", "base0E"),
    ],
    "catppuccin-waves": [
        ("11111b", "base00"),
        ("181825", "base01"),
        ("1e1e2e", "base02"),
        ("6c7086", "base03"),
        ("a6adc8", "base04"),
        ("cdd6f4", "base05"),
        ("f38ba8", "base08"),
        ("fab387", "base09"),
        ("f9e2af", "base0A"),
        ("a6e3a1", "base0B"),
        ("94e2d5", "base0C"),
        ("89b4fa", "base0D"),
        ("cba6f7", "base0E"),
        ("f2cdcd", "base0F"),
    ],
    "gruvbox-abstract": [
        ("282828", "base00"),
        ("3c3836", "base01"),
        ("504945", "base02"),
        ("928374", "base03"),
        ("ebdbb2", "base05"),
        ("cc241d", "base08"),
        ("d65d0e", "base09"),
        ("d79921", "base0A"),
        ("98971a", "base0B"),
        ("689d6a", "base0C"),
        ("458588", "base0D"),
        ("b16286", "base0E"),
    ],
    "gruvbox-pacman": [
        ("282828", "base00"),
        ("3c3836", "base01"),
        ("504945", "base02"),
        ("928374", "base03"),
        ("ebdbb2", "base05"),
        ("cc241d", "base08"),
        ("d65d0e", "base09"),
        ("d79921", "base0A"),
        ("98971a", "base0B"),
        ("689d6a", "base0C"),
        ("458588", "base0D"),
        ("b16286", "base0E"),
        ("fe8019", "base09"),
    ],
    "gruvbox-stripes-logo": [
        ("282828", "base00"),
        ("3c3836", "base01"),
        ("504945", "base02"),
        ("928374", "base03"),
        ("ebdbb2", "base05"),
        ("cc241d", "base08"),
        ("d65d0e", "base09"),
        ("d79921", "base0A"),
        ("98971a", "base0B"),
        ("689d6a", "base0C"),
        ("458588", "base0D"),
        ("b16286", "base0E"),
    ],
    "nord-city": [
        ("2e3440", "base00"),
        ("3b4252", "base01"),
        ("434c5e", "base02"),
        ("4c566a", "base03"),
        ("d8dee9", "base05"),
        ("bf616a", "base08"),
        ("d08770", "base09"),
        ("ebcb8b", "base0A"),
        ("a3be8c", "base0B"),
        ("8fbcbb", "base0C"),
        ("88c0d0", "base0D"),
        ("5e81ac", "base0D"),
        ("b48ead", "base0E"),
    ],
}

LABELS = {
    "catppuccin-floyd": "Catppuccin Floyd",
    "catppuccin-stripes": "Catppuccin Stripes",
    "catppuccin-waves": "Catppuccin Waves",
    "gruvbox-abstract": "Gruvbox Abstract",
    "gruvbox-pacman": "Gruvbox Pacman",
    "gruvbox-stripes-logo": "Gruvbox Stripes Logo",
    "nord-city": "Nord City",
}


def parse(hex_color):
    return np.array([int(hex_color[i : i + 2], 16) for i in (0, 2, 4)], dtype=np.float64)


def nearest(pixels, palette):
    result = np.empty(len(pixels), dtype=np.int64)
    chunk = 200_000
    for start in range(0, len(pixels), chunk):
        block = pixels[start : start + chunk]
        distances = ((block[:, None, :] - palette[None, :, :]) ** 2).sum(axis=2)
        result[start : start + chunk] = distances.argmin(axis=1)
    return result


def normalize(name, palette):
    source = WALLPAPERS / f"{name}.png"
    if not source.exists() and name == "nord-city":
        source = WALLPAPERS / f"{name}.jpeg"
    image = np.asarray(Image.open(source).convert("RGB"), dtype=np.float64)
    colors = np.array([parse(color) for color, _ in palette], dtype=np.float64)
    indices = nearest(image.reshape(-1, 3), colors)
    output = colors[indices].round().astype(np.uint8).reshape(image.shape)
    target = WALLPAPERS / f"{name}.png"
    Image.fromarray(output, "RGB").save(target, optimize=True)
    used = sorted(set(int(index) for index in indices))
    return [palette[index] for index in used]


def nix_fills(entries):
    lines = []
    for color, slot in entries:
        lines.append(f'      {{ color = "{color}"; slot = "{slot}"; }}')
    return "\n".join(lines)


def main():
    for name, palette in PALETTES.items():
        entries = normalize(name, palette)
        print(f"# {LABELS[name]}")
        print(f"    {name} = {{")
        print(f'      label = "{LABELS[name]}";')
        print(f"      file = ./wallpapers/{name}.png;")
        print("      fills = [")
        print(nix_fills(entries))
        print("      ];")
        print("    };")


if __name__ == "__main__":
    main()
