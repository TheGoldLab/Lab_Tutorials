In preparation for Version1, I dug into the Snow Dots Ethernet messaging code. The result is faster Ethernet transactions.

Some of the speed-up comes from removed overhead in m-code function calls. Some of the speed-up is optional, with the introduction of two flavors of synchronization between client and server Matlab instances: strong synchronization and weak synchronization.

This included work at several levels of organization, from mex-function c-code through object-oriented m-code:

**mexUDP()**

mexUDP() is a Snow Dots mex-function for doing UDP Ethernet messaging from systems that use use Berkeley sockets.

As of r892, the mexUDP('check') sub-command accepts an optional timeout parameter. hasData = mexUDP('check', id [, timeoutSeconds])

This allows mexUDP() to block for the given timeoutSeconds, or until a UDP message arrives. If timeoutSeconds is omitted, the old behavior results: mexUDP('check') returns immediately and callers must to poll for messages themselves.

The new blocking behavior reduces the number of m-code loops and function calls necessary to receive and respond to an expected message. The blocking is implemented with the POSIX select() function.

**dotsAllSocketObjects**

dotsAllSocketObjects is an abstract class defining the interface that Snow Dots expects from objects doing Ethernet messaging.

As of r892, the dotsAllSocketObjects.check() methods may take an optional timeoutSecs argument.

dotsSocketMexUDP is an implementation of dotsAllSocketObjects that uses the mexUDP() mex-function. It treats timeoutSecs as described above for mexUDP().

dotsSocketPnet is an implementation of dotsAllSocketObjects that uses the pnet() mex-function. It treats timeoutSecs similarly to dotsSocketMexUDP.

**dotsTheMessenger**

dotsTheMessenger is the "front end" for doing Ethernet messaging in Snow Dots. It uses dotsAllSocketObjects and adds robustness and convenience.

Before r892, dotsTheMessenger had a waitForMessageAtSocket() method. This used an m-code loop to poll for arriving messages. As of r892, this method is gone.

Instead, receiveMessageAtSocket() accepts an optional receiveTimeout argument. If receiveTimeout is positive, the method is allowed to block for up to receiveTimeout seconds until a message arrives.

Likewise, sendMessageFromSocket() accepts an optional ackTimeout argument. If ackTimeout is positive, the method is allowed to block for up to ackTimeout seconds until it receives a message acknowledgement.

**dotsClientEnsemble and dotsClientEnsemble**

dotsClientEnsemble and dotsEnsembleServer are complimentary classes that allow Snow Dots to span multiple Matlab instances. They use dotsTheMessenger, so they benefit directly from the above changes.

As of r892, they also conserve messaging traffic by sending shorter messages. Instead of exchanging full "transactions", they agree on a transaction template and only send deviations from the template.

Smarter timeout behaviors and shorter messages result in significantly faster client-server communication. In rough numbers, using two instances of Matlab running on the same MacBook, transactions that previously took 5ms now take about 2-3ms.

**Strong vs. Weak Synchronization**

Before r892, dotsClientEnsemble and dotsClientEnsemble communicated with what I'm now calling strong synchronization. This meant that the client requested a server behavior, then waited until the server reported that it was all done. This allowed the server to return a lot of timing data, as well as the results of method calls or property access. But it meant that the client spent a lot of time waiting.

r892 introduces "weak synchronization": when the client doesn't need to collect timing data, and doesn't expect any returned results, it can wait only for the server to acknowledge a behavior request. The client is able to continue doing other things while the server actually carries out the behavior. This improves parallelism.

Here is a sketch of client and server communications. Each table row represents a step that happens after the step above. Extra steps required for strong synchronization are in bold.

| client | server | |:-------|:-------| | request behavior | ready | | wait for acknowledgement | receive request | | | acknowledge request | | receive acknowledgement | do behavior | | wait for data | reply with data | | receive data | wait for acknowledgement | | acknowledge data | | | continue | receive acknowledgement |

Weakly synchronized transactions take half as many steps as strongly synchronized transactions. In rough numbers, using two instances of Matlab running on the same MacBook, weakly synchronized transactions can take as little as 1-2ms as seen by the client.

dotsClientEnsemble has a new isSynchronized property for choosing the flavor of synchronization. When isSynchronized is true, an object always does strong synchronization. When isSynchronized is false, an object does weak synchronization, unless it's expecting return data from a method call or property access.

As of r892, client-server communications include an isSynchronized hint, so that dotsEnsembleServer objects know whether to reply with data.