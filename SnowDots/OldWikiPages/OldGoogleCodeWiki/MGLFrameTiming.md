Overview

Snow Dots might migrate from Psychtoolbox to MGL, for OpenGL support. MGLMigration discusses motivations and considerations.

The two libraries handle timing in different ways. So before migrating to MGL, we want to make sure we understand how to get good graphics timing with MGL.

This page discusses our understanding of frame timing with the two libraries and some frame timing tests we ran. The tests had this flavor: * draw some giant gray rectangles which fill the screen * record from the screen with a photometer * compare timing and gray values as viewed through software vs. through the photometer

We tested with a Mac Mini and a CRT display. The test results for these are generally good. We expect MGL to work out fine from a timing point of view. Read on for details.

Background

Timing in Psychtoolbox vs. MGL
Psychtoolbox and MGL handle graphics timing very differently: * Psychtoolbox aggressively pursues frame times by going outside the scope of OpenGL and by defining fall-back behaviors to accommodate weak hardware. * MGL doesn't. It leaves frame timing details up to the OpenGL implementation of its host operating system.

We think that in most cases, with at least middling graphics hardware, the hands-off approach of MGL is sufficient. This section explains why.

Beam Position
Psychtoolbox does a great job of synchronizing Matlab's execution (i.e. drawing) with the video refresh cycle. A key synchronizing tool is beam position querying. In short, some video drivers expose a "beam position" signal which corresponds to the progress the scanning electron beam in a CRT display. This signal gives Psychtoolbox a direct measurement of how far along each video frame has progressed.

Beam position is a very useful signal! But beam position querying is not part of OpenGL and it's not uniformly supported across operating systems and video drivers.

Moreover, "beam position" is only a well-defined concept for CRT displays, which have a scanning electron beam. CRTs themselves are increasingly difficult to find. Some LCD display drivers mimic a "beam position" signal (do they all mimic it in the same way?). Some drivers don't bother.

Thus, we can't always expect to enjoy beam position querying, especially looking ahead to a display market dominated by LCDs.

Swap-Interval
Nevertheless, MGL can synchronize Matlab's execution with the video refresh cycle.

The big three OpenGL implementations (for OS X, Windows, and Linux) provide a mechanism called "swap-interval" for synchronizing graphics onset with a hardware video refresh. For CRT displays, the refresh moment would correspond to the "vertical blank" phase of electron beam scanning.

Swap-interval behavior is defined with respect to the video frame buffers, not the display or display driver, so we do expect to have swap-interval behavior across operating systems and display types.

MGL turns swap-interval "on" by default. This provides two kinds of synchronization. First, it causes the graphics processor to delay processing of "flush" commands (i.e. commands that define a completely drawn frame) until the next hardware video refresh.

Second, it causes Matlab (or any calling application) to block whenever Matlab attempts to put more than one "flush" command into the OpenGL command queue. The block ends when the next hardware video refresh occurs. The intuition here is similar to saying, "You want me to process this frame? OK. You want me to process another frame?? Wait until I'm done processing that first one."

The second type of synchronization allows MGL to synchronize Matlab's execution with the video refresh cycle.

Note: we observe this "wait until I'm done" synchronization with the OS X implementation of OpenGL. Do applications see the same blocking behavior on Windows and Linux? Please comment below if you know.

Note: the words "swap" and "flush" mean almost the same thing. "Swap" refers to swapping the front and back frame buffers in a double-buffered context, in order to display a new frame. "Flush" refers to processing all queued drawing commands, also in order to display a new frame. The two operations usually occur back-to-back. The distinction is not important here, since we're just concerned with displaying new frames.

MGLFlushGauge
We wrote a class called MGLFLushGauge which encapsulates our understanding of swap-interval behavior. It uses "wait until I'm done" synchronization in order to measure the hardware refresh rate, and to take timestamps for individual hardware refreshes.

It has a flush() method which places a "flush" command in the OpenGL command queue, and returns an onset prediction time for the corresponding frame.

The time is a prediction because of how swap-interval behavior interacts with the OpenGL command queue. Consider this sequence of events: * Call flush(), placing flush 1 in the command queue. Returns immediately. * Call flush(), placing flush 2 in the command queue. Matlab is now blocked. * flush 1 gets processed during the next hardware refresh. Matlab unblocks. * Matlab records a timestamp

