**Building a sample experiment.**

*Part 1*

In order to construct a practical experiment, a basic understanding of Tower of Psych and Snow dots is required.

While there are many elements of each that need to be used to develop a fully functioning experiment, it is best to start with just learning how to present something on screen.

The start of this tutorial will primarily focus on using various aspects of Snow Dots, with some simple elements from Tower of Psych used to organize the presentation.

To begin we will use a slightly modified version of the [demoDrawableText.m](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/demos/drawable/demoDrawableText.m) file located in the demo folder of Snow Dots. You should copy and paste the code at the bottom of this page into a new file and run that to follow along. 

The first block is establishing the function name with one input argument. In this example the delay argument is the amount of time the experiment will pause while the text is on screen.
```
function moddedDrawableText(delay)
```
If no argument is given when the function is called, the delay will default to 2 seconds.
```
if nargin < 1
    delay = 2;
end
```
When using a Snow Dots class you must first create an object and assign it to a Snow Dots class that exists. We will now create two drawable text objects and then input some property values. 
```
tx = dotsDrawableText();
tx2 = dotsDrawableText();
```
When creating an object, assigning property values works like a structure in Matlab. The property values for different Snow Dots classes are defined in the Properties section of their respective Matlab files.  In the next block we are simply passing along to Matlab what we want the two text strings to say and what color we want them to be.
```
tx.string = 'Juniper juice';
tx2.string = 'hello';
tx.color = [0 128 64];
tx2.color = [250 25 250];
```
In order for Snow Dots to present anything on screen a drawing window must be open.  The block below is simply opening up a blank screen for Snow Dots to 'draw' on.  This relies on a method within dotsTheScreen to do so. There are more details and options for setting up the Screen, but for now the default configuration should suffice. The first line is simply opening a black drawing window.
```
dotsTheScreen.openWindow();
```

The next block is using a method from dotsDrawable, the super class for all Snow Dots drawables, to present the newly created text objects. The pause line is a built-in Matlab function.
```
dotsDrawable.drawFrame({tx});
pause(delay)
dotsDrawable.drawFrame({tx2});
pause(delay)
```
Classes like dotsDrawableText also inherit properties from their respective super classes. In this case, dotsDrawableText objects can also be manipulated using properties from dotsDrawable. In this case dotsDrawable only has one property "is Visible".  The default value is True.  However, if we set this value to false for a particular object, it will no long appear when called.
```
tx.isVisible = false;
dotsDrawable.drawFrame({tx});
pause(delay)
```
If we wanted both text objects to appear on screen at the same time we could pass both objects to drawFrame in a cell. In this case, the text objects will overlap since the default values of x and y are 0. We will move the first text object up a few units.
```
tx.isVisible = true;
tx.y = 4
dotsDrawable.drawFrame({tx tx2});
pause(delay);
```
This final block is simply closing the drawing window. If you accidentally run a script without a call to close the screen or it crashes but doesn't exit the drawing window you can type in the below code to exit out. mglClose() will also work.
```
dotsTheScreen.closeWindow();
```


***
```
function moddedDrawableText(delay)

if nargin < 1
delay = 2;
end

tx = dotsDrawableText();
tx2 = dotsDrawableText();

tx.string = 'Juniper juice';
tx2.string = 'hello';

tx.color = [0 128 64];
tx2.color = [250 25 250];

dotsTheScreen.openWindow();

dotsDrawable.drawFrame({tx});
pause(delay)

dotsDrawable.drawFrame({tx2});
pause(delay)

tx.isVisible = false;

dotsDrawable.drawFrame({tx});
pause(delay)

tx.isVisible = true;
tx.y = 4;

dotsDrawable.drawFrame({tx tx2});
pause(delay);

dotsTheScreen.closeWindow();
```Building a sample experiment

*Part 2*
```
function drawableMouse()
```
In this next section we will be learning how to create an object that can be manipulated by the mouse. Snow Dots has scripts designed to read HID(Human Interface Device) data from a variety of input devices.

This first three lines of code are simply clearing the command window, clearing any variables, and telling the Screen to refresh itself. Most importantly the final line is also telling the Screen to open up in a small window instead of full screen. This is useful for debugging purposes. 

 - For reference, 0-debug, 1-full screen, 2-secondary screen.

```
clc;
clear all;
dotsTheScreen.reset('displayIndex', 0);
```
First we will create the object that will represent our mouse when the drawing screen is up. 
```
MouseDot = dotsDrawableVertices();
```

