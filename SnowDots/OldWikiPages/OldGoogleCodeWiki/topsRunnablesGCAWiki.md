This is the first time I'm using Snow Dots project wiki to explain a change to many of you users at once! I hope it proves useful.

I want to let you know about some significant changes I'm making in the way Tower of Psych and Snow Dots manage flow of control and execution of concurrent behaviors. Without going into detail, here is the flavor:

Until Now

You add various function calls to a topsGroupedList object, and it's job is to call them all over and over in order to keep them all going at the same time. The big trouble is that you have to add the function calls to the loop object by hand, and it's not clear what you're supposed to add.

From Now On

There are new topsRunnable objects, which are meant to "run", which means to execute part of your experiment. Some of these are also "topsSteppable" objects, which means they are able to run a little bit at a time. This allows multiple objects to "step" in an interleaved way, so that they all run together.

For example the "topsStateMachine" is now implemented as a topsSteppable, and it can interleave with a "topsCallList", which can call arbitrary functions. So, you can do things like update hardware and graphics at the same time that you're traversing states.

There is a new example using topsRunnable and topsSteppable objects in tower-of-psych/demos/demoRunnables.m. It shows how to interleave a topsStateMachine with a topsCallList. I hope it also conveys the general intuition behind topsRunnable objects.

I also updated all the existing demos in Tower of Psych and Snow Dots to use these new classes.

What to Do

You should "svn update" both Tower of Psych and Snow Dots at the same time.

Since there are new classes, and I got rid of some old ones, only update when you're ready to make some code changes to your own task. The basic change will be:

Replace topsFunctionLoop with topsCallList. Interleave topsCallList with topsStateMachine using topsSergeant (as in demoRunnables.m).

Support

I'm updating the HTML documentation that you can download for each project. I know it's not comprehensive, but you can at least see what the new Tower of Psych classes are, and some about

I also expect that we'll stay in touch individually, so that should help.

Thanks!