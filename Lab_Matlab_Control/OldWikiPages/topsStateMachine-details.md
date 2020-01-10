topsStateMachine is used for controlling the flow of an experiment using predefined states. It is a vital component for controlling your experiment. 

Lets start by simply observing it's basic behavior. First let's add some fevalables. We will use the same ones as in topsCallList details.

```
function CPdemotopStateMachine
```
```
hello = {@disp, 'Hello.'};
pardon = {@disp, 'Pardon me?'};
goodbye = {@disp, 'Goodbye.'};
```
Now we will create an object "machine" and set it to be equal to a topsStateMachine class. There is an optional string you can add, in this case it is 'traverse states', to help you keep track of what each StateMachine is doing. 
```
machine = topsStateMachine('traverse states');
```
Now we will create a stateList and add our various fevalables to this stateList. The top row of our stateList is our stateFields, a brief explanation will follow the code with a more detailed explanation further down this page.
```
stateList = { ...
    'name',     'entry', 'timeout',     'next'; ...
    'first',    hello,      0.1,        'second'; ...
    'second',	pardon,     0.1,        'third'; ...
    'third',    goodbye,    0.1,        ''; ...
    };
```
stateFields:
* **name** is a unique name to identify the state.
* **entry** is the fevalable cell array invoked when entering the state.
* **timeout** is time that may elapse before transition to the next state.
* **next** is the next state the machine will transition to.

Next we will add the stateList to the machine object using
>```
>function addMultipleStates(self, statesInfo)
>```
 contained within topsStateMachine
```
machine.addMultipleStates(stateList);
```
Finally, we will add some code to run the machine and transition through it's states.
```
clc();
machine.run();
```
Run your function.
In your command window, you should see "Hello." "Pardon me?" and "Goodbye."

***
## stateFields
topsStateMachine has a number of stateFields available for use. The information here can also be found in the properties section of topsStateMachine. 
```
stateFields = {'name', 'next', 'timeout','entry', 'input', 'exit', 'classification'};
```
The stateFields also have stateDefaults in their properties
```
stateDefaults = {'', '', 0, {}, {}, {}, []};
```
COMMON ERROR: If a particular state does not have an parameter for a stateField (e.g. no entry fevalable for the 'entry' stateField) , you MUST put in the stateDefault that corresponds to that stateField. However, if a stateField does not exist for a stateMachine, the defaults will automatically be applied to that state (e.g. exit does not exist in the basic example above but there is no error message). A common error is to forget to add a cell bracket or 0 to a particular state, which will throw the whole code out of alignment and is sometimes difficult to spot when stateLists get bigger. If you see this error: 
```
Error using vertcat
Dimensions of matrices being concatenated are not consistent.
Error in YourExperiment (line x)
stateList = { ...
```
that is probably what has occurred.  
***