If we opened a draw screen we'd find a small dot in the center of the screen. Lets increase the size first. 
```
MouseDot.pixelSize = 10;
```
Now you should see a white square in the center of your screen. 
```
dotsTheScreen.openWindow;
dotsDrawable.drawFrame({MouseDot});
pause(2);
dotsTheScreen.closeWindow;
```

This simple white square will be used to represent the mouse when the drawing window is open.  Of course, we will need to add some additional code to wire together our mouse and this object.

Fortunately for us, Snow Dots can easily read from most input devices. In our case we will be using [dotsReadableHIDMouse.m](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableHIDMouse.m) Like our visual objects, we must first create an object.
```
compMouse = dotsReadableHIDMouse();
```
If you type the above code into the command window without the semi-colon at the end you can see all the various properties that this function contains and automatically retrieves from the mouse.

Now we will need to wire together the properties of compMouse and our target. We will do this by setting the x and y position of our target equal to the x and y position of compMouse, our object that represents the mouse.  

The first line is simply a method within dotsReadable, the superclass for all readable devices, that tells Matlab to get the newest device data. The second line is a familiar one at this point, we are using a method within dotsDrawable to draw our target. The third and fourth line are setting the x and y position of our target, MouseDot, equal to our mouse object, compMouse. 
```
compMouse.read();    
dotsDrawable.drawFrame({MouseDot});
MouseDot.x = compMouse.x
MouseDot.y = compMouse.y;
```
Of course it doesn't do us much good to only have this occur once. The process of reading the mouse needs to be continual, as does the process of updating the target positions. For this we can set up a simple while loop that we can break easily.
```
while MouseDot.x <= 42
    
    compMouse.read();    
    dotsDrawable.drawFrame({MouseDot});
    MouseDot.x = compMouse.x;
    MouseDot.y = compMouse.y;
end


```
All this loop is doing is saying that for as long as the x-position of our target is below 42,  we will continue to read new data from the mouse, draw our target, and change the x and y position of our target.

Running this code below will let you see the completed process so far.

```
function drawableMouse()
clc;
clear all;

dotsTheScreen.reset('displayIndex', 0);

MouseDot = dotsDrawableVertices();
MouseDot.pixelSize = 10;

compMouse = dotsReadableHIDMouse();

dotsTheScreen.openWindow;

while MouseDot.x <= 42
    
    compMouse.read();    
    dotsDrawable.drawFrame({MouseDot});
    MouseDot.x = compMouse.x;
    MouseDot.y = compMouse.y;
end
dotsTheScreen.closeWindow;  
```

As you might have noticed, our target moves very aggressively (and our y-postion is inverted). We will need to calibrate our mouse settings to smooth things out a bit. Fortunately Snow Dots provides us with a simple way to achieve this. 

This first line is simply setting xAxis (this could be called anything but its easy to see that you are getting the x component) equal to the the first structure in compMouse.components. The 5 component structures of the mouse object (compMouse) are the x-y axis and buttons (the scroll wheel click is the 5th button) on our mouse. The second line is using a built-in Snow Dots method that resides in [dotsReadableHID.m](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/master/snow-dots/classes/readable/dotsReadableHID.m).  The fourth argument is our calibration argument. You can look at dotsReadableHID file directly to find out what other input arguments are available. If you change the 1s to a higher number you will find the target moves smoothly but just a bit faster. This can be useful for fine tuning an experiment.
```
xAxis = compMouse.components(1);
compMouse.setComponentCalibration(xAxis.ID, [], [], [-1 1]);
    
yAxis = compMouse.components(2);
compMouse.setComponentCalibration(yAxis.ID, [], [], [-1 1]);
```

The final part is simply correcting the y-positioning. To do that we will just add a "-" to compMouse.y.

The final code is posted below. Simply copy and paste that and you will have a working movable target.


----------
```
function drawableMouse()

clc;
clear all;

dotsTheScreen.reset('displayIndex', 0);

MouseDot = dotsDrawableVertices();
MouseDot.pixelSize = 10;

compMouse = dotsReadableHIDMouse();

xAxis = compMouse.components(1);
compMouse.setComponentCalibration(xAxis.ID, [], [], [-1 1]);
    
yAxis = compMouse.components(2);
compMouse.setComponentCalibration(yAxis.ID, [], [], [-1 1]);

dotsTheScreen.openWindow;

while MouseDot.x <= 42
    
    compMouse.read();    
    dotsDrawable.drawFrame({MouseDot});
    MouseDot.x = compMouse.x;
    MouseDot.y = -compMouse.y;
end

dotsTheScreen.closeWindow;
```    Building a sample experiment

*Part 3*

