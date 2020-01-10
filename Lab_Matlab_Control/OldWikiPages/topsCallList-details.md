topsCallList is a list of functions to call as a batch. It expects functions to be "fevalable." It uses cell arrays that have function handles as the first element and a name for that call as the second element. This is based off of Matlab's built in feval function. For instance, 
```
feval(@disp, 'hello')
```
 would display the word 'hello' in the command window.

We will begin by creating our script header and some function handles
```
function CPdemoCallList()
hello = {@disp, 'Hello.'};
pardon = {@disp, 'Pardon me?'};
goodbye = {@disp, 'Goodbye.'};
fevalabletobecalled = {@disp, 'This is the fourth call.'};
```
The elements to the left of the equal sign are the function handles. The two elements to the right of the equal sign are 1) the function 2) the input argument.

The Call List calls a bunch of functions as a batch. Lets create a topsCallList.
```
function index = addCall(self, fevalable, name)
```
```
calls = topsCallList('call functions');
calls.addCall(hello, 'say hello');
calls.addCall(pardon, 'say pardon');
calls.addCall(goodbye, 'say goodbye');
calls.addCall(fevalabletobecalled, 'This is the NAME of the fourth call');
```
The input argument string is optional. It will help you organize better if you can quickly reference the general purpose of any particular call list. The call list will keep running if we don't set it to stop. One of the properties of topsCallList is alwaysRunning. We want to set this to false.

```
calls.alwaysRunning = false
```
Now we will run through the call list. We will clear the command window with and then tell the call list we created, call, to run.
```
clc();
calls.run();
```

You should see the command window display "Hello." "Pardon me?" "Goodbye." "This is the fourth call." In this case we were invoking calls to run using the method from the superclass topsRunnable. topsCallList has its own method of running and invoking all the active calls through its RunBriefly method. If you delete or comment out 
```
calls.alwaysRunning = false;
calls.run();
```
and input 
```
calls.runBriefly();
```
and run your script, you should see the same text display as before.

***

# Additional Methods of topsCallList
topsCallList has a few other methods built into it's script to help manipulate your function calls. For instance, you may want to go through your call list but EXCLUDE a certain call from being called. In this case you would use the 
***

## function setActiveByName(self, isActive, name)

isActive takes a true or false as an input and name is looking for the name of your call. Let see an example:
```
calls.setActiveByName(false,'say goodbye');
```
If you paste that line into your code before any run command you should see the same Command Window display as before except the line "Goodbye" should not appear.
***

## function result = callByName(self, name, isActive)

This function will invoke a call, whether it is active or not. name is looking for the name of your call and isActive is setting the call to an active or inactive state AFTER it has been run with this function. callByName will cause the call to runBriefly when used, so you do not necessarily need to add run() or runBriefly() when setting up this function. First we will use callByName to invoke one call in our list.
```
calls.callByName('say goodbye')
calls.runBriefly();
```
You should see in the display "Goodbye." appear before "Hello." in addition to after "Pardon me?". If you deleted "calls.runBriefly();" you would just see the "Goodbye." text displayed. Now lets add a second input argument to callByName.
```
calls.callByName('say goodbye',false)
calls.runBriefly();
```
In this case you will see "Goodbye" appear before "Hello." but it will be absent from its normal position after "Pardon me?".

callByName has one output argument. In order to see this we will have to add an additional call to the call list. With your original function handle creations add
```
sinstuff = {@sin, 3};
```
In the addCall section of code put
```
calls.addCall(sinstuff, 'sinny');
```
Finally at the end you should add 
```
results = calls.callByName('sinny')
```
This will create the variable "results" and set it equal to 0.1411