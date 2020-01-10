"October2011" is the second formal milestone for the Snow Dots project. It corresponds to the repository tag called October2011: https://snow-dots.googlecode.com/svn/tags/October2011

Documentation contemporary with October2011 is also available.

October2011 will receive bug fixes, but new API and feature changes will go in the trunk, to be included in a later milestone.

There is a companion October2011 tag for the Tower of Psych project: https://tower-of-psych.googlecode.com/svn/tags/October2011 The Snow Dots and Tower of Psych "October2011" revisions are expected to work together.

Overview

October2011 represents a big change, because Snow Dots now uses MGL instead of Psychtoolbox for OpenGL and CPU timestamps.

We made the change because MGL is easier to extend and rebuild. This made it easier to access advanced OpenGL features and work in 64-bit environments. Psychtoolbox still has many great features which users still might want to use. Since Snow Dots wasn't using most of these features, it made sense to go with the smaller MGL.

There's more about MGL and Psychtoolbox at MGLMigration.

Changes

Most of the changes in October2011 relate to OpenGL. So I'll try to list all the API changes for dotsTheScreen, dotsTheDrawablesManager, and the dotsDrawable- subclasses.

There are other changes, too. I'll point these out separately.

OpenGL

General
MGL treats the OpenGL drawing window and the pixels-per-degree conversion globally. So the windowNumber and pixelsPerDegree properties have been removed from dotsDrawable- classes.

Since pixels-per-degree is handled globally, drawing properties related to size or distance should be assumed to be in degrees of visual angle, unless otherwise noted.

dotsTheScreen
Here are the API changes to dotsTheScreen: |old name|new name|why?| |:---------|:---------|:-----| |pixelSize |bitDepth |name consistent with MGL usage| |displayRect|-- |unused in MGL| |priority |-- |unused in MGL| |stereomode|-- |stereo handled differently in MGL| |preferences|-- |preferences handled differently in MGL| |textSettings|-- |now handled by individual dotsDrawable- instances| |allTextModes|-- |now handled by individual dotsDrawable- instances| |windowNumber|-- |unused in MGL| |frameTolerance|flushGauge|MGLFlushGauge instance to keep track of frame timing| |frameSize |flushGauge|MGLFlushGauge instance to keep track of frame timing|

MGLFlushGauge is a new class which encapsulates frame buffer swapping and frame timing.

dotsTheDrawablesManager
Here are the API changes to dotsTheDrawablesManager: |old name|new name|why?| |:---------|:---------|:-----| |textSettings|-- |now handled by individual dotsDrawable- instances| |windowNumber|getScreenDisplayNumber()|access the global MGL display index| |pixelsPerDegree|-- |treated globally in MGL| |setScreenTextSetting()|-- |now handled by individual dotsDrawable- instances| |-- |degreeSizeToPixels()|utility for pixel conversion| |-- |pixelSizeToDegrees()|utility for pixel conversion| |-- |degreePointToPixels()|utility for pixel conversion| |-- |pixelPointToDegrees()|utility for pixel conversion|

