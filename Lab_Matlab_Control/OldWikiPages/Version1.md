I'm aiming for a major revision, called Version 1. I expect to finish it by April, 2012. The big goals for 1.0 are:

Full agreement among project areas, including code base, documentation, and project site.
Full agreement with Tower of Psych Version 1
Resolution of outstanding project issues, removal of stale issues
Good explanation of project components, and how to access components individually, without requiring the whole enchilada
Installer to easily get Version 1 by name (no need to know about repository tags, trunk etc.)
Expectation of long-term stability
This page contains my laundry list of changes to Snow Dots. I'll keep a similar for Tower of Psych

January2010

The first goal is to complete the changes in the January2012 milestone.

This was done at the end of January, 2012.

Foundation

With fewer singletons to worry about, I want to flatten the singletons/ and superclasses/ folders into the foundation/ folder

(small)

As of January2012, these folders are gone.

Mex

I want to Remove mexUDPMxGram, since it's never used.

(small)

As of r892, mexUDPMxGram is gone.

Demos

Demos should agree with all the changes up to Version 1.

Revise and recomment 2afc demo
As of r892, 2afc demo is reimplemented to use topsEnsmbles.
Revise and recomment dotris demo
did this.
Revise and recomment plexon integration demo
Actually, I removed this because it wasn't much of a "task"
Remove squares demo
As of r892, the squares is replaced with SquareTagPlus.
(big - 2 days)

Demos were reimplemented in March 2012.

Code Style

Class members that are intuitively "internal" to a class should all use the SetAccess = protected or Access = protected modifier. That way members are viewable but won't get messed with by accident. Now, there's a mix of access modifiers and hidden status, for no good reason.

(small)

Made uniform style around member access as of r924.

Singletons

Snow Dots does not need so many singletons. They cause headaches with managing global state. In addition to removal of manager singletons (in January2012):

Move shared defaults from TheSwitchboard to TheMachineConfiguration
Remove TheSwitchboard, since no more windowNumber or pixelsPerDegree
TheScreen must work via dotsClientEnsemble (instead of dotsTheDrawablesManager)
As of January2012, this works, and dotsTheDrawablesManager is gone.
(big - 1 day)

As of r934, all this is done

Readables

I want to make a dotsReadableEyeEyelink class, based on the MGL Eyelink API. But I'll but leave testing up to someone with Eyelink hardware.

(small)

r945 contains an implementation of dotsQueryableEyeEyelink.
Utilities

Utilities can be pruned and reorganized.

MGLFlushGauge -> dotsMglFlushGauge
Did in r936.
Remove checkUDPSnowDots, since unclear and old
As of r892, checkUDPSnowDots is gone.
Remove resetTheSingletons, since only two singletons left
As of r937, resetTheSingletons is gone.
Remove repeatAllDotsTests, since no more global modes.
As of January2012, repeatAllDotsTests is gone.
ApplyClockDriftAndOffset -> clockDriftApply
Did in r936.
EstimateClockDriftAndOffset -> clockDriftEstimate
Did in r936.
Reimplement benchmarkDOutStrobedWords to use ensembles
done, became benchmarkDOutPlexon, in r943.
Implement utilities that can do remote data log updating, (via an ensemble)
r947 contains new dotsDataLogUtilities for doing log updates and writing, via ensembles.
(big - 1 day)

done, as of r947

Tests

I'll need to rename several unit tests to agree with 1.0.

for r950 I reviewed test suite names and updated just one

(small)

Issues

The issues database has become stale and clumsy.

Close issues solved in 1.0
All issues reviewed as of 26 March 2012.
No-Solve other issues with a note
I did this on 8 Jan
(small)

I didn't close all the issues, but the remaining issues are somewhat nebulous and low-priority.

userProjects/

I should reimplement predictiveInference for Version 1.

(big - 1 day)

The predictive inference task is updated as of r971

Installer

The installer should be easier to point at a named version, like "Version 1". Also, it should be a complete installer as opposed to a checklist.

SVN checkout for Snow Dots, Tower of Psych, and MGL
Grab from file exchange via urlwrite():
http://www.mathworks.com/matlabcentral/fileexchange/22846-matlab-xunit-test-framework?controller=file_infos&download=true
http://www.mathworks.com/matlabcentral/fileexchange/345-tcpudpip-toolbox-2-0-6?controller=file_infos&download=true
Build mex stuff for pnet and mex/
(small)

r978 contains a new implementation of installSnowDots.

Docs

The role and form of the docs can be tweaked.

Doc front page as TOC, not as intro
Focus on classes and functions as API/reference
Remove confusing nav tabs
(small)

As of r983, I updated the docs to be more focused.

wiki

The wiki needs some more explanatory content.

Components Page
component descriptions
checkout links for component folders
component dependencies, like OS and hardware
Components page is done as of r994
Page about client-server and ensemble communications
ClientServerEnsemble page is done as of r1014
sweet diagrams
all components and collaborations/dependencies
r1014 contains new components diagram.
objects, ensembles and Matlab instances
r1014 contains new digrams about client-server and ensembles.
Page of algebra about exploding bag of money
r1048 contains new a ExplosionAlgebra page.
(big - 3 days)

Main Page

The main page should make better first impressions.

Short intro, components
Short status
Shouts out to related projects
Several wiki pages (below the fold)
(small)

As of 14 April 2012 Version 1 is complete!