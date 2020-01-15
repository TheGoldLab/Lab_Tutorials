January2012 is the third formal milestone for the Snow Dots project. It corresponds to the repository tag called January2012: http://snow-dots.googlecode.com/svn/tags/January2012

Documentation contemporary with January2012 is available.

January2012 will receive bug fixes, but new API and feature changes will go in the trunk, to be included in a later milestone.

There is companion January2012 tag for the Tower of Psych project. The Snow Dots and Tower of Psych "January2012" revisions are expected to work together.

**Overview**

January2012 represents a bunch of refactoring. Some of the changes are hidden inside class implementations. Some have significant behavior API changes.

The biggest change is the removal of object manager singletons, such as dotsTheDrawablesManager! Instead, Snow Dots will use "ensembles" to group objects together and distribute them across Matlab instances.

**dotsDrawableVertices and OpenGL Buffers**

The new dotsDrawableVertices class uses OpenGL vertex buffers to store position and color data. Since colored vertices are the basis for many kinds of graphic, many dotsDrawable classes are now implemented as subclasses of dotsDrawableVertices.

There are a few benefits to this reimplementation: * graphics that want to draw many vertices at once can do so without transmitting all of the vertex data on every frame. This improves performance when you draw the same thing more than once. * graphics that want to use vertex shaders with custom vertex attributes or transform feedback can take advantage of the vertex buffer functionality. * dotsDrawable classes have more API and functionality in common, so they can be treated uniformly.

Classes that use OpenGL textures have not been implemented as dotsDrawableVertices subclasses. These classes have always stored data in OpenGL texture objects, so they already perform well for repeated drawing.

See all the demos in demos/drawable/.

**dotsReadable Replaces dotsQueryable**

dotsQueryable classes performed two major functions: getting data from hardware devices, and classifying data with a spatial model. These functions have been broken into separate classes, and dotsQueryable classes have been removed.

The new dotsReadable family of classes replaces the dotsQueryable family. Readables get data from hardware, but don't impose a spatial model on the data
The January2012 milestone of Tower of Psych implements new classes for spatial modeling and classification of data.
dotsPhenomenon and dotsFiniteDimension have been removed.
Object Ensembles and Remoteness

January2012 removes a handful of classes related to object management and remote objects. Classes dotsTheDrawablesManager had become inflexible monoliths which were difficult to extend, debug, or explain.

Object manager singletons are replaced with "ensemble" instances, which are smaller and more flexible. Ensembles perform the two major functions of object managers: grouping like objects together for batch operations, and distributing objects across Matlab instances.

Basic grouping behavior is provided by the topsEnsemble class, which is new in the January2012 milestone of Tower of Psych.

Remote object distribution is implemented in the new dotsClientEnsemble class.

dotsClientEnsemble is a "drop-in" replacement for topsEnsemble which acts as a proxy for remote objects.
dotsEnsembleServer works on the remote end, to handle requests coming from dotsClientEnsemble objects.
dotsEnsembleUtilities provides several static methods for user convenience, and to establish behaviors that the client and server need to agree on.
See demos/demoEnsemble.m.

Unlike manager singletons, dotsClientEnsemble will not use property listeners for aggregated objects. Instead, current, public object properties are transmitted during addObject(), and subsequent changes should be made via ensemble methods. This reduces code complexity.

**Catching Up**

January2012 makes some big changes to Snow Dots. As a result, some parts of the project will need time to catch up. Such consistency is the goal for Version1, which is coming soon.

For January2012 itself, the Snow Dots unit tests are passing and the simple demos can run. But the task demos, which are more complicated, will be broken for a while. Alas.

As I progress towards Version1, I will update the task demos and make a note of it here.