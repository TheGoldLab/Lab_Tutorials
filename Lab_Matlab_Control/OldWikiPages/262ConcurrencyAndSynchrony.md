I made some naming and behavior changes that will affect Tower of Psych after revision 186 and Snow Dots after 262.

This page has: * An overview of the big changes * A table of naming changes * A note about dotsTheMachineConfuguration XML files * An explanation of how to do animation, which uses the changes * An explanation of the new topsRunnableGUI graphical interface * An explanation of the new topsConditions class

**Overview**

The largest change to Tower of Psych is the naming of classes that handle concurrent behaviors. "topsSteppable" is gone, replaced with "topsConcurrent". Likewise, "topsSergeant" is replaced with "topsConcurrentComposite". It just seemed worthwhile to use the word "concurrent" more explicitly, since that's why those classes exist.

To be consistent with these class name changes, step() methods are now called runBriefly().

The largest change to Snow Dots is in the behavior of remote managers. In the past some remote transactions were carried out synchronously, meaning that Snow Dots would wait until they were done before proceeding. Other behaviors were carried out asynchronously, meaning that Snow Dots would request them and then proceed immediately, and later would be notified when the request had been fulfilled.

But asynchronous transactions tended to cause inconsistent behavior when carried out over a physical network. So now, all transactions are carried out synchronously. The take-home from this is that you never need to call the finishAllTransactions() method of a remote manager--that method is gone.

Tower of Psych concurrency changes and Snow Dots synchrony changes are related. The Snow Dots remote manager classes are now subclasses of topsConcurrent, which allows them to run along side other topsConcurrent classes, such as topsStateMachine. Thus, even with synchronous transactions, asynchronous (parallel) behaviors like animation are still possible, as in the explanation below.

**Naming Changes**

Here are the direct name changes to Tower of Psych: |Old Name|New Name|New Behavior?| |:---------|:---------|:--------------| |topsSeppable|topsConcurrent|no | |topsSergeant|topsConcurrentComposite|no | |topsSeppable.step()|topsConcurrent.runBriefly()|no | |topsTreeNodeGUI|topsRunnableGUI|no, still invoke with object.gui()|

And Snow Dots: |Old Name|New Name|New Behavior?| |:---------|:---------|:--------------| |dotsAllRemoteManagers.finishAllTransactions()|- |gone | |dotsAllRemoteManagers.receiveTransactions()|topsConcurrent.runBriefly()|no longer need to call directly| |- |dotsAllRemoteManagers.runForDuration()|new method | |dotsTheDrawablesManager.mayDrawNextFrame()|- |takes new isAnimating argument| |waitFunction|waitFevalable|cell array, not function handle|

**waitFevalable and XML files**

I changed "waitFunction" to "waitFevalable" because the fevalable cell array syntax is more flexible and it made it easier to implement synchronous transactions for dotsAllRemoteManagers. From the user point of view, it's probably just a syntax change. For example, @()WaitSecs(.001) would become {@WaitSecs, 0.001} which is not a big change.

But, the change will affect XML configuration files read and written by dotsTheMachineConfiguration. Existing XML files that refer to "waitFunction" need to be replaced or updated.

To replace an existing XML file, take it off the Matlab path, restart Matlab or clear classes, then launch dotsTheMachineConfiguration.gui(). It should say "no settings file loaded" in the title bar. Then click the "save" button and save a default file somewhere on the Matlab path. Then edit the new file to contain any custom settings.

To update an existing XML file, open it with a text editor. Find "waitFunction", which is listed under <dotsTheSwitchboard>, and add a new entry for "waitFevalable", among the others. Thus, ...'waitFunction',@()WaitSecs(.001)... would become ...'waitFevalable',{{@WaitSecs, .001}},'waitFunction',@()WaitSecs(.001)...

**Animation**

dotsTheDrawablesManager is now a subclass of topsConcurrent. Thus it has a runBriefly() method which is useful for doing animation concurrently with other behaviors. Here is a simple example of how do animation which uses the topsConcurrent behaviors as well as the new synchronous transaction behavior of Snow Dots.

Let's assume we've already created some dotsDrawables objects and they're already in the active group of dotsTheDrawablesManager. The first step of animating is to draw the first frame which we can do by calling mayDrawNextFrame() and passing an argument (which is new) that says to set isAnimating to true. dm = dotsTheDrawablesManager.theObject; dm.mayDrawNextFrame(true); Snow Dots will wait until this first frame has been drawn before continuing. The "lastFrameTime" of dotsTheDrawablesManager will be filled in with the onset time of the first frame. It will set the value of isAnimating to true.

The next step is to allow runBriefly to run for a while, allowing it to keep animating. duration = 5; dm.runForDuration(duration); Animation will continue for the given duration, while dotsTheDrawablesManager invokes its own runBriefly(), repeatedly. This allows it to carry out animation on the local machine, or just pass time while animation is carried out on a remote machine. The syntax is the same either way.

The last step is to tell dotsTheDrawablesManager to stop animating: dm = dotsTheDrawablesManager.theObject; dm.mayDrawNextFrame(false); Snow Dots will also wait until this last frame has been drawn before continuing. Again, the "lastFrameTime" of dotsTheDrawablesManager will be filled in with the onset time of the last frame, and isAnimating will be false.

The Snow Dots demo script demoDrawableDotKinetogram.m contains a similar example of animation.

The Snow Dots demo task demoDots2afcTask contains a more complicated example, which interleaves animation with other task behaviors. Instead of using runForDuration(), it adds dotsTheDrawablesManager as a child of a topsConcurrentComposite object.

Both demos use the runBriefly() behavior of topsConcurrent and the synchronous transactions of dotsAllRemoteObjectManagers to do animation.

**topsRunnableGUI**

Along with the naming changes related to topsConcurrent objects, Tower of Psych has a new graphical interface for topsRunnable objects (which include topsConcurrent objects), called topsRunnableGUI. It's richer than the previous topsTreeNodeGUI, but it's invoked the same way: with the gui() method of a topsRunnable object.

The Tower of Psych demo script demoRunnables script invokes the new interface for a collection of topsRunnable objects.

There are two key features of the new interface: * All types of topsRunnable objects, including topsTreeNodes, topsStateMachines, or dotsTheDrawablesManager, show up in the new interface * Objects that are children of topsConcurrentComposite objects show up with their (names) inside parentheses. It should be clear at a glance which objects will be run concurrently.

**topsConditions**

There is a brand-new Tower of Psych class called topsConditions. It's job is to keep track of parameters and various sets of values. It can traverse all the combinations parameter values, using a few different methods. It can automatically assign parameters values to targets, such as object properties or as method arguments.

It's also a topsRunnable subclass, so it can control flow through a task. For example, it should make it easy to let a task run until all combinations a few parameters have been tried.

The Snow Dots demo script demoRandomConditions uses topsConditions to travers several combinations of color, motion strength, and motion direction of a dotsDrawableDotKinetogram.

The Snow Dots demo task demoDots2afcTask contains a more complicated example, which uses and reuses topsConditions to randomize motion directions during each of a few different trial types.