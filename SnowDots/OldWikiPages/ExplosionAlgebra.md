dotsDrawableExplosion draws lots of particles as they move through parabolic trajectories. When a particle hits the ground, it bounces and enters a new trajectory. After a few bounces, it comes to rest on the ground.

Each particle is constrained by its starting position, its resting position, and the total time it must spend in reaching its resting position. The system of particles uses a constant downward acceleration, velocity damping each time a particle bounces, and a fixed number of trajectories that each particle must trace before resting.

This is enough information to solve the system, so that the position of any particle can be computed for any time between starting and resting. This page describes how dotsDrawableExplosion solves the system.

Easy System

Consider a simplified system, in which a particle starts out on the ground, bounces on the ground, and comes to rest on the same ground. This system is relatively easy to solve.

The diagram below depicts the y-position of a particle as a function of time.

http://snow-dots.googlecode.com/svn/wiki/diagrams/explosion-algebra-easy.png

http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' /> is the initial upward velocity of the particle
http://latex.codecogs.com/gif.latex?\rm v_{y3}%.png' /> is the upward velocity of the particle after three bounces
http://latex.codecogs.com/gif.latex?\rm damp_y%.png' /> is the damping applied the particle's velocity at each bounce
http://latex.codecogs.com/gif.latex?\rm t_0%.png' /> is the time the particle spends in the air before the first bounce
http://latex.codecogs.com/gif.latex?\rm t_3%.png' /> is the time the particle spends in the air after the third bounce, before coming to rest
http://latex.codecogs.com/gif.latex?\rm t_{rest}%.png' /> is the total time spend coming to rest
http://latex.codecogs.com/gif.latex?\rm a_{y}%.png' /> is the constant, downward acceleration of the system
the number of trajectories http://latex.codecogs.com/gif.latex?\rm n%.png' /> is 4 in this diagram
First let's consider just vertical motion. A large constraint on vertical motion is the total time that a particle must spend coming to rest. This is the sum of times from each trajectory.

http://latex.codecogs.com/gif.latex?\rm t_{rest} = \sum_{i=0}^{n-1} t_i%.png' />

To solve each trajectory http://latex.codecogs.com/gif.latex?\rm i%.png' />, we would like to know each http://latex.codecogs.com/gif.latex?\rm t_i%.png' /> and each starting upward velocity http://latex.codecogs.com/gif.latex?\rm v_{yi}%.png' />. Since the particle starts and ends each trajectory on the ground, and since downward acceleration is constant, http://latex.codecogs.com/gif.latex?\rm t_i%.png' /> and http://latex.codecogs.com/gif.latex?\rm v_{yi}%.png' /> are related by simple projectile motion.

http://latex.codecogs.com/gif.latex?\rm 0 = v_{yi}t_i + \frac{1}{2}a_yt_i^2 = v_{yi} + \frac{1}{2}a_yt_i%.png' />

http://latex.codecogs.com/gif.latex?\rm t_i = \frac{-2v_{yi}}{a_y}%.png' />

We can also express http://latex.codecogs.com/gif.latex?\rm v_{yi}%.png' /> in terms of the initial upward velocity http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />, and the velocity damping applied at the start of each trajectory http://latex.codecogs.com/gif.latex?\rm damp_y%.png' />.

http://latex.codecogs.com/gif.latex?\rm v_{yi} = v_{y0} damp_y^i%.png' />

Combining equations, we have the time spend in each trajectory in terms of the initial velocity http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />.

http://latex.codecogs.com/gif.latex?\rm t_i = \frac{-2 v_{y0} damp_y^i}{a_y}%.png' />

Taking the sum over all trajectories, we can replace the unknown trajectory times http://latex.codecogs.com/gif.latex?\rm t_i%.png' /> with the known total resting time http://latex.codecogs.com/gif.latex?\rm t_{rest}%.png' />.

http://latex.codecogs.com/gif.latex?\rm t_{rest} = \sum_{i=0}^{n-1} t_i = \sum_{i=0}^{n-1} \frac{-2v_{y0} damp_y^i}{a_y} = \frac{-2v_{y0}}{a_y} \sum_{i=0}^{n-1}damp_y^i%.png' />

We can solve this for http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />.

http://latex.codecogs.com/gif.latex?\rm v_{y0} = \frac{t_{rest} a_y}{-2\sum_{i=0}^{n-1}damp_y^i}%.png' />

So the initial upward velocity is proportional to the total time spend coming to rest, and to the downward acceleration. It varies inversely with the number of trajectories that a particle must trace before resting, and the velocity damping between trajectories.

