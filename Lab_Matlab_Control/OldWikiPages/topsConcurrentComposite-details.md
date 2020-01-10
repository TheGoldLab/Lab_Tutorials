topsConcurrentComposite takes topsConcurrent objects and run them concurrently. If you examine the flow chart on the Tower of Psych main page, you will see that topsStateMachine and topsCallList are all topsConcurrent objects. topsConcurrent is primarily for internal organization and is not typically addressed directly by the user. topsConcurrentComposite is the class you will want to add to to get your various Tower of Psych components to run together. 

Inputing the code below will allow you observe it's basic behavior.  
```
function CPdemotopsConcurrentComposite()

hello = {@disp, 'Hello.'};
pardon = {@disp, 'Pardon me?'};
goodbye = {@disp, 'Goodbye.'};

howdy = {@disp, '  How do you do?'};
fine = {@disp, '  Fine, thanks.'};
rest = {@pause, 0.5};

replies = topsCallList('call other functions');
replies.addCall(howdy, 'say howdy');
replies.addCall(fine, 'say fine');
replies.addCall(rest, 'rest a bit');

machine = topsStateMachine('traverse states');
stateList = { ...
    'name',     'entry',	'timeout', 'input', 'next'; ...
    'first',    hello,      0.1,        {}, 'second'; ...
    'second',	pardon,     0.1,        {},  'third'; ...
    'third',    goodbye,    0.1,        {}, ''; ...
    };
machine.addMultipleStates(stateList);

concurrents = topsConcurrentComposite('run() concurrently:');
concurrents.addChild(replies);
concurrents.addChild(machine);

clc();
concurrents.run();
```

After creating a topsCallList object (replies) and topsStateMachine object (machine), we add those to the topsConcurrentComposite object (concurrents). The only function that we need to be concerned about in topsConcurrentComposite is the addChild function. Similar to topsCallList, it just adds our two topsConcurrent categories (topsStateMachine and topsCallList) to our topsConcurrentComposite object. 'run() concurrently:' is an optional name assignment. 

If you run the script above you should see:
```
Hello.
  How do you do?
  Fine, thanks.
Pardon me?
  How do you do?
  Fine, thanks.
Goodbye.
  How do you do?
  Fine, thanks.
```
The first state in our StateMachine is being executed, then the topsCallList is running through ALL of it's calls (important!), then the second state in our StateMachine is being executed, and again our topsCallList is running through all of it's calls. So on and so forth. 

topsConcurrentComposite is running everything together but it is actually telling it's components to runBriefly one at a time, over and over again. If one of those components gets set to false than topsConcurrentComposite will STOP running. If you add the line below into your script before concurrents.run() you see see an example of this.
```
replies.alwaysRunning = false;
```
Now topsConcurrent will execute our first state, execute our topsCallList, execute our second state, and then stop. Also, the reason our original script stops running is because our StateMachine is telling itself to stop running after going through all of it's states. If you entered 'first' for the 'third' states 'next' stateField you would create an endless loop!