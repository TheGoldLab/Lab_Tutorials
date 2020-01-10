# TO BE REVISED...
Snow Dots can span multiple Matlab instances, using a client-server model. All client-server communications pass through ensembles, which group objects together, access properties, and call methods and functions.

**Client vs. Server**

There is always one Snow Dots client. This is the primary Matlab instance which maintains state and controls flow during an experiment. The client can run by itself, in which case it's the only Matlab instance. Or, the client can connect to one or more servers.

A server is a secondary Matlab instance which waits for commands from the client and responds to them as fast as possible. Commands can specify things like creating objects, drawing graphics, or querying data collection systems.

Client and server communicate via Ethernet and the UDP protocol. Each client or server needs an IP address and a UDP port number.

Client and server are meant to run in parallel. They can run on a single machine, because modern operating systems allow multitasking. They can also run on separate machines, in which case client and server may run under different operating systems!

**Ensembles**

All client-server communications use ensembles.

topsEnsemble is the basic type of ensemble, which allows grouping of objects, object property access, and method and function calls.

dotsClientEnsemble is a drop-in replacement for topsEnsemble. dotsClientEnsemble re-implements the basic ensemble behaviors to coordinate with a server instance. It tells the server to create objects that mirror objects on the client side. It can access properties of server objects, and call methods and functions on the server objects instead of on the client objects.

Each client ensemble communicates with an object on the server side called dotsEnsembleServer. dotsEnsembleServer waits for commands from client ensembles and creates ensembles on the server side to act as counterparts for each client ensemble.

**Communication**

Client and server run in parallel, but they have to stop and synchronize in order to communicate. Snow dots provides two kinds of synchrony which have different uses.

**Weak Synchrony**

"Weak Synchrony" is relatively fast, but it only allows information to be sent from the client to the server. It's useful for sending commands to the server, but not for getting data back from the server.

https://snow-dots.googlecode.com/svn/wiki/diagrams/client-server-ensembles-weak.png

Conceptually, communication goes from myEnsemble on the client side to remoteEnsemble on the server side. In the diagram above, the dashed gray arrow shows this apparent communication.

Behind the scene, communication goes through several layers of Snow Dots and operating system functionality. The solid green arrow traces this path.

dotsTheMessenger handles communications details like making sure the server acknowledges each message from the client. The solid magenta arrow represents this acknowledgement.

Beneath dotsTheMessenger are low-level UDP functions. Note that the client has functions with names like "mexUDP", while the server has functions with names like "pnet". These are interchangeable. Snow Dots has a couple of options for low-level UDP functions.

After sending a command (green arrow) the client must stop and wait for the server's acknowledgement (magenta arrow). As soon as the client sees the acknowledgement, it may proceed and do other things.

At the same time, as soon as the server sends its acknowledgement, it may proceed and carry out its command. Since the client and server can run in parallel even while the server carries out its command, this scenario is called "Weak Synchrony".

**Strong Synchrony**

"Strong Synchrony" is relatively slow, but it allows information to be sent from the client to the server and from the server to the client. It's useful for querying data from the server, such as timing data, object property values, and method and function results.

https://snow-dots.googlecode.com/svn/wiki/diagrams/client-server-ensembles-strong.png

"Strong Synchrony" includes all of the communication in "Weak Synchrony", plus more. It's roughly twice as verbose.

In the diagram above, the dashed gray arrow shows the apparent two-way communication between myEnsemble on the client side and remoteEnsemble on the server side.

Since the server sends data back to the client, the solid green arrow now continues through remoteEnsemble and all they way back to myEnsemble. The client must stop and wait until it receives data from the server before it may proceed and do other things.

In addition, the server must stop and wait until the client sends and acknowledgement of the returned data (pink arrow).

The full result is that client and server operate one at a time--one runs while the other waits. The client can be certain that the server finished carrying out its command, and can see the results, so this scenario is called "Strong Synchrony".