From http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />, we can calculate any http://latex.codecogs.com/gif.latex?\rm v_{yi}%.png' /> and in turn any http://latex.codecogs.com/gif.latex?\rm t_i%.png' />. We can also use the http://latex.codecogs.com/gif.latex?\rm t_i%.png' /> solutions to solve for horizontal motion (see below).

So this "easy" system is solved. On to a more general, harder system.

Harder System

Now consider a more general system, in which a particle may start out in mid-air. This system is harder to solve because the non-zero starting height introduces a degree of freedom. The system has two solutions, one in which the starting particle velocity is upward, and one in which it's downward.

The diagram below depicts the y-position of a particle as a function of time, along with its mid-air starting position.

http://snow-dots.googlecode.com/svn/wiki/diagrams/explosion-algebra-hard.png

http://latex.codecogs.com/gif.latex?\rm y_{\alpha}%.png' /> is the non-negative starting height of the particle
http://latex.codecogs.com/gif.latex?\rm v_{y\alpha}%.png' /> is the new starting upward velocity of the particle
http://latex.codecogs.com/gif.latex?\rm v_{y\alpha-}%.png' /> is an alternative starting downward velocity of the particle
http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' /> is a time in the past, spent reaching the mid-air starting position
http://latex.codecogs.com/gif.latex?\rm t_{\beta}%.png' /> is the new time spent coming to rest, from the mid-air starting position.
The intuition for this system is that same as for the easy system. If we knew http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' /> and http://latex.codecogs.com/gif.latex?\rm t_{rest}%.png' /> we could solve all of the trajectories. The particle has a known starting position http://latex.codecogs.com/gif.latex?\rm y_{\alpha}%.png' /> and a known time http://latex.codecogs.com/gif.latex?\rm t_{\beta}%.png' /> that it must spend coming to rest. But it has traveled for some unknown time http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' /> since leaving the ground.

The starting velocity http://latex.codecogs.com/gif.latex?\rm v_{y \alpha}%.png' /> is also unknown. Since http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' /> and http://latex.codecogs.com/gif.latex?\rm v_{y \alpha}%.png' /> are both unknown, there are two possible values for http://latex.codecogs.com/gif.latex?\rm v_{y \alpha}%.png' />. The particle may have recently left the ground, and have a positive http://latex.codecogs.com/gif.latex?\rm v_{y \alpha}%.png' />. Or, the particle may have been in the air for a long time and have a negative http://latex.codecogs.com/gif.latex?\rm v_{y \alpha -}%.png' />-. In the diagram above, the dashed purple trajectory shows this second case.

If we knew http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' />, it would be easy to reuse the solution for the easy system and calculate each http://latex.codecogs.com/gif.latex?\rm t_i%.png' />. But http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' /> depends on http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />, via projectile motion.

http://latex.codecogs.com/gif.latex?\rm y_{\alpha} + v_{y0}t_{\alpha} + \frac{1}{2}a_yt_{\alpha}^2%.png' />

http://latex.codecogs.com/gif.latex?\rm 0 = -y_{\alpha} + v_{y0}t_{\alpha} + \frac{1}{2}a_yt_{\alpha}^2%.png' />

http://latex.codecogs.com/gif.latex?\rm t_{\alpha} = \frac{-v_{y0} \pm \sqrt{v_{y0}^2 + 2a_y y_{\alpha}}}{a_y}%.png' />

This is a quadratic for http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' />, which has two solutions, as expected. We can't yet solve for http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' /> because we don't know http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />. In the easy system, we had used http://latex.codecogs.com/gif.latex?\rm t_{rest}%.png' /> to solve for http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />. Now we have http://latex.codecogs.com/gif.latex?\rm t_{\beta}%.png' /> instead, but the two times are clearly related.

http://latex.codecogs.com/gif.latex?\rm t_{\beta} = t_{rest} - t_{\alpha}%.png' />

We can expand this to view http://latex.codecogs.com/gif.latex?\rm t_{\beta}%.png' /> in terms of http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />.

http://latex.codecogs.com/gif.latex?\rm t_{\beta} = \left (\frac{-2v_{y0}}{a_y} \sum_{i=0}^{n-1}damp_y^i \right) - \left (\frac{-v_{y0} \pm \sqrt{v_{y0}^2 + 2a_y y_{\alpha}}}{a_y} \right)%.png' />

Rearranging terms isolates the square root.

