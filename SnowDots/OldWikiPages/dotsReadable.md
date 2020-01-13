The dotsReadable superclass provides a uniform way to read data, such as data from a gamepad or eyetracker.  It imposes a format for data and provides utilities for previewing data and for defining, detecting and enqueing events of interest.

### Implementation
dotsReadable itself is not a usable class.  Rather, it provides a uniform interface and core functionality for subclasses.  Subclasses must redefine the following methods in order to read actual data:

```
- openDevice()
- closeDevice()
- openComponents()
- closeComponents()
- readNewData()
```

These methods are invoked internally.  They encapsulate the details of how to read from any particular device.  See the documentation for each of these methods for more information about how subclasses should redefine them.

### Usage
Users should expect to call public methods like `initialize()`, `preview()`, and `read()`, which are the same for all subclasses.

dotsReadable() assumes that each input source or device has one or more components.  Each component must be assigned a small, positive, unique, integer ID.  This ID is used in many methods and properties to identify the component.  A component might be an individual button on a game pad, or a data channel from an eye tracker.

For most properties and methods, data are formatted as matrix rows. Each row represents one measurement.  Each row has three columns: `[ID, value, time]`.  The ID is the ID of a device component.  The value is any observed value.  The time is a timestamp associated with the value.

Several properties use component ID as indexes.  For example, the state property has one row for each component.  If for some reason component IDs are non-sequential, the state property may have gaps between useful rows.  This is expected.  Using IDs as indices takes advantage of Matlab's array facility to provide quick, concise assignment and lookup of data.

dotsReadable provides utilities for defining, detecting, and enqueueing events of interest.  Each component may define one event of interest at a time.  An event can be defined for one of four possibilities:

* the value of a component is less than some value
* the value of a component is greater than some value
* the value of a component is between two values
* the value of a component is not between two values

Once defined, events are detected automatically during read() and can be read out sequentially from getNextEvent().  Event dectection relies heavily on the dotsReadable data format and ID indexes.

### [Source Code](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadable.m)

## Subclasses

* [dotsReadableEye](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableEye.m)
* [dotsReadableEyeASL](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableEyeASL.m)
* [dotsReadableEyeEyelink](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableEyeEyelink.m)
* [dotsReadableHID](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableHID.m)
* [dotsReadableHIDGamepad](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableHIDGamepad.m)
* [dotsReadableHIDKeyboard](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableHIDKeyboard.m)
* [dotsReadableHIDMouse](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableHIDMouse.m)

## Demos

* [Keyboard Demo](https://github.com/TheGoldLab/Lab-Matlab-Control/wiki/Keyboard-Type-Test-demo)