dotsDrawable- Subclasses
Here are API changes to the dotsDrawable subclasses: |subclass|old name|new name|why?| |:---------|:---------|:---------|:-----| |dotsDrawableArc(s)|dotsDrawableArc|dotsDrawableArcs|renamed to plural to express vectorization| |-- |rect |-- |no longer used| |-- |arcAngle |-- |no longer used| |-- |penWidth |-- |no longer used| |-- |-- |x |reimplemented in Snow Dots style| |-- |-- |y |reimplemented in Snow Dots style| |-- |-- |radius |reimplemented in Snow Dots style| |-- |-- |width |reimplemented in Snow Dots style| |-- |-- |nSlices |reimplemented in Snow Dots style| |-- |-- |nLoops |reimplemented in Snow Dots style| |-- |-- |smooth |new smoothness switches in October2011| |dotsDrawableDotKinetogram|dotSize |size |"dot" prefix redundant?| |-- |-- |stencilNumber|reimplemented to use OpenGL stencils| |-- |-- |smooth |new smoothness switches in October2011| |dotsDrawableImage(s)|dotsDrawableImage|dotsDrawableImages|renamed to plural to express vectorization| |-- |fileName |fileNames |reimplemented to use multiple file names| |-- |-- |pixelHeights|image property from server-side| |-- |-- |pixelWidth|image property from server-side| |-- |-- |pixelColors|image property from server-side| |-- |-- |imageTextureMakerFunction()|reimplemented as dotsDrawableTextures subclass| |dotsDrawableLines|x |xFrom |more convenient to separate line endpoints?| |-- |x |xTo |more convenient to separate line endpoints?| |-- |y |yFrom |more convenient to separate line endpoints?| |-- |y |yTo |more convenient to separate line endpoints?| |dotsDrawableTargets|dotSize |size |"dot" prefix redundant?| |-- |-- |smooth |new smoothness switches in October2011| |dotsDrawableText|-- |rotation |new text settings per instance| |-- |-- |isFlippedHorizontal|new text settings per instance| |-- |-- |isFlippedVertical|new text settings per instance| |-- |-- |typefaceName|new text settings per instance| |-- |-- |fontSize |new text settings per instance| |-- |-- |isBold |new text settings per instance| |-- |-- |isItalic |new text settings per instance| |-- |-- |isUnderline|new text settings per instance| |-- |-- |isStrikethrough|new text settings per instance| |dotsDrawableTexture(s)|dotsDrawableTexture|dotsDrawableTextures|renamed to plural to express vectorization| |-- |sourceRect|-- |no longer used| |-- |opacity |-- |no longer used| |-- |falseColor|-- |no longer used| |-- |filterMode|smooth |new smoothness switches in October2011|

Non-OpenGL

dotsTheMachineConfiguration
Existing machine configuration .xml files may need to be updated to use MGL instead of Psychtoolbox. For example, the Psychtoolbox handles @GetSecs and @WaitSecs may change to the MGL handles @mglGetSecs and @mglWaitSecs. If Psychtoolbox will remain on the Matlab path, these handles can stay as they are.

During development, I had lots of UDP port conflicts with some other unknown application. So I changed the default ports for remote object managers to start at 49550 instead of 49050. This should not affect existing machine configuration .xml files.

|old name|new name|why?| |:---------|:---------|:-----| |@GetSecs |@mglGetSecs|optional, depending on Psychtoolbox availability| |@WaitSecs |@mgleWaitSecs|optional, depending on Psychtoolbox availability| |UDP ports 49050-49055|UDP ports 49550-49555|clearer port range?|

A few configuration property names for dotsTheScreen have changed: |old name|new name|why?| |:---------|:---------|:-----| |pixelSize |bitDepth |name consistent with MGL usage| |displayRect|-- |unused in MGL| |priority |-- |unused in MGL| |stereomode|-- |stereo handled differently in MGL| |preferences|-- |preferences handled differently in MGL| |textSettings|-- |now handled by individual dotsDrawable- instances|

dotsAllSingletonObjects
Singleton initialization methods now accept property-value pairs as input arguments. This includes the theObject() and initialize() methods. So, for example, dm = dotsTheDrawablesManager.theObject(); dm.clientMode = false; dm.serverMode = false; dm.initialize(); Can use nicer syntax: dm = dotsTheDrawablesManager.theObject('clientMode', false, 'serverMode', false); This allows the singleton to initialize once, using the given properties. Previously it would have to initialize twice--once with default properties and once again with the given properties.

dotsTheMessenger
dotsTheMessenger had a bug where an occasional message, which had been correctly sent and received, could not be acknowledged. This caused a communication breakdown between client and server. Although the bug was rare, it was consistent. I fixed the internal accounting to prevent this bug.

dotsAllRemoteObjectManagers
The new updateClientObjectProperties() method allows remote object managers to update client-side objects with property values from the server-side counterpart. This is useful when the client wants to know the results of file or hardware access carried out on the server side. |old name|new name|why?| |:---------|:---------|:-----| |-- |updateClientObjectProperties()|server-to-client update utility|

Unit Tests
I reimplemented the Snow Dots test runner and renamed it. runAllDotsTests() becomes dotsRunTests(). The new implementation is easier to configure and should eliminate some sequential effects during long test runs. This only affects developers.

|old name|new name|why?| |:---------|:---------|:-----| |runAllDotsTests()|dotsRunTests()|"dots" as prefix, no longer needs to run "all" tests|