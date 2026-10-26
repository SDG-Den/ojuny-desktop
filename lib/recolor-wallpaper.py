import os
import sys

import numpy as np
from PIL import Image


def parse(value):
    value = value.lstrip("#")
    return tuple(int(value[i : i + 2], 16) for i in (0, 2, 4))


fills = np.array(
    [parse(color) for color in os.environ["SOURCE_FILLS"].split()], dtype=np.float64
)
targets = np.array(
    [parse(color) for color in os.environ["TARGET_FILLS"].split()], dtype=np.float64
)
if len(fills) != len(targets):
    raise SystemExit("SOURCE_FILLS and TARGET_FILLS must have equal length")

image = np.asarray(Image.open(sys.argv[1]).convert("RGB"), dtype=np.uint8)
flat = image.reshape(-1, 3).astype(np.uint32)
keys = (flat[:, 0] << 16) | (flat[:, 1] << 8) | flat[:, 2]
unique, inverse = np.unique(keys, return_inverse=True)
unique_rgb = np.stack(
    [(unique >> 16) & 255, (unique >> 8) & 255, unique & 255], axis=1
).astype(np.float64)

out_colors = np.empty((len(unique), 3), dtype=np.uint8)
worst = 0.0
worst_color = None
for index, color in enumerate(unique_rgb):
    exact = np.where(np.all(fills == color, axis=1))[0]
    if len(exact):
        out_colors[index] = np.round(targets[exact[0]]).astype(np.uint8)
        continue

    best = None
    for first in range(len(fills)):
        for second in range(first + 1, len(fills)):
            start = fills[first]
            direction = fills[second] - start
            amount = np.clip(
                ((color - start) @ direction) / (direction @ direction), 0.0, 1.0
            )
            distance = float(np.sum((color - (start + amount * direction)) ** 2))
            if best is None or distance < best[0]:
                best = (distance, first, second, amount)

    distance, first, second, amount = best
    if distance > worst:
        worst = distance
        worst_color = color
    out_colors[index] = np.round(
        (1.0 - amount) * targets[first] + amount * targets[second]
    ).astype(np.uint8)

worst_distance = worst**0.5
if worst_color is None:
    print(
        "unique colors: %d, all colors matched exactly" % len(unique),
        file=sys.stderr,
    )
else:
    print(
        "unique colors: %d, worst reconstruction distance: %.2f at #%02x%02x%02x"
        % (
            len(unique),
            worst_distance,
            int(worst_color[0]),
            int(worst_color[1]),
            int(worst_color[2]),
        ),
        file=sys.stderr,
    )

Image.fromarray(out_colors[inverse].reshape(image.shape)).save(sys.argv[2])