The timestamp is taken just as frame 1 appears onscreen. We expect onset for frame 2 to occur one frame later. So the onset prediction for frame 2 would be timestamp-plus-one-frame. This is a time in the future.

If we called flush() again, the same logic would apply. Matlab would be forced to block until frame 2 was processed, and we would expect frame 3 to appear one frame later, in the future.

If we use swap-interval as the mechanism for frame timing, we must do this kind of overlapping accounting, where our expectation for the current frame depends on what we know about the previous frame.

MGLFlushGauge encapsulates these accounting details. Since the accounting relies on state memory and assumptions about the underlying OpenGL implementation, it's worth testing it for correctness.

Tests

We compared frame onset predictions made by MGLFlushGauge with on-screen photometer readings of the same frames. This section describes the test structure and measurements.

See Running the Tests below to obtain all the code needed for running these tests.

Trials and Timestamps
Each test contained a sequence of trials. Each trial waited for an arbitrary delay period, drew a large, gray rectangle to the screen, and recorded several software timestamps. All trials had the same structure and differed only in the delay duration the gray value.

One trial corresponds to one drawn frame. However, because of the arbitrary delay period, one trial may correspond to multiple video refresh cycles. In other words, some trials contained frame skips.

Here is pseudo-code for one complete test: Choose the number of trials, N Choose N duration values, DELAYS Choose N gray values, COLORS For each trial 1 through N Record a START timestamp Wait for the next duration in DELAYS Record a DELAY timestamp Draw the next gray value in COLORS Record a DRAW timestamp Call the flush() method of MGLFlushGauge returns an ONSET time prediction returns a hardware refresh timestamp, SWAP Record a FINISH timestamp End

Photometer Readings
In addition to software timestamps, each test recorded voltage samples from a photometer which was attached to the computer display. We used two devices to record photo-sensitive voltages: * a PIN 10D photodiode from OSI Optoelectronics * a USB 1208FS digital-analog converter from Measurement Computing

We connected leads from the photodiode to one of the analog input differential channels of the 1208FS. We scanned the input at 5000Hz for the duration of each test.

We communicated with the 1208FS device using the mexHID() Mex-function which is part of Snow Dots. We also wrote a new class called AInScan1208FS for doing device-specific input, output, and data handling with the 1208FS.

Reconciling Views of Color and Onset Time
On each trial, we were interested in frame color and frame onset time. We had two independent views of each quantity: | View | Color | Onset Time | |:---------|:----------|:---------------| | Software |specified gray value|prediction from MGLFlushGauge()| | Photometer |voltage peak value|voltage peak time|

We reconciled the two views of frame color by sorting. We assumed that the specified gray values would be transformed monotonically into photometer voltage peak values. Since the gray values were well-spaced and the peak voltage values turned out to be well-separated, it was straightforward to map "lightest gray" to "highest voltage peak", "median gray" to "median voltage peak", and so on. Note that the color reconciliation does not use any timing information.

We reconciled views of frame onset time by sequence. We assumed that the photometer voltage peak must occur a short time after the video hardware refresh, since the voltage change is "downstream" of the video card. So we matched each time prediction from MGLFlushGauge with the earliest subsequent photometer voltage peak.

We considered a trial to be a success if the reconciled gray colors matched, and if the reconciled onset times were between 0 and 1 frames apart.

Earliness
We define a concept called "earliness" as the interval between when flush() was called, and when MGLFlushGauge predicted frame onset. Roughly, the earliness is the amount of time remaining in a frame for drawing commands to propagate through the OpenGL pipeline. If the earliness is too small, frame skips will occur.

In some cases, earliness is greater than the length of one frame, indicating that we have issued drawing commands well ahead of time, and we should expect good graphics timing.

Where earliness is only a few milliseconds, we should be uncertain whether the predicted onset time is accurate. This is because we don't know exactly how long it takes drawing commands to propagate through the OpenGL rendering pipeline.

Results

We ran three tests, each with a different emphasis. One was "easy" and had only short delays, one had "progressively" long delays in it, and one was a "fuzz" test with randomly chosen delays.

Results from each of three tests appear in figures below. The figures all have the same format, as follows.

