dotsEnsembleServer (server) pairs with [[dotsClientEnsemble|dotsClientEnsemble details]] (client) to enable communication between multiple machines. This class mimics the [[topsEnsemble|topsEnsemble details]] object and receives commands and data from the client. This class must be running **BEFORE** instantiating any clients. In order to instantiate this class, run the following

```
myEnsembleServer = dotsEnsembleServer('127.0.0.1',30000,'127.0.0.1',30001);
myEnsembleServer.run();
```

Note that this will effectively block your Matlab instance (because the server is running on essentially a `while true` loop unless you specify a duration). Therefore, make sure to open any SnowDots screens and display windows beforehand OR organize your experimental code so that it is an object which can be passed from the client to server and opens a window afterwards.

Refer to the topsEnsemble reference page for details on inherited functions. Below are details on functions specific to the dotsEnsembleServer class.

# Functions
## function runNewServer(duration, clientIP, clientPort, serverIP, serverPort)
This function starts a new server using the addresses provided. This is essentially doing the same thing as the example code above.