Now we will take a more in-depth look at the various stateFields.
* **name** is a unique name to identify the state.
* **entry** is the fevalable cell array invoked when entering the state.
* **timeout** is time that may elapse before transition to the next state.
* **next** is the next state the machine will transition to.
* [**input**](#input-Example) is input fevalable cell array invoked after entering the state, during each call to run.  If the returned value is the name of a state, transitions to that state immediately. 
* **exit** is a fevalable cell array invoked when exiting the state
* **classification** topsClassification object to query after entering the state, during each call to run.  If the returned output is the name of a state, transitions to that state immediately. topsClassification is another Tower of Psych class that deals with assigned spatial fields on the screen.

#### input Example
```
function CPdemoinputstate()

hello = {@disp, 'Hello.'};
pardon = {@disp, 'Pardon me?'};
goodbye = {@disp, 'Goodbye.'};
userinput = {@saysomething};

machine = topsStateMachine('traverse states');
stateList = { ...
    'name',     'entry',	'timeout', 'input', 'next'; ...
    'first',    hello       0.1,        userinput, 'second'; ...
    'second',	pardon,     0.1,        {},  'third'; ...
    'third',    goodbye,    0.1,        {}, ''; ...
    };
machine.addMultipleStates(stateList);

clc();
machine.run();

function out = saysomething()
out = input('','s');
```
As you can see, there are a few new lines included in this example.
First we added a function handle userinput that is calling the function saysomething()
```
userinput = {@saysomething};
```
In the stateList we have included the stateField 'input' and have added userinput into the appropriate field place, making sure to add empty brackets to the states 'second' and 'third.'

Finally we created the saysomething function.
```
function out = saysomething()
out = input('','s');
```
The function is simply asking for a user to enter in some text. The output is the variable out. This will then be displayed in the Command Window with the rest of the states. As mentioned above, if the output is a state name then the machine will transition to that next slide. You can try it yourself by entering 'third' (without quotation marks) when prompted. The state named 'second' will be skipped over.

It's not always necessary to create a function handle for the stateFields that are looking for fevalables. If you delete userinput from the 'first' state's 'input' stateField and replace it with {@saysomething} the machine will handle itself the same way as before.

It's important to note that although the timeout stateField is set to 0.1 seconds, the machine will not transition until an input is entered. While this gives a greater ability to control the flow of an experiment, as an experiment script grows larger the timing of the script and various moving parts may get somewhat complicated. It's important to stay aware of how the script "flows" when run. 
***

# Additional methods of topsStateMachine

The following function explanations and examples require the below code before running.
```
function CPdemoStateMachine()

hello = {@disp, 'Hello.'};
pardon = {@disp, 'Pardon me?'};
goodbye = {@disp, 'Goodbye.'};
userinput = {@saysomething};

machine = topsStateMachine('traverse states');

stateList = { ...
    'name',     'entry',	'timeout', 'input', 'next'; ...
    'first',    hello              0.1,        {}, 'second'; ...
    'second',	pardon,            0.1,        {},  'third'; ...
    'third',    goodbye,           0.1,        {},    ''; ...
    };
machine.addMultipleStates(stateList);
clc();
machine.run();
```

##  function index = addState(self, stateInfo)

This function allows you to add individual states to your StateMachine. You can add additional stateFields to this new state. If a stateField is omitted, but already exists within your stateMachine, a default value will be used. Add the following code anywhere after the machine.addMultipleStates(stateList) line of code

```
surprise.name = 'surprise';
surprise.next = 'third';
message = sprintf(' ---\n You found the secret state!\n ---');
surprise.entry = {@disp, message}; %You can also add a function handle here like the other states.
machine.addState(surprise);
```

Here we added a state with the name surprise. The stateField 'timeout' has not been included, so the default value of 0 will be used automatically. As nothing in the stateMachine currently points towards the 'surprise' state, running the stateMachine will not display the message. If you put the userinput handle into the 'input' stateField of any of the states you can enter in the name of the state 'surprise'(no quotations) and the stateMachine will transition to the new 'surprise' state. If you notice, we have surprise.next pointing to the 'third' state in your StateMachine. This means that upon completion the 'surprise' state will transition to the 'third' state. If you leave this field with empty '' marks, the StateMachine will stop running after displaying the surprise message. 

## function index = editStateByName(self, stateName, varargin)

This function allows you to edit the stateField parameters of a given state. The first input argument stateName is asking for the name of the state you want to edit. Using our previous machine, it could 'first','second',or 'third'. Be sure to INCLUDE the quotations marks when entering in the stateName. The second input argument allows for a variable amount of arguments to be included. It is looking for arguments that will alter the states stateField properties. The format it is looking for is (stateField, newvalueofstateField). So for example we add a new state to our stateList the "normal" way. You can use the code below.  
```
stateList = { ...
    'name',     'entry',	'timeout', 'input', 'next'; ...
    'first',    hello       0.1,        {}, 'addition'; ...
    'addition', {}          0.1,        {}, 'second'; ...
    'second',	pardon,     0.1,        {},  'third'; ...
    'third',    goodbye,    0.1,        {}, ''; ...
    };
```
We added an 'addition' state to our stateList. It currently does nothing besides add a small 0.1 second delay. Now let us use the editStateByName function.
```
machine.editStateByName('addition', 'timeout',5)
```
If you add that code anywhere before the machine runs, it should work. What you will see is that there is now a 5.1 ('first' states timeout value + additions new timeout value) second delay between displaying the 'first' states message and the 'second' states message. For clarity, we will add a second change to our addition state.
```
machine.editStateByName('addition', 'timeout',5,'next','third')
```
The syntax of the second argument should follow the same syntax as the larger stateList. In this case, the 'addition' state is now pointing to the 'third' state as the state the StateMachine will transition to.

##  function addSharedFevalableWithName(self, fevalable, name, when)

This function allows you to add a fevalable that will be executed after either the 'entry' stateField or the 'exit' stateField for EVERY state. The structure of the input arguments are the fevalable (either a handle or a {@function, inputthefunctionneedstorun}), name for the fevalable, and when ('entry' or 'exit'). If a when argument is not given then the function will default to 'entry.' 

The sample code below can be used to understand the function better.
```
stateList = { ...
    'name',     'entry',	'timeout', 'input', 'next' 'exit'; ...
    'first',    hello       0.1,        {@input,'','s'}, 'second', {}; ...
    'second',	pardon,     0.1,        {},  'third', {@input,'','s'}; ...
    'third',    goodbye,    0.1,        {}, '', {}; ...
    };
machine.addMultipleStates(stateList);
machine.addSharedFevalableWithName({@disp, 'I am executing after the entry stateField...'},'namestuff','entry');
machine.addSharedFevalableWithName({@disp,'and I am executing after the exit stateField'},'othernamestuff','exit');

clc();
machine.run();
```
>if 's' is not included after @input, Matlab expects numeric input and text will throw up an error

If you run this code you will be able to see when the machine stops and what has already executed while it waits for your inputs. Notice that we have created a new stateField 'exit' and have included the brackets for the states that do not have any arguments in this field. addSharedFevalableWithName will execute even if these stateFields did not "exist" (as they always exist, just with default properties) above. The addition of the 'exit' stateField and the @input entry in the second state is just so you can see first hand that it addSharedFevalalbeWithname executes after the 'exit' stateField. 

## transitionFevalable

The transitionFevalable will execute a fevalable in-between each state. This is similar to the sharedFevalable function above. We use the same code as above with a new line added before the creation of our stateList and a new function added at the end of our script. 
```

machine.transitionFevalable = {@transitioning}

stateList = { ...
    'name',     'entry',	'timeout', 'input', 'next' 'exit'; ...
    'first',    hello       0.1,        {}, 'second', {}; ...
    'second',	pardon,     0.1,        {},  'third', {}; ...
    'third',    goodbye,    0.1,        {},    '',    {}; ...
    };
machine.addMultipleStates(stateList);

clc();
machine.run();

function transitioning(transitionStates)
disp(sprintf('Transitioning from %s to %s', ...
    transitionStates(1).name, transitionStates(2).name));
```
The transitionFevalable is programmed to create a 1x2 structure array of information about the previous state and the next state. The first argument in our example, transitionStates, contains the information about the two states. We are accessing that information using built-in Matlab structure accessing syntax to get the name of the previous state and next state and displaying it in the command window. You can access any information about the states. In our case, only accessing string information (like name stateField or next stateField) will work. 

Any other arguments in transitionFevalable will be passed to the function starting at the second place. For example we can have it add together an inputed number.

Change machine.transitionFevalable to
```
machine.transitionFevalable = {@transitioning, inputanumber};
```
After machine.run(); add the function
```
function out = inputanumber()
out = input('');
```
and change the transitioning function to
```
function transitioning(transitionstates, out)
disp(sprintf('Transitioning from %s to %s', ...
    transitionstates(1).name, transitionstates(2).name))
summednumber = out + out
```
If you run the code with the new additions,  you'll see that you are asked for some input before the first state appears. The code will just take that input, sum it with itself, and display it between each state transition. 