http://latex.codecogs.com/gif.latex?\rm t_{\beta}a_y = \left (-2v_{y0} \sum_{i=0}^{n-1}damp_y^i \right) - \left (-v_{y0} \pm \sqrt{v_{y0}^2 + 2a_y y_{\alpha}} \right)%.png' />

http://latex.codecogs.com/gif.latex?\rm t_{\beta}a_y + \left (2v_{y0} \sum_{i=0}^{n-1}damp_y^i \right) -v_{y0} = \pm \sqrt{v_{y0}^2 + 2a_y y_{\alpha}}%.png' />

Squaring both sides eliminates the square root. It also incurs a lot of algebra!

http://latex.codecogs.com/gif.latex?\rm \left[ t_{\beta}a_y + \left (2v_{y0} \sum_{i=0}^{n-1}damp_y^i \right) -v_{y0} \right ]^2= v_{y0}^2 + 2a_y y_{\alpha}%.png' />

The end result is a new quadratic for http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />.

http://latex.codecogs.com/gif.latex?\rm 0 = t_{\beta}^2a_y^2-2a_y y_{\alpha} \hspace{2mm}+\hspace{2mm} 2t_{\beta}a_y\left[2\left(\sum_{i=0}^{n-1}damp_y^i\right)-1\right]v_{y0} \hspace{2mm}+\hspace{2mm} 4\left[\left(\sum_{i=0}^{n-1}damp_y^i\right)^2 - \sum_{i=0}^{n-1}damp_y^i\right]v_{y0}^2%.png' />

The coefficients http://latex.codecogs.com/gif.latex?\rm A%.png' />, http://latex.codecogs.com/gif.latex?\rm B%.png' />, and http://latex.codecogs.com/gif.latex?\rm C%.png' /> are cumbersome, but allow us to solve for http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' />.

http://latex.codecogs.com/gif.latex?\rm A = 4\left[\left(\sum_{i=0}^{n-1}damp_y^i\right)^2 - \sum_{i=0}^{n-1}damp_y^i\right]%.png' />

http://latex.codecogs.com/gif.latex?\rm B = 2t_{\beta}a_y\left[2\left(\sum_{i=0}^{n-1}damp_y^i\right)-1\right]%.png' />

http://latex.codecogs.com/gif.latex?\rm C = t_{\beta}^2a_y^2-2a_y y_{\alpha}%.png' />

http://latex.codecogs.com/gif.latex?\rm V_{y0} =\frac{-B \pm \sqrt{B^2 - 4AC}}{2A}%.png' />

Since http://latex.codecogs.com/gif.latex?\rm i%.png' /> starts at 0, the sums are always at least 1, and http://latex.codecogs.com/gif.latex?\rm A%.png' /> is always non-negative. Assuming http://latex.codecogs.com/gif.latex?\rm t_{\beta}%.png' /> > 0 and http://latex.codecogs.com/gif.latex?\rm a_y%.png' /> < 0, http://latex.codecogs.com/gif.latex?\rm B%.png' /> is always negative. Assuming http://latex.codecogs.com/gif.latex?\rm y_{\alpha}%.png' /> > 0, http://latex.codecogs.com/gif.latex?\rm C%.png' /> is always positive. Thus, the "-" root is always less than the "+" root.

The "-" root of http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' /> should correspond to small, low velocity bounces, and a small value of http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' />. This would correspond to a positive value of http://latex.codecogs.com/gif.latex?\rm v_{y \alpha}%.png' />.

Conversely, the "+" root of http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' /> should correspond to large, high-velocity bounces and a longer value of http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' />. This would correspond to a negative value of http://latex.codecogs.com/gif.latex?\rm v_{y \alpha}%.png' /> and the dashed purple trajectory in the diagram above.

Minimum Resting Time

In order for http://latex.codecogs.com/gif.latex?\rm v_{y0}%.png' /> to have real roots, the quadratic discriminant must be non-negative.

http://latex.codecogs.com/gif.latex?\rm 0 < B^2 - 4AC%.png' />

There are many ways to manipulate this inequality, to emphasize one parameter or another. We can also interpret the inequality with physical intuition: real roots should represent scenarios that are plausible in the physical world, imaginary roots should represent impossible scenarios.

One impossible scenario would require a particle to come to rest in too short a time. For example, if the starting height or velocity were too high, or the downward acceleration too small, the particle might be unable to reach the ground and trace out all of its trajectories before the resting time elapsed. Scenarios like this should lead to imaginary roots.