Reading the Figures
Each figure has three panels. Each panel shows a timeline of the entire test. The horizontal axis is the common to all panels and shows a count of elapsed video frames, as measured by MGLFlushGauge.

The top panel is entirely a software view. The vertical axis shows individual trials as rows. Trial 1 is in the bottom row, trial 25 is in the top row.

The trial bars overlap because of how swap-interval interacts with the OpenGL command queue (see Swap-Interval above). We're able to start drawing a new trial even before the frame from the previous trial appears on screen.

The trial bars are color-coded: * the rightward arrow indicates the trial START time and the gray color to be drawn * the green bar segment indicates the trial DELAY time * the red bar segment indicates the trial DRAW time (very short) * the light blue bar segment indicates the trial SWAP time (including "wait until I'm done" blocking) * the dotted blue bar segment extends to the frame ONSET time prediction from MGLFlushGauge * the leftward arrow indicates the ONSET time prediction and the gray color to be drawn (always matches the rightward arrow)

The middle panel is a photometer view of the test. The vertical axis shows photometer voltage.

Orange points show individual voltage samples taken throughout. Upward arrows mark peaks in the voltage trace. The arrows colors indicate reconciled gray values.

Tick marks on the vertical axis correspond to "highest", "median", and "lowest" voltage peaks. These were used for reconciling the software and photometer views of frame color.

The bottom panel compares the software and photometer views for trial success. The vertical axis shows the "earliness" of each trial.

The leftward arrows indicate software ONSET time predictions. They always match the leftward arrows from the top panel. Upward arrows mark voltage peaks from the photometer view of the trial. They always match the upward arrows from the middle panel.

Horizontal bars represent the success or failure of MGLFlushGauge on each trial. For success trials, the horizontal bar has the same color as the frame on that trial. For failure trials, the horizontal bar is red.

We consider a trial a success if the software view agrees with the photometer view, for frame color and frame onset time. Otherwise we consider a trial a failure.

Easy Test
http://snow-dots.googlecode.com/files/MGLEasyTest.fig

http://snow-dots.googlecode.com/files/MGLEasyTest.png'> http://snow-dots.googlecode.com/files/MGLEasyTest.png' width='240' height='320' />

The "easy" test assessed the basic behavior of MGLFlushGauge: * N was 25 trials * DELAYS were small and constant (3ms) across trials * COLORS repeated a three-unit pattern of medium-gray, light-gray, dark-gray throughout

These easy conditions might correspond to an experiment with primitive animation and minimal processing required between frames. We expected no frame skipping, and there was none (the 25th trial had onset on the 25th frame). We also expected MGLFlushGauge to be successful on all 25 trials, and it was.

The earliness of the first two trials was relatively short because Matlab was not yet synchronized with the video refresh cycle. On all other trials, earliness was longer than a whole frame.

Progressive Test
http://snow-dots.googlecode.com/files/MGLProgressiveTest.fig

http://snow-dots.googlecode.com/files/MGLProgressiveTest.png'> http://snow-dots.googlecode.com/files/MGLProgressiveTest.png' width='240' height='320' />

The "progressive" test disrupted frame timing with delays of increasing length: * N was 25 trials * DELAYS increased steadily from about half a frame to one-and-a-half frames * COLORS repeated a three-unit pattern of medium-gray, light-gray, dark-gray throughout

Because of the long delays, this test guaranteed that some frames would be skipped. We wanted to know whether MGLFlushGauge would track the skips and report on bad timing as well as it had reported on good timing. It did, and all trials were successful.

Skipped frames show up as repeated peaks in the middle panel. Following these trials, MGLFLushGauge reported that the next frame onset would be late.

The progressive delays caused earliness to suffer. In early trials, when Matlab is synchronized with the video refresh cycle, earliness decreases as delay increases. Frame skips start after frame 17, Matlab becomes un-synchronized, and earliness becomes erratic.

Fuzz Test
http://snow-dots.googlecode.com/files/MGLFuzzTest.fig

http://snow-dots.googlecode.com/files/MGLFuzzTest.png'> http://snow-dots.googlecode.com/files/MGLFuzzTest.png' width='240' height='320' />

The "fuzz" test disrupted frame timing with randomly chosen delays: * N was 25 trials * DELAYS picked from uniform distribution ranging from zero through two frames * COLORS repeated a three-unit pattern of medium-gray, light-gray, dark-gray throughout

