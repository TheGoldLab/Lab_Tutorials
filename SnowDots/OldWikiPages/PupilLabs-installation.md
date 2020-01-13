The instructions below were tested and successfully carried out using Matlab 2016a on OSX 10.10.5 for PupilLabs 0.9.14.
# PupilLabs software

To install the PupilLabs software, you must first install all the dependencies as outlined on their [website](https://docs.pupil-labs.com/#macos-dependencies). It is a good idea to execute the console commands line by line instead of copy and pasting the blocks on their site. This is because copying blocks may (for unknown reasons) result in certain commands being randomly skipped.

Once you have installed all the dependencies, clone the [PupilLabs source code](https://github.com/pupil-labs/pupil) to the directory from which you want to run the software.

You can test your installation by navigating to directory where you cloned the git repository and running `python3 main.py`. This should start the PupilLabs software. If you run into problems, make sure that you have installed all the dependencies correctly and visit the PupilLabs GitHub site for additional help with troubleshooting.

# SnowDots dependencies
To get the SnowDots PupilLabs object to run, you need to install some additional libraries. The first is [matlab-zmq](https://github.com/fagg/matlab-zmq). This will allow you to interface with the ZMQ network (which is what PupilLabs uses for all communication and data transmission) directly from Matlab. 

The matlab-zmq library requires ZMQ to be installed on your machine. Visit the [ZMQ website](http://zeromq.org/intro:get-the-software) to install ZMQ onto your machine. Although the installation instructions for matlab-zmq state that you should use ZMQ 4.0.X, we have successfully used the package while runing ZMQ 4.2.2. It is likely (but not guaranteed) that any ZMQ version that promised backward compatibility will work fine.

Once you have installed ZMQ, you need to compile the matlab-zmq MEX files. Follow the instructions on the matlab-zmq GitHub site. There is a small caveat that you may need to that the `ZMQ_COMPILE_LIB` variable in the `config.m` file from `./libzmq.a` to `libzmq.a`. This change may be dependent on your OS, and it could be the case that the files compile correctly without it. However, on OSX 10.10.5, we could not get the files to compile without this edit.

# Point Matlab to Python3
You will also need to point your Matlab to the Python3 version that you used to install PupilLabs. Alternatively, you can point it to another version of Python on your machine, but make sure that this version has the `msgpack_python` package installed. This is because there is no good msgpack serializer library for Matlab (please inform us if you write or make one) so we instead make use of Matlab's Python integration. 

On OSX, the way to point your Matlab to the Python3 installed via homebrew (if you followed PupilLabs dependencies installation) is to run the following command from the Matlab console (taken from [here](https://erikreinertsen.com/python3-in-matlab/))

```
pyversion('/usr/local/opt/python3/bin/python3.6');
```

You can check to make sure this worked by running just the `pyversion` command without any inputs.

Once you have completed these steps, you are ready to use PupilLabs and the SnowDots object! Check out the demo scripts and descriptions in the WIKI for more information on how to use the class.

