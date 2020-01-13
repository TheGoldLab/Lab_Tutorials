Building a sample experiment

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