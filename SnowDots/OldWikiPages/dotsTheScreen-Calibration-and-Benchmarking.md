* **Gamma correction** is done via dotsTheScreen. See the comments for dotsTheScreen.makeGammaTable for more details.
Some references about what this is and why it is important: [[Cambridge website](https://www.cambridgeincolour.com/tutorials/gamma-correction.htm)] [[Brainard paper](https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwjhyK6e3uTYAhXDk-AKHRnWASoQFggpMAA&url=https%3A%2F%2Fpsych.nyu.edu%2Fpelli%2Fpubs%2Fbrainard2002display.pdf&usg=AOvVaw2F35jnQiq6wx-7C16NzgLH)]

* snow-dots/utilities/benchmarks/**benchmarkMonitorLuminance**: Measure the luminance of a spot on your monitor using the optiCAL device.
* snow-dots/utilities/benchmarks/**benchmarkMonitorTiming**: measure monitor timing using a photodiode.
* snow-dots/utilities/benchmarks/**benchmarkGraphicsTiming**: measure how much graphics processing the machine can do without skipping frames.