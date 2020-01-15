"November2010" is the first formal milestone for the Snow Dots project. It corresponds to the repository tag called November2010: https://snow-dots.googlecode.com/svn/tags/November2010

Documentation contemporary with November2010 is also available.

November2010 might receive obvious bug fixes, but new API and feature changes will go in the trunk, to be included in a later milestone.

There is a companion November2010 tag for the Tower of Psych project: https://tower-of-psych.googlecode.com/svn/tags/November2010 The Snow Dots and Tower of Psych "November2010" revisions are expected to work together.

Recent changes for November2010 include the following:

Digital Output

abstract model/interface
TTL pulse, one at a time
TTL sequence with realtime spacing
strobed code/word This is done as of r381.

implementation for Measurement Computing 1208FS
length of TTL sequence vs. length of device HID report

documentation of mexHID timestamps vis. the 1208FS This is done as of r381.

mexHID features
issues 37, 38, 40, 44 about "vectorization", seizing, and meaningful descriptions

mexHID needs documentation, especially about USB frame timing returns This is done as of r391.
Online Data Access

dotsTheComputablesManager
a remote manager
server to run on e.g. Plexon machine
knows about, synchronizes topsDataLog incrementally
topsDataLog may only contain data convertible to mxGram
mxGram can send function handles
may invoke compute() on managedObjects periodically (could be inf period) This is done as of r402.

dotsComputable
result = compute() to e.g. access Plexon SDK

result = compute() to be invoked via client-side object for e.g online reverse correlation
compute() result also stored in computeResult property to access periodic results
dotsComputableFunction invokes arbitrary function with arguments This is done as of r402.
"Physiology" Task

two-alternative task
similar to some monkey electrophysiology experiments
integration test: should run to completion without subject or attendant

uses Digital Output to Plexon
serial numbers used to reconcile client and Plexon clocks

timing test: TTL sequence connected to Plexon analog input

uses Online Data Access to Plexon
each trial, analyzes and displays TTL sequence seen at Plexon's analog input

same analysis must be available offline
clock reconciliation from probed words applied to analog inputs
These are done, as of r438.

Documentation

scripted regeneration
script to rebuild with doxygen and package dots and tops together
make HTML docs servable from project sites by including in SVN repository, as in http://code.google.com/p/support/issues/detail?id=720
This is done, as of r458.

doxycomments
each class must have doxycomment overview
each class must have doxycomments for each member
no doxycomments may be out of date
but not all doxycomments need be complete/verbose
This is done, as of r490.