The purpose of this demo is to give a simple demonstration of how to define, read, and display user keyboard events while showcasing some of the tools of SnowDots.
```
function typetest
clc;
clear all;

tic;
timekeeper = 0;
kb = dotsReadableHIDKeyboard();
IDs = kb.getComponentIDs();
    for ii = 1:numel(IDs)
        kb.defineEvent(IDs(ii),kb.components(ii).name, 0, 0, true);
    end
kb.isAutoRead = true;
letter = dotsDrawableText;
dotsTheScreen.openWindow;
while timekeeper <= 20    
    dotsDrawable.drawFrame({letter}, false);
    name = kb.getNextEvent();
    
    if strmatch('Keyboard',name)  & (length(name) == 9)
        letter.string = name(9);
        letter.x = letter.x + 1.5
    end
    if strcmp('KeyboardReturnOrEnter',name)
        letter.y = letter.y + -2;
        letter.x = 0;
        letter.string = '';
    end
    if strcmp('KeyboardLeftShift',name)
        letter.y = letter.y + 2;
        letter.x = 0;
        letter.string = '';
    end
    timekeeper = toc;
end
dotsTheScreen.closeWindow; 
```

We use tic to begin timing our script. We define timekeeper and set it to 0. timekeeper will be set to toc and will be used to end our script. 

First we will create a variable and set it equal to our dotsReadableHIDKeyboard class
```
kb = dotsReadableHIDKeyboard();
```
The convient aspect of SnowDots is that different input device classes are all built off of the greater dotsReadable and dotsReadableHID classes, so they share most of the same properties and understanding one makes it easy to understand another.

Now we well get the component IDs for the keyboards different components. 
```
IDs = kb.getComponentIDs();
```
This will return a 1x180 matrix (this may vary depending on the individual keyboard) with different numbers that correspond to each button on the keyboard. 

Using this we can use a for loop to define an event for each keyboard stroke.
```
    for ii = 1:numel(IDs)
        kb.defineEvent(IDs(ii),kb.components(ii).name, 0, 0, true);
    end
```
So for elements 1 through the number of elements (numel) in IDs we will use the dotsReadable function defineEvent to create an individual event for each button press on the keyboard. Finally we will set AutoRead to true, which will allow the dotsReadable getNextEvent function to read our input. Although getNextEvent will read our input when AutoRead is true, not all dotsReadable functions will read our input through this method. Sometimes the read function (like kb.read()) will need to be continually called in order for a dotsReadable function to perform its duty. 
```
kb.isAutoRead = true;
```

We will create our drawable text object
```
letter = dotsDrawableText
```
No other modification need to be made to our drawable text object, the default properties will be fine for now.
Now we will open our screen
```
dotsTheScreen.openWindow;
```
We will create a while loop and run it for 20 seconds using our variable a (standing in for toc since toc will always display the elapsed time in the command window if it's used alone)
```
while timekeeper <=20
```
Now we will tell Matlab to continually draw a new frame for our drawable text object "letter".
```

dotsDrawable.drawFrame({letter}, false);
```
dotsDrawable.drawFrame actually can take two inputs, one is the drawables that we wish to draw and the other is if it should clear the screen after each frame. You can actually have drawn objects accumulate on screen without having to actually store them in some capacity. This is not advisable to use in a real experiment, especially as objects will sometimes flicker while on screen, but for this demo's purpose it is fine.

We will then use the getNextEvent function of dotsReadable to get the next event. There are a few ways to have your experiment listen and get user input but getNextEvent is useful in that it only reads the next queued event. Using the wrong input function can sometimes result in receiving too much input from a keyboard press causing multiple events to fire (like hitting the "w" button and having it display multiple "w"s on screen or having a mouse click be read multiple times). We will set one of getNextEvent's output arguments equal to name and use that for a string comparison.

```
name = kb.getNextEvent()
```
Now that we have our events defined and a process set up for reading our inputs we want the screen to display only the key we press and move to the next position. We can do this using an If statement. 
```
    if strmatch('Keyboard',name)  & (length(name) == 9)
        letter.string = name(9);
        letter.x = letter.x + 1.5;
    end
```
strmatch is looking to see if any of the strings within the first argument 'Keyboard' match any in the second argument 'name'. Using strmatch any letter in Keyboard will actually work but it's a better idea to use the whole word to avoid any confusion. We also don't want to include any none letter keypresses. It would be better practice to undefine any key presses that we don't wish to use, but for the sake of this demo we will simply exclude them by using a length comparison.

 The name output argument of kb.getNextEvent returns values such as "KeyboardC" or "KeyboardReturnOrEnter". All of the letter inputs will have a length of only 9 characters. We are making sure we have an input with the correct length and then setting the string of our letter drawable text object to the 9th character within the name output argument. This corresponds to the letter pressed on the keyboard. The final statement of this if-end is increasing the x position of our letter drawable text object further to the right so that the letters don't completely overlap.

The next two If statements are simply shifting the y position of the letter variable so that we can move up or down a line. As you can see, we are using strcmp to make sure we get an exact match with our name variable. Additionally, there is no more need for any sort of length discrimination. Finally, it is important to note that letter.string is being set to an empty string ('') so that the previously typed letter does not appear again when Enter or LeftShift is pressed. 
```
    if strcmp('KeyboardReturnOrEnter',name)
        letter.y = letter.y + -2;
        letter.x = 0;
        letter.string = '';
    end
    if strcmp('KeyboardLeftShift',name)
        letter.y = letter.y + 2;
        letter.x = 0;
        letter.string = '';
    end
```

The last three lines of code will set the variable timekeeper to toc, end our while loop, and close our drawing screen.

```
timekeeper = toc;
end
dotsTheScreen.closeWindow;
```
To reiterate, the purpose of this demo was to give a simple demonstration of how to define, read, and display user input events while showcasing some of the tools of SnowDots. Collecting user input, displaying it, and having it influence the course of an experiment would require additional set-up. 