In this next section we will look at how to increase user-computer interactivity. Specifically, lets make the mouse do something when we click a button. In this case, we will create a second way to exit the drawing window if the left mouse button is clicked.

For convenience we will use the same code as before to generate our mouse object and calibrate it. 

```
function drawableMouse()
clc;
clear all;

dotsTheScreen.reset('displayIndex', 0);

MouseDot = dotsDrawableVertices();
MouseDot.pixelSize = 10;

compMouse = dotsReadableHIDMouse();

xAxis = compMouse.components(1);
compMouse.setComponentCalibration(xAxis.ID, [], [], [-1 1]);
    
yAxis = compMouse.components(2);
compMouse.setComponentCalibration(yAxis.ID, [], [], [-1 1]);
```

The new addition to this code will come at bottom. The first line is simply setting a variable to the third structure in the components structure list of our mouse. The same as before with the x and y manipulations. The second line is using a built in method of dotsReadable.m.  It defines the event of interest for one of the input components. The arguments are as follows:

 1. One of the integer IDs in components
 2. String name for an event of interest
 3. The lower bound on the event of interest
 4. The upper bound on the event of interest
 5. Whether to invert event detection logic
```
click = compMouse.components(3);
compMouse.defineEvent(click.ID,'press',1,1,false)
```
The min and max values of a mouse button are 0 and 1 (the mouse can only be unclicked or clicked, unless you have a fancy pressure-sensitive mouse). The default sate is 0, unclicked. When we click we set the value to 1. When the value reaches 1, within our range of interest as defined by arguments 3 and 4, we are saying the Event 'press'  has occurred. If we set the final argument to "true" the 'press' event is constantly occurring and only by clicking would we shut it off.

We are also going to create an additional Event that relies on the X Axis. The event will fire if the x-position of the mouse falls into the range of 1-10.
```
compMouse.defineEvent(xAxis.ID,'hello!',1,10,false)
```

Now that we have set out event definitions, lets move back into the while loop.

For now we will keep the exit option the same as before, X simply needs to stay below a certain threshold. Our newest line is the getHappeningEvent() method. This method can be found in the dotsReadable.m file. The four output arguments are:

 1. The name of the last event that has occurred. ('press')
 2. The component ID assigned to the last event that has occurred ('4')
 3. A cell of all the names the event that are occuring at that moment {'hello!' 'press'}
 4. An array of the component IDs that assigned to the events that are occurring at that moment [4 13]

```
while MouseDot.x <= 42
    
    compMouse.read();    
    dotsDrawable.drawFrame({MouseDot});
    MouseDot.x = compMouse.x;
    MouseDot.y = compMouse.y;
    [lastName, lastID, names, IDs] = compMouse.getHappeningEvent();
    if strcmp(lastName,'hello!');
        disp('There')
    end
    if strmatch('press', names);
        MouseDot.x = 43;
    end    
end
```

There are a couple of important things to take notice in this code block. The first 'if' statement is only checking to see if the last thing that occurred was the 'hello!' named event. This is fine if you only have one output argument expected. However, if strcmp was used for the 'press' event, it would not work if the 'hello' event were already underway.  strmatch is checking the third output argument, names, to see if any of the cell's contents match the name.  This way, even if 'hello!' is underway, the while loop can still be closed with a click. 
> Although you can set the 'press' event to close the screen, it is unwise to do so without closing the loop. Matlab will continually throw errors as it tries to display content on a drawing screen that no longer exists. 

A complete version of the discussed code can be found below. 


----------
```
function drawableMouse()
clc;
clear all;

dotsTheScreen.reset('displayIndex', 0);

MouseDot = dotsDrawableVertices();
MouseDot.pixelSize = 10;

compMouse = dotsReadableHIDMouse();

xAxis = compMouse.components(1);
compMouse.setComponentCalibration(xAxis.ID, [], [], [-1 1]);
    
yAxis = compMouse.components(2);
compMouse.setComponentCalibration(yAxis.ID, [], [], [-1 1]);

click = compMouse.components(3);
compMouse.defineEvent(click.ID,'press',1,1,false)

compMouse.defineEvent(xAxis.ID,'hello!',1,10,false)

dotsTheScreen.openWindow;

while MouseDot.x <= 42
    
    compMouse.read();    
    dotsDrawable.drawFrame({MouseDot});
    MouseDot.x = compMouse.x;
    MouseDot.y = compMouse.y;
    [lastName, lastID, names, IDs] = compMouse.getHappeningEvent();
    if strcmp(lastName,'hello!');
        disp('There')
    end
    if strmatch('press', names);
        MouseDot.x = 43;
    end    
end
dotsTheScreen.closeWindow;    
```