What is the minimum resting time that a particle can satisfy, given other parameters? A key factor would be starting velocity http://latex.codecogs.com/gif.latex?\rm v_{y \alpha}%.png' />. Whether upward or downward, large velocities should lead to larger bounces, which would demand longer resting times.

This intuition suggests that "dropping" a particle with zero starting velocity should lead to the smallest resting times. What is the smallest plausible resting time http://latex.codecogs.com/gif.latex?\rm t_{\beta min}%.png' />, given http://latex.codecogs.com/gif.latex?\rm v_{y \alpha} = 0%.png' />?

Consider the time it takes to trace the 0th partial trajectory. Let http://latex.codecogs.com/gif.latex?\rm t_{drop}%.png' /> be the time it takes to fall from starting height http://latex.codecogs.com/gif.latex?\rm y_{\alpha}%.png' />, with http://latex.codecogs.com/gif.latex?\rm v_{y \alpha} = 0%.png' />. This is straightforward projectile motion.

http://latex.codecogs.com/gif.latex?\rm 0 = y_{\alpha} + 0*t_{drop} + \frac{1}{2}a_yt_{drop}^2%.png' />

http://latex.codecogs.com/gif.latex?\rm t_{drop} = \sqrt{\frac{-2y_{\alpha}}{a_y}}%.png' />

Since the particle began with zero velocity, it must have begun at the vertex of the 0th trajectory. Thus, the falling time http://latex.codecogs.com/gif.latex?\rm t_{drop}%.png' /> must be symmetric with the rising time http://latex.codecogs.com/gif.latex?\rm t_{\alpha}%.png' />. Thus, the initial velocity http://latex.codecogs.com/gif.latex?\rm v_{y0min}%.png' /> follows from projectile velocity.

http://latex.codecogs.com/gif.latex?\rm 0 = v_{y0min} + t_{drop}a_y%.png' />

http://latex.codecogs.com/gif.latex?\rm v_{y0min} = -t_{drop}a_y%.png' />

This accounts for the 0th trajectory. The time required for the remaining trajectories follows from the number of trajectories and the damping at each bounce.

http://latex.codecogs.com/gif.latex?\rm t_{1:nmin} = \frac{-2v_{y0min}}{a_y}\sum_{i=1}^{n-1}damp_y^i%.png' />

Adding up times for the 0th and the remaining trajectories, we have the minimum plausible resting time http://latex.codecogs.com/gif.latex?\rm t_{\beta min}%.png' />.

http://latex.codecogs.com/gif.latex?\rm t_{\beta min} = t_{drop} + t_{1:nmin} = \sqrt{\frac{-2y_a}{a_y}} + \frac{-2\sqrt{-2a_yy_{\alpha}}}{a_y} \sum_{i=1}^{n-1}damp_y^i%.png' />

dotsDrawableExplosion clips resting times to this minimum value.

Horizontal Motion

The explanations above account for with vertical motion and trajectory times. Once we know the trajectory times, we can also solve for horizontal motion.

Consider a total horizontal displacement http://latex.codecogs.com/gif.latex?\rm x_{rest}%.png' />, displacements within each trajectory http://latex.codecogs.com/gif.latex?\rm x_i%.png' />, and horizontal velocity damping applied at each bounce http://latex.codecogs.com/gif.latex?\rm damp_x%.png' />. What are the horizontal velocities at the start of each trajectory http://latex.codecogs.com/gif.latex?\rm v_{xi}%.png' />?

If we knew the initial horizontal velocity http://latex.codecogs.com/gif.latex?\rm v_{x0}%.png' />, each subsequent trajectory velocity would follow from velocity damping.

http://latex.codecogs.com/gif.latex?\rm v_{xi} = v_{x0} damp_x^i%.png' />

We can also relate individual velocities to the known total displacement.

http://latex.codecogs.com/gif.latex?\rm x_{rest} = \sum_{i=0}^{n-1} x_i = \sum_{i=0}^{n-1} t_i v_{xi}%.png' />

Combining equations, we can solve for http://latex.codecogs.com/gif.latex?\rm v_{x0}%.png' />.

http://latex.codecogs.com/gif.latex?\rm x_{rest} = \sum_{i=0}^{n-1} t_i v_{x0} damp_x^i = v_{x0}\sum_{i=0}^{n-1} t_i damp_x^i%.png' />

http://latex.codecogs.com/gif.latex?\rm v_{x0} = \frac{x_{rest}}{\sum_{i=0}^{n-1} t_i damp_x^i}%.png' />

This is how dotsDrawableExplosion solves for horizontal motion, after solving for vertical motion and time.