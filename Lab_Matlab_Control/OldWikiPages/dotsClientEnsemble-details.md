dotsClientEnsemble (client) is used for communicating tasks between multiple machines and is paired with [[dotsEnsembleServer|dotsEnsembleServer details]] (server). Both of these objects mimic the [[topsEnsemble|topsEnsemble details]]. To instantiate one of these objects, you need IP addresses and ports of both the machine this object runs on and the machine server runs on. The example below shows how this is done using the `localhost` IP address and some arbitrary ports. It is important to note that the server object must be running **BEFORE** you instantiate the client. 

```
myClientEnsemble = dotsClientEnsemble('any_name','127.0.0.1',30000,'127.0.0.1',30001);
```

To make sure that you are connected to a server, type the following in your console

```
myClientEnsemble.isconnected
```
which should give you an output like this
```
ans =
     1
```
If the output is `0`, then that means the client failed to successfully connect to the server. Make sure that both objects were instantiated with identical IPs and Ports (the ordering of the input parameters is identical for both objects). If that still does not fix the issue, try restarting Matlab on both machines.

Once you have successfully connected a client to a server, you can use the client just like you would a topsEnsemble object. Anything command run through the client will be mirrored and executed on the server. One caveat is that the `runBriefly()` function does not seem to work. In order to replicate similar behavior, use the `run()` function with a small time parameter. 

In order to connect to many servers on one machine, you must instantiate a client for each server you to which you want to connect. A server, however, can take connections from many different clients simultaneously. Furthermore, it will keep track of which client added which object, so that commands executed through a particular client will only affect the objects associated with that client. It is not recommended to send commands from multiple clients simultaneously to a single server.

For details on what the inherited functions of this class do, see the [[topsEnsemble page|topsEnsemble details]]. Below are functions specific to this class only.

# Functions
## function [status, txn] = resetServer(timeout, clientIP, clientPort, serverIP, serverPort)
This function will attempt to connect to the server using the provided addresses and tell it to reset. Resetting the server clears all the objects/client data on the server, but does not stop the server from running. This function will give up if the server does not respond within the `timeout` time. A negative `status` value means that the reset has failed. `txn` provides detailed information about the transaction.