We intended this test to push MGLFlushGauge beyond conditions usually encountered in psychophysics. Since delay could be very long or very short, it should have been difficult for MGLFlushGauge to settle into a predictable pattern, and success would depend on our correct modeling of swap-interval behavior. MGLFlushGauge performed well overall, but failed on 2 of the trials.

The first failure occurred at frame 2. In this trial, the photometer view of frame onset was one frame later than the software view. The earliness is about 3ms. Our interpretation is that it took longer than 3ms for the drawing commands to propagate through the OpenGL pipeline, but MGLFlushGauge didn't "know" it would take so long.

The second failure occurred at trial 29. It's a skipped frame with a similar interpretation. The photometer view of frame color lags one frame behind the specified frame color. The earliness is about 2ms. As before, it must have taken longer than 2ms for the drawing commands to propagate through the OpenGL pipeline, and MGLFLushGauge didn't "expect" it to take so long.

To address both failures it would seem useful to "tell" MGLFlushgauge that it takes at least 3ms for drawing commands to propagate through the OpenGL pipeline. We can do this. MGLFlushGauge already implements a mechanism called "framePadding" which allows it to detect when the earliness is too small. For these tests framePadding was 1ms, and we can increase the value to 3ms to match these results.

However, it's unlikely that a single value of framePadding will be suitable in all cases. Note that at frames 6 and 13, the earliness was close to 3ms but the trials were successful. There may be inherent unpredictability in how long it takes drawing commands to propagate.

Furthermore, drawing command propagation times must depend on the OpenGL implementation, both hardware and software. It may be necessary to choose a "best" value for each system based on similar tests, and to accept that when earliness is close to this value, MGLFlushGauge might predict onset times that are off by one frame.

Fortunately, these tests demonstrate that when earliness is large, as might be expected during psychophysics, MGLFlushGauge predicts accurate frame onset times.

Payoff

Under these test conditions, with the graphics hardware of our Mac Mini, we think the swap-interval timing is good and that MGLFlushGauge works well. Thus, we don't need to use beam position querying, and that has a few advantages.

Display Type Independence
We're not tied to display and drivers that report a beam position signal. We can continue to get frame timing information as CRTs are phased out and we're forced to explore other display types.

One huge caveat is that swap-interval behavior stops at frame buffer, so we must check our assumptions about what a display does with frame data once it gets it.

For example, the phenomenon of display lag is known but somewhat mysterious. Hopefully researchers, gamers, and enthusiasts, or display manufacturers themselves, will illuminate display lag and other display timing details.

Robustness Against Jitter
Swap-interval also allows us to send an "extra frame" at a time to the OpenGL command queue. This gives us robustness against timing jitter from sources like non-real time operating systems. If our animation is "late" on one frame, we may be able to make up for lost time during the next frame and avoid frame skips.

The key difference is blocking behavior: Psychtoolbox usually has us block on beam position, until the current frame appears on the display. Swap-interval has us block on hardware refresh until the previous frame is sent sent to the display.

Note: Psychtoolbox allows asynchronous buffer swapping which might allow for swap-interval behavior.

Development Potential
The greatest payoff should come from future development. These frame timing tests indicate that MGL will be a sufficient replacement for Psychtoolbox, from a graphics timing point of view. Thus, we will be able to take advantage of MGL's ease-of-extensibility when we do OpenGL development.

Running the Tests

These tests require the mexHID() function which is part of Snow Dots. One way to get mexHID() is to install Snow Dots.

Installing Snow Dots is a combination of "checking out" code with Subversion and downloading other dependencies by hand. This script can help: installSnowDots_30April2010.m

These tests also require some code which is not part of Snow Dots, which you can find in the Snow Dots download section: MGLFrameTimingTests.zip

Moreover, the tests require some hardware: * a PIN 10D photodiode from OSI Optoelectronics * a USB 1208FS digital-analog converter from Measurement Computing

The test setup is simple in principle: * plug in the 1208FS USB device * connect two leads between the 1208FS and the photodiode * attach the photodiode to the display of the test computer

But complications are bound to arise. If you want to run these tests and you're having trouble setting things up, please leave a comment and one of the developers will get an email.