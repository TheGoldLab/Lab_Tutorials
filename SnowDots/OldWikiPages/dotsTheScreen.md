# dotsTheScreen

dotsTheScreen is used for setting up your monitors mgl display profile and calling the drawing screen to open during an experiment. dotsTheScreen is a sub-class of dotsAllSingletonObjects. A default profile is created using dotsTheMachineConfiguration. 

If you create a new script and enter in the code 
```
sc = dotsTheScreen.theObject
sc.open;
pause(2);
sc.close;
```

What you should see is a small black rectangle appear on screen for 2 seconds. This is because the default property value of displayIndex is set to 0, a useful setting for debugging purposes. More on properties below.

## Properties
### width (cm)
* Width is your display width measured in centimeters

### height (cm)
* Height is your display height measured in centimeters
        
### distance (cm)
* Display distance is the distance that the user is assumed to be sitting away from the computer screen. 
        
### displayIndex
* The displayIndex can either be 0, 1, or 2. 
* * 0 will open a small rectangle on your screen. 
* * 1 will open the current drawing window to the full size of your primary display monitor.
* * 2 is used to display a drawing window on a second display screen.
        
### displayPixels
* displayPixels is a rectangle that represents the display in pixels. The arguments are [0 0 width height]. So if you had a monitor that was 1440p with a width of 59.6 and height of 33.6, you'd expect a pixel density of [0 0 2560 1440] 
        
### bitdepth
* The color depth of each pixel as measured in the number of [bits](https://en.wikipedia.org/wiki/Color_depth).        
        
### multisample       
* whether or not to use mgl full-scene antialiasing
        
### windowRect
* pixel dimensions of the current drawing window [x y x2 y2]. Generally this will be set by displayIndex to either the size of a small drawing window rectangle (display index = 0, windowRect would then be 800 x 600) or full screen window (display index = 1)

        
### windowFrameRate;
The refresh rate for the current screen as measured in Hz. The screen refreshes this many times in a second. This number will almost always be either 59,60, or 144.

### pixelsPerDegree
* Approximate conversation factor for the current display. This number is relevant to the display distance in setting up where exactly the visual images will appear on screen in relation to a subjects eye. There is more to it, but that is beyond the scope of this wiki page.

### foregroundColor        
* foregroundColor is the color of the drawing screen foreground. Arguments are [0-255 0-255 0-255] or [0-1 0-1 0-1] depending on how your gamma table is set up.
        
### backgroundColor
* backgroundColor is the color of the drawing screen background. Arguments are [0-255 0-255 0-255] or [0-1 0-1 0-1] depending on how your gamma table is set up. The example below should display a red drawing window.
```
sc = dotsTheScreen.theObject
sc.backgroundColor = [255 0 0];
sc.open
pause(2);
sc.close;
```        
### clockFunction       
* Simple returns the current time as measured by mglGetSecs. 
        

### gammaTableFile
* a gammeTableFile is a file that contains a gamma table. Default values are used if a gamma calibration has not been done using an optical device. A custom gamma table can be used by simply including the filename as the argument. On the computer being used to type this wiki the GammTable is simply 'dots_hntvlan554_GammaTable.mat'. 

## Static methods

These static methods can be used to access the current state of your dotsTheScreen configuration.These methods can be accessed either using the screen variable or by direct access.

### function obj = theObject(varargin)

This function is used to create a screen object. As seen in the examples below you would use this to create a Matlab variable that can be used to open or close the Screen.

```
sc = dotsTheScreen.theObject
```
### function reset(varagin)
Restores the current instance to a fresh state.

### function g = gui()
This function simply allows you to check the parameters of your drawing window in a gui. Its the same information as if you simply typed in "sc" or "dotsTheScreen.theObject" into the command window.
```
sc.gui();
```
or
```
dotsTheScreen.gui();
```
### function hostFile = getHostGammaTableFilename()
This function grabs the GammaTable that is currently being used by the computer. If there isn't any, it will use default settings and give the name of the default hostname.
```
hostname = sc.getHostGammaTableFilename()
```
will return
```
hostname = dots_hntvlan554_GammaTable.mat
```

### function displayNumber = getDisplayNumber()
Returns the display used for drawing IF a drawing window is currently open. Otherwise it will return "-1"

### function openWindow()
Opens the screen. Again, this can be used with either your display variable or directly accessed.
```
dotstheScreen.openWindow()
```
should open the same window as
```
sc.openWindow()
```

### function closeWindow()
Closes the display window. The same applies for closeWindow as openWindow

## Methods

These non-static methods can only be accessed when dotsTheScreen.theObject is assigned to a variable. For the examples below we will have
```
sc = dotsTheScreen.theObject
```


### function initialize(self)

This will reset the current window to a fresh state, closing the window.

### function open(self)
This will open a drawing window.
```
sc.open();
```

### function close(self0
This will close the drawing window.
```
sc.close();
```

### function frameInfo = nextFrame(self, doClear)

This function flushes the drawing commands and swaps frame buffers. If doClear is false it should allow future drawings to accumulate as they are not cleared after each frame. Generally this function will not be manipulated directly. As most of the drawing commands in drawables access this method or call for their own frame swaps, using say sc.nextFrame(false) will not work. If you'd like let drawable objects accumulate on screen, there are easier ways to control this property. However, keeping objects on screen by simply not clearing the buffer can cause objects to flicker. It is not an advisable method. 

### function frameInfo = blank(self)

This function is to let the frame buffers swap twice without drawing. This function calls for a clear of the frame buffers and will cause any previous drawing commands to be processed but not shown. Similar to the function nextFrame, there can be conflicts between drawing commands that take it upon themselves to manipulate the frame buffers. There are easier ways to clear the screen. 

### function gammaTableToMatFile(self, fileWithPath)
This saves gamma-correction data in stimulusGammaTable to a .mat file. The fileWithPath tells the function where to save the gamma table. The gamma table also seems to take the name of end file pathway. So in this case you should see a file named blah.mat.

```
sc.gammaTableToMatFile('Users/Matlab/blah/')
```


### function gammaTableFromMatFile(self, fileWithPath)
Loads gamma-correction data from a .mat file into stimulusGammaTable. If you check out your current gamma file it should probably be something to the effect of dots_computername_gammaTable.mat. If you use the command
```
sc.gammaTableFromMatFile('User/Matlab/blah/');
sc
```
you will see that the new gammaTableFile has been loaded.

 
