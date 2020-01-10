**Motivation**

In May 2011 the developers Josh Gold and Ben Heasly started talking about how to get "fancier" graphics with Snow Dots.

We started by noticing that some of our stimulus implementations don't scale well. For example, for animated dots we calculate dot positions in m-code and then draw the dots in a circular aperture with Psychtoolbox Screen "DrawDots" and "DrawTexture". When we increase the number of dots past 10,000, we get unsatisfactory performance. The bottleneck may well be in our m-code.

We considered video games as indicators of what we might expect if we were to reimplement stimuli the "right" way. Modern video games get very fancy, at high frame rates, by taking advantage of the processing power and memory in modern graphics hardware. If we do likewise, lots of dots and other complex stimuli should not be a problem.

So we'd like to raise the complexity ceiling much higher by using advanced OpenGL features like shaders, which allow us to execute code on the graphics processor, and buffered objects, which reside in graphics memory.

These OpenGL features are accessible through Psychtoolbox. However, if we're going to move beyond simple drawing commands and start doing OpenGL development, it's not clear that Psychtoolbox provides the best interface.

We learned about MGL, an alternative OpenGL interface, from David Brainard and Chris Broussard. From a development point of view, MGL is attractive. It's smaller than Psychtoolbox. It's organized around multiple small mex functions, which are relatively easy to read and understand. It's easy to extend MGL by "dropping in" new mex functions. Most of all, it's easy to rebuild MGL from within Matlab.

We think its worth using MGL, as a path of less resistance for OpenGL development. But migrating from Psychtoolbox to MGL would have consequences besides ease of development. This page discusses some of them.

**Progress**

As of 14 July 2011, we're still testing things out with MGL.

As of July 29 2011, we have some test results at MGLFrameTiming which compare software frame timing estimates with on-screen light measurements.

As of 5 August 2011, we've started an "MGL" branch of Snow Dots which will substitute MGL for Psychtoolbox for all drawing and frame timing.

**Considerations**

Timing
Frame timing is the biggest concern, and the biggest change from Psychtoolbox. Psychtoolbox uses "beam position" queries as one means of synchronizing Matlab with the video refresh cycle. This is nice because beam position its a direct measurement of refresh cycle phase. But these queries are not part of OpenGL itself and not always available, so we don't expect to rely on them with MGL.

But we can still get frame timing information with MGL. The big three OpenGL implementations (for OS X, Windows, and Linux) are able to defer buffer swapping until the "vertical blank" phase of the refresh cycle. They can also block the calling application while waiting for the vertical blank. Thus, we can synchronize Matlab's execution with the vertical blank and also take timestamps when the vertical blanks happen.

We developed an MGLFlushGauge class which keeps track of vertical blank timestamps. It uses these to measure the refresh cycle rate, count elapsed frames, and predict future frame onset times. It also attempts to detect things like missed drawing deadlines.

MGLFlushGauge relies on a model for how the OpenGL implementation behaves with respect to frame timing. It's also naive compared to Psychtoolbox Screen in terms of timing information. But this is not necessarily fatal.

We have some test results at MGLFrameTiming which evaluate MGLFlushGauge for correctness of its timing model. We think it worked well on a Mac Mini with OS X 10.6. It remains to be seen on what other systems MGLFlushGauge works well.

**Screen()**
The Screen() mex function handles most of the drawing, frame timing, and context management of Psychtoolbox. MGL uses a suite of mex functions for drawing and timing, and stores context data in a global Matlab struct.

Some steps in the migration would be one-to-one swaps which would be hidden by the Snow Dots API (i.e., users wouldn't care). Other steps involve higher-level project choices made by Psychtoolbox and MGL, and these might cause changes in the Snow Dots API.

I (Ben Heasly) reviewed Screen() usage in Snow Dots, as well as dotsTheScreen, dotsTheDrawablesManager, and the dotsDrawable family of classes. Here are some significant migration steps I can see ahead and how I expect them to affect the Snow Dots API. I'm leaving out easy one-to-one substitutions.

| Name | Migration Step | Snow Dots API? | |:---------|:-------------------|:-------------------| |pixels per degree|MGL uses the OpenGL modelview matrix instead of Matlab drawing code|remove pixelsPerDegree from dotsDrawable classes| |window number|MGL manages context globally, with one window per display|remove windowNumber from all classes| |"psych" comments|Make documentation agnostic about Psychtoolbox or MGL, as much as possible|-- | |priority |MGL does not treat CPU priority, so use another mechanism|-- | |stereo mode|MGL can switch displays but has no explicit stereo mode|remove stereoMode property of dotsTheScreen| |multisample|May need to add multi-sample pixel format for MGL|-- | |preferences|use mgl "params" instead of Psychtoolbox "preferences"|parameter names in XML config files| |text properties|let text classes manage properties like font, size and color|remove global text properties from dotsTheScreen and dotsTheDrawablesManager| |frame skips|let MGLFlushGauge deal with frame skip detection|remove related properties from dotsTheScreen| |window detection|check MGL global "GLContext"|remove isWindowOrTexture() from dotsTheScreen| |blending |may need new mex function to enable alpha blending in MGL|-- | |flip |use MGLFlushGauge in dotsTheScreen to handle frame flushing and timing|-- | |transparency|MGL makes it easy to open transparent windows|add transparency property to dotsTheScreen| |stencils |MGL makes it easy to work with OpenGL stencils--useful for some stimuli|-- | |arcs |MGL exposes gluPartialDisc(), which Psychtoolbox uses internally|-- |

**Cost**

Psychtoolbox does a lot more than just OpenGL. If we move away from Psychtoolbox, we would not longer get its other features as part of the package.

Whether or not this is a good thing depends on point of view. We're not sure that it makes sense to get all Psychophysics features from one giant source. For some users, this might make a lot of sense.

**Payoff**

The considerations and changes above are mostly about matching or replacing the Psychtoolbox features we're using now, with MGL instead.

We expect to see a benefit later, once we start doing OpenGL development. That would be a topic for another page and code demos.