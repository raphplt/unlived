#!/usr/bin/env python3
"""Original, deterministic placeholder sound design. Python standard library only."""
import array
import math
from pathlib import Path
import random
import wave

ROOT = Path(__file__).resolve().parents[1] / "game/assets/audio"
RATE = 22050


def save(name, samples):
    with wave.open(str(ROOT / (name + ".wav")), "wb") as output:
        output.setparams((1, 2, RATE, 0, "NONE", "not compressed"))
        output.writeframes(array.array("h", (int(max(-1, min(1, s)) * 32767) for s in samples)).tobytes())


def piano(freq, duration=3):
    for i in range(int(RATE * duration)):
        t = i / RATE
        attack = min(1, t / .008)
        value = sum(math.sin(2 * math.pi * freq * partial * t) * weight * math.exp(-t * decay)
                    for partial, weight, decay in [(1, .48, 1.7), (2.002, .19, 2.6), (3.004, .09, 3.8), (4.009, .035, 5)])
        yield value * attack * min(1, (duration - t) / .2)


def main():
    ROOT.mkdir(parents=True, exist_ok=True)
    for index, frequency in enumerate([261.626, 293.665, 329.628, 349.228, 391.995, 440, 493.883]):
        save("note_" + str(index), piano(frequency))
    rng = random.Random(418)
    # Filtered noise, with a periodic envelope to avoid loop-edge clicks.
    smooth = 0
    rain = []
    for i in range(RATE * 12):
        noise = rng.uniform(-1, 1)
        smooth = smooth * .91 + noise * .09
        t = i / RATE
        envelope = min(1, t / .08, (12 - t) / .08)
        rain.append((smooth * .5 + noise * .035) * envelope * (.85 + .15 * math.sin(t * math.tau / 12)))
    save("rain", rain)
    save("room", [(math.sin(i / RATE * math.tau * 65.5) * .017 + math.sin(i / RATE * math.tau * 98.25) * .009) *
                  min(1, i / RATE / .3, (8 - i / RATE) / .3) for i in range(RATE * 8)])
    save("step", [rng.uniform(-1, 1) * .14 * math.exp(-i / RATE * 34) * min(1, i / RATE / .006)
                  for i in range(int(RATE * .17))])
    print("Generated 10 original WAV assets.")


if __name__ == "__main__":
    main()
