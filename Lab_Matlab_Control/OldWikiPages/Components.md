Here is a summary Snow Dots components.

Some components are integrated with Snow Dots, so you need to install the whole project to use them.

Others components are separable, so you can download them and use them in isolation, if you want.

http://snow-dots.googlecode.com/svn/wiki/diagrams/components.png

Integrated

These components are integral to Snow Dots and would be hard to use without installing the whole project.

**Multiple Matlab Instances**

Snow Dots can span multiple Matlab instances, using a client-server model. Client and server can run on the same machine, or different machines. The client is the primary Matlab instance and initiates all behaviors. There can be one or more server instances, which wait for requests from the client and carry out out behaviors.

Client-server behaviors are based on ensembles, which group together related objects and call methods and functions. See the classes dotsClientEnsemble and dotsEnsembleServer.

Client-server communicate via Ethernet and the UDP protocol. The class dotsTheMessenger handles communication details.

**Drawables**

The dotsDrawable superclass defines a uniform interface for objects that draw graphics. Several subclasses implement the interface to draw things like lines or images. Users can also create custom drawable subclasses.

Drawables all use OpenGL. Thanks to the MGL project for OpenGL support.

dotsTheScreen manages the OpenGL drawing window and swapping of frame buffers.

**Playables**

The dotsPlayable superclass defines a uniform interface for objects that play sounds. Two subclasses implement the interface to play tones or .wav or .mp3 files. Users can also create custom playable subclasses.

As of Version 1, playable classes use Matlab's built-in audioplayer functionality, which is limited. But there are better sound back-ends, such as those in MGL or Psychtoolbox. Snow Dots should adopt one...

**Readables**

The dotsReadable superclass defines a uniform interface for objects that read data. Several subclasses implement the interface to read from things like keyboards and other USB/HID devices, or eye trackers. Users can also create custom readable subclasses.

Readables usually rely on Mex functions to provide raw data. As of Version 1, most readables have Mex function support only in OS X.

**Machine Configuration**

Snow Dots can save machine-specific configuration, such as IP addresses, port numbers, file paths, and MGL display indexes. It uses Matlab's built-in functionality for working with .xml files. It stores values as Matlab expressions, so the .xml files are human-readable and human-editable.

dotsTheMachineConfiguration provides a front-end for viewing, editing, and querying configuration data within Matlab. It can also apply default property values to objects, based on their class.

**Demos**

Snow Dots has example code in the demos/ folder. Many demos are short and simple, showing how to do things like draw graphics or send digital outputs.

Examples in the demos/tasks/ folder are more complicated and span multiple files. They combine Snow Dots components into functional games or tasks.

The demos/particleSystem folder contains an example using OpenGL shader programs and transform feedback. It shows how hardware-accelerated graphics can make a big difference in animation!

Separable

These components can work on their own, and might be useful even if you don't want to use the rest of Snow Dots.

**Tower of Psych**

Snow Dots inherits a lot of style and functionality from its companion project, Tower of Psych.

In particular, it uses object-oriented design, topsRunnable objects for controlling flow of events and automatic data logging, graphical interfaces for many components, and a spatial model for classifying data.

The Snow Dots documentation is cross-linked with the Tower of Psych documentation.

**dotsMgl Mex Functions**

Snow Dots has several C-language Mex functions that extend the OpenGL capabilities of MGL. These include support for vertex buffer objects, shader programs, and transform feedback.

These Mex-functions might be useful, even without the rest of Snow Dots. You can check them out here: svn checkout http://snow-dots.googlecode.com/svn/trunk/mex/dotsMgl dots-mgl-extensions

Note: dotsMgl transform feedback depends on the OpenGL 2.0 extension named "EXT_transform_feedback".

**mexHID() Mex Function**

Snow Dots provides a C-language Mex function for working with Human Interface Devices (HIDs). HIDs include USB devices like keyboards, mouses, and joysticks. They also include unusual devices, like digital-analog-converters and the Nintendo Wii remote!

In addition to the mexHID() Mex function, Snow Dots provides some HID utilities: * mexHIDScout() scans the system for connected HID devices and displays a table summarizing their properties. It can also plot data coming from each device. * mexHIDUsage is a class that helps identify HID devices and device components. It allows you to look up sensible names for obscure numeric constants, and vice versa. For example, the number 4 often means "Joystick", and 44 means "KeyboardSpacebar". mexHIDUsage.gui() displays a table summarizing all constants and names.

mexHID() might be useful, even without the rest of Snow Dots. You can check it out here: svn checkout http://snow-dots.googlecode.com/svn/trunk/mex/mexHID mex-hid

Note: as of Version 1, mexHID() is only implemented for OS X, 10.5 or later. But the Mex function interface is written separately from the internal functionality. So it should be possible to implement mexHID() for other platforms as well.

**mexUDP() Mex Function**

Snow Dots provides a C-language Mex function for working with network sockets. These are based on the IP and UDP protocols, so they're good for sending short messages without a lot of overhead.

mexUDP() might be useful on its own. You can check it out here: svn checkout http://snow-dots.googlecode.com/svn/trunk/mex/mexUDP mex-udp

Note: mexUDP() is based on Berkeley Sockets, so it's is easy to build it on platforms like OS X and Linux. It should be possible to build mexUDP() on Windows, but it would take a little work.

Also note: Snow Dots can use the pnet() function as an alternative to mexUDP(). pnet() is part of the free TCP UDP IP Toolbox. mexUDP() is faster, pnet() more portable.

**mxGram() Mex Function**

Snow Dots provides a C-language Mex function for serializing data. It can convert a Matlab variable to a formatted sequence of bytes, and it can convert a formatted sequence of bytes into a Matlab variable. This allows data to be sent from one Matlab instance to another, via Ethernet.

mxGram() supports several basic Matlab data types: * double 2D matrices * char 2D matrices * logical 2D matrices * cell 2D matrices * struct 1D arrays * function_handle scalars Cell matrices and struct arrays may be nested arbitrarily.

mxGram() does not support objects. It also does not support very large variables, since serialized data are intended to be send in a single UDP datagram.

mxGram() might be useful on its own. You can check it out here: svn checkout http://snow-dots.googlecode.com/svn/trunk/mex/mxGram mx-gram

Note: mxGram() assumes that sender and receive encode double values in the same standard 8-byte format. This seems to be true for OS X, Windows, and Linux.

**Digital Outputs**

The dotsAllDOutObjects superclass defines a uniform interface for objects that send digital outputs. The dotsDOut1208FS subclass implements the interface using using the 1208FS device from Measurement Computing.

The dotsAllDOutObjects interface could be re-implemented, using different devices. This would allow the same Snow Dots code to use whatever device was available.

The digital output code might be useful on its own. You can check it out here: svn checkout http://snow-dots.googlecode.com/svn/trunk/classes/dOut digital-outputs

You'll also need mexHID() to communicate with the 1208FS device: svn checkout http://snow-dots.googlecode.com/svn/trunk/mex/mexHID mex-hid

**Analog Inputs**

The AInScan1208FS class is a utility for doing analog input scanning with the 1208FS device from Measurement Computing. The class handles a lot of low-level bookkeeping and data formatting details, and should make it easier to work with the 1208FS device.

AInScan1208FS might be useful on its own. You can check it out here: svn checkout http://snow-dots.googlecode.com/svn/trunk/utilities/measurementComputing/ analog-inputs

You'll also need mexHID() to communicate with the 1208FS device: svn checkout http://snow-dots.googlecode.com/svn/trunk/mex/mexHID mex-hid

**Miscellaneous**

Snow Dots has several utilities for miscellaneous tasks. These include things like measuring the drift between digital clocks, predicting video frame onset times, computing vertex locations for disks and polygons, converting variables to Matlab expressions, and installing Snow Dots itself.

Some of these might be useful without the rest of Snow Dots. You can check them out here: svn checkout http://snow-dots.googlecode.com/svn/trunk/utilities