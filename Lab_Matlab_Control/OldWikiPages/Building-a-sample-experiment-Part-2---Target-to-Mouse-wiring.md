Building a sample experiment

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
```    