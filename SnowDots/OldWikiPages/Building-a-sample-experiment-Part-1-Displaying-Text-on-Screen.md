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
```