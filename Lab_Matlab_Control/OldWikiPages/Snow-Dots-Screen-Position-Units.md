Typically a screen is measured using its resolution. For instance, a 27inch 1440p monitor may have a screen resolution of 2560 x 1440. So an XY location of (1280,720) would correspond to the center of the screen. However, Snow Dots does not use these measurements for it's positioning. Instead you'll find that the center of the screen is identified as (0,0). The max width and height of the Snow Dots drawing window is relative to the screen and the type of drawing window open(display index- 0,1,2). To find this information you would use 
```
mglGetParam
```
> Caution! If you have recently used clear all, mglGetParam will display nothing. A drawing window needs to have been opened once to grab the screen info. In the below examples you will notice that we open the drawing window before using mglGetParam.

The output will look something like this
```
MGL = 

                       version: 2
                 displayNumber: -1
        persistentParamsLoaded: 1
          screenParamsFilename: '~/.mglScreenParams'
                    displayDir: '/Users/joshuagold/mgl/task/displays'
             ignoreInitialVols: 0
                    mustSetSID: 0
                  writeTaskLog: 0
                 multisampling: 1
                 matlabDesktop: 1
                        useCGL: 1
                       verbose: 0
            matlabMajorVersion: 8
            matlabMinorVersion: 1
                 isCocoaWindow: 0
            originalResolution: [1x1 struct]
                     GLContext: 0
                   screenWidth: 2560
                  screenHeight: 1440
                   stencilBits: 8
               xPixelsToDevice: 0.0152
               yPixelsToDevice: 0.0152
               xDeviceToPixels: 65.6586
               yDeviceToPixels: 65.6586
                   deviceWidth: 38.9896
                  deviceHeight: 21.9316
                  deviceCoords: 'visualAngle'
                    deviceRect: [-19.4948 -10.9658 19.4948 10.9658]
                     frameRate: 59
                      bitDepth: 32
             initialGammaTable: [1x1 struct]
             screenCoordinates: 0
              deviceHDirection: 1
              deviceVDirection: 1
                   numTextures: 0
                        sounds: []
                    soundNames: {}
                     displayID: 1
       visualAngleSquarePixels: 1
    visualAngleCalibProportion: 0.5000
        devicePhysicalDistance: 2
            devicePhysicalSize: [1 1]
                  deviceOrigin: [0 0 0]
```
This will display the current screen information. The information we are looking for is under deviceRect. 
```
deviceRect: [-19.4948 -10.9658 19.4948 10.9658]
```
The information displayed here corresponds to the leftmost x-axis unit, bottommost y-axis unit, rightmost x-axis unit, and topmost y-axis unit. Lets say you wanted to create two lines that divide the screen into four boxes. Instead of using trial and error (or just putting in a big number to go way beyond the viewable screen) you can use the deviceRect information to reach the edges. Copy and paste this code into Matlab to see an example.

```
clc;
clear all;

% Creating our screen object
sc = dotsTheScreen.theObject;
% Full screen display index
sc.displayIndex = 1;
% Open our drawing window
sc.open;

edges = mglGetParam('deviceRect');

% Defining our edges
Leftedge = edges(1);
Bottomedge = edges(2);
Rightedge = edges(3);
Topedge = edges(4);

% Horizontal line
Hline = dotsDrawableLines;
Hline.xFrom = Leftedge;
Hline.xTo = Rightedge;
Hline.yFrom = 0;
Hline.yTo = 0;

% Vertical line
Vline = dotsDrawableLines;
Vline.xFrom = 0;
Vline.xTo = 0;
Vline.yFrom = Bottomedge;
Vline.yTo = Topedge;

% Draw the lines
dotsDrawable.drawFrame({Hline Vline});
%Pause for 2 seconds to let us view the lines.
pause(2);
% Close Window
sc.close;
```

You should see the screen split into four boxes. Defining variables for the screen edges can be useful when trying to properly place objects. Instead of having to figure out the correct numbers for placing a target object at an exact location, you can use the edge variables. For example, lets say we want to place a target in the middle of the upper-right quadrant. 
```
clc;
clear all;

% Creating our screen object
sc = dotsTheScreen.theObject;
% Full screen display index
sc.displayIndex = 1;
% Open our drawing window
sc.open;

edges = mglGetParam('deviceRect');

% Defining our edges
Leftedge = edges(1);
Bottomedge = edges(2);
Rightedge = edges(3);
Topedge = edges(4);

% Horizontal line
Hline = dotsDrawableLines;
Hline.xFrom = Leftedge;
Hline.xTo = Rightedge;
Hline.yFrom = 0;
Hline.yTo = 0;

% Vertical line
Vline = dotsDrawableLines;
Vline.xFrom = 0;
Vline.xTo = 0;
Vline.yFrom = Bottomedge;
Vline.yTo = Topedge;

% Target
Target = dotsDrawableVertices;
Target.x = Rightedge/2;
Target.y = Topedge/2;
Target.pixelSize = 20;

% Draw the lines
dotsDrawable.drawFrame({Hline Vline Target});
%Pause for 2 seconds to let us view the drawings.
pause(2);
% Close Window
sc.close;
```
It's simple to do the math that lets us place the target exactly where we want. An additional benefit is that object placement will stay consistent across different screens. For example, if you change display index to 0, a smaller drawing window will appear with the target still centered in the upper-right quadrant. If type in mglGetParam('deviceRect') into your command window after opening up the smaller drawing window you can see how the screen units have changed. On the computer this is being typed on I get:
```
deviceRect: [-16.3756 -12.2817 16.3756 12.2817]
```
It's interesting to note that the y-units are larger than the y-units on the full screen despite the actual drawing window clearly being smaller. 
