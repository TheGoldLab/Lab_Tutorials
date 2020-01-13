Josh Gold and I (Ben Heasly) talked about modeling animation in an explicit way. As of October2011, "animation" is handled by individual Drawable classes, which happen to update their internal state every time they draw().

This is fine for stimuli which appear to the subject to be stateless. This includes static stimuli like targets and even dynamic stimuli like random dot kinetograms.

But what about other kinds of animation? If a helicopter were to fly horizontally across the screen, it would be nice to model this animation explicitly. The experimenter should be able to say "fly from here to there" or "start flying to the right", instead of having to micromanage the flying behavior every frame, as part of task logic.

More parameters, not just position, should be "animatable". Size, color, and non-visual parameters like pitch or volume, might need to be "animated" along with position or instead of position.

Thoughts
So we would like to implement a clear model for organizing animation. The model would implicitly define what we mean by "animation" in the context of Snow Dots.

For the moment I'm just going to jot down notes from our conversation and my initial thoughts.

Animation Matrices
Let's say that "animation" means gradually changing a parameter over time. One way to specify gradual changes would be with a matrix of times and values to be applied to a parameter of a Drawable object: t0, value0; t1, value1; t2, value2; etc... In this case a draw() method could look up a value based on the current time and apply the value to a property. The value would change abruptly at t0, t1, and t2. Smooth animation would require a lot of values, or interpolation.

For uniform motion, it might be simpler to use a matrix of delta-values: t0, deltaValue0; t1, deltaValue1; t2, deltaValue2; etc... The parameter would "slide" at a different constant rate in each interval t0-t1, t1-t2, and t2-inf. However, since updates might occur at irregular intervals, it's not quite clear how to implement the sliding. It seems messy to try to interpolate between delta-values.

It would be up to the experimenter to compute an animation matrix which obeyed conventions.

There might also be utility methods for computing common types of animation matrices, such as a simple linear sweeps, or piecewise circular or sinusoidal motion.

Absolute values or delta-values could be applied to any public class property. It might be nice to apply values to class methods as well. Since incrementing a method is meaningless, methods could be animated only with absolute value matrices.

Using animation matrices would imply that only numerical values can be animated, which seems reasonable.

Class Model
Even simple animation matrices would require significant state management. When should the animation begin? How far along is it? What should happen when the matrix runs out of values? Which Drawable classes should be animated? Which of their properties should be updated? There's plenty of bookkeeping to do.

So I think it makes sense to define an Animator class. Each Animator instance could aggregate one or more animation matrices, pick values from them, and assign the same values to one or more Drawable objects. The Animator would assume that each aggregated Drawable had a similar interface.

Perhaps Animator should be a subclass of Drawable. This would make them relatively easy to drop into existing code. The Animator draw() method could look up values, deal them to aggregated Drawables, then invoke draw() on aggregated Drawables.

Aggregation
Dealing with the Animator---<>Drawable aggregation relationship would be somewhat tricky, since the same aggregation would need to exist on the client and server sides.

Perhaps TheDrawablesManager or AllRemoteObjectManagers should have a new method for "wiring up" an aggregation relationship on both client and server.

Such a method would need to know the outer and inner objects, and the property of the outer object which should receive the inner object. Both objects would need to belong to the same manager.

Getting this aggregation right would be important because we would want animation updates to occur on the server side. We would not want to send multiple property changes on every frame.

Remote object aggregation is a general problem for Snow Dots. Solving it might pay off elsewhere, too.

Bits and Pieces
However its implemented, animation would have several parts, including: * specify values and a time course for applying the values * specify which objects and object members should receive the values * specify when to start/restart animation * pick values and assign them each frame * decide what to do if we run out of values (freeze? loop?) * query the progress of ongoing animation * terminate animation for some reason * span the client and server

Wiring up an aggregation relationship would be great, but working with the objects would still require care. As of October2011, it's not possible to send an object through dotsTheMessenger. So for the client to access a member of the inner object, it needs to work with the inner object itself.

For example, consider an outerObject and an innerObject which both belong to a manager: manger.updateClientObjectProperties(outerObject); Would update properties for the outerObject on the client side, as expected. But it would not not update the properties of the inner object. The experimenter would also have to invoke manger.updateClientObjectProperties(outerObject.innerObject);

Dynamic stimuli like the random dot kinetogram, or new stimuli such as exploding particle systems (see demos/explodingBagOfMoney), will need a convenient mechanism for resetting to the beginning of their evolution. This might correspond to setting an internal-time variable to 0, then "animating" the internal-time, with respect to the "real" time.

dotsTheDrawablesManager already has a property called isAnimating, which determines whether it should invoke draw() methods and swap frame buffers during its runBriefly() method. This is a different sense of "animation".

We should make sure the senses don't conflict. Hopefully we can fold this "animating" behavior into the new model gracefully.

Restarting animation based on a delta-value matrix would not necessarily produce the same animation. The initial absolute value would have to be reset as well.

To help with this kind of usage, and other usages, it would be convenient if Animator had a setMany() method for dealing property vales to its inner Drawables. However, this would be similar to the setGroupProperty() method of dotsAllObjectManagers. Is there a good way to reuse this behavior without duplicating it?

An alternative would be to specify an initial value for each Drawable member while configuring the Animator, to be applied when the animator was reset. This would be less general than setMany(), and more clearly related to animation, as opposed to general object management.