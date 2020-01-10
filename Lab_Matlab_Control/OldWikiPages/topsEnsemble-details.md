topsEnsemble is very similar to topsCallList. Whereas topsCallList is used to run a group of fevalables, topsEnsemble is designed to hold a group of objects. This allows it to execute batch functions using those objects OR methods of the objects it contains. When adding objects to a topsEnsemble, it is important that the objects all share a common property or method, which will allow topsEnsemble to access those values or run those methods on all the objects it contains. 

Note that this functionality could in theory also be achieved using a topsCallList since methods in Matlab can be called via `obj.method(...)` or `method(obj,...)`. However, using a topsEnsemble will be more convenient once you have many objects or common methods. It is recommended to use objects that are `handle` subclasses with topsEnsemble.

Initializing a topsEnsemble is straightforward as follows
```
myTopsEnsemble = topsEnsemble();
```

Objects can be added using the `addObjects()` method. Once  you have added your objects to the ensemble, you can automate object methods so that they will run automatically. Afterwards, calling the `run()` or `runBriefly()` function of topsEnsemble will automatically run such methods. See below for an example.

```
myObject = myObjectClass();
myTopsEnsemble.addObject(myObject);
myTopsEnsemble.automateObjectMethod('myMethod', @myObjectClass.method, {}, [], false);
myTopsEnsemble.run();
```
Note that in the example above `myObject.method` is a static method. Non-static methods do not need (and will not work with) a function handle including the object class. Instead, using `@method` will suffice due to the way Matlab methods work.

Below are details on various functions in topsEnsemble that may be useful.
# Functions
## function object = removeObject(self, index)
This will remove the object at the specified index from the ensemble. Note that removing an object may resize the underlying cell array so that old indices are no longer valid.

## function object = getObject(self, index)
Retrieve the object at the specified index in the ensemble. This does not remove the object from the ensemble.

## function [isMember, index] = containsObject(self, object)
Check whether the ensemble contains the specified object. If so, returns the index at which this object is located within the ensemble.

## function assignObject(self, innerIndex, outerIndex, varargin)
This function assigns the object specified by `innerIndex` to a property in the object specified by `outerIndex`. Thus, both objects must be in the ensemble for this function to work. The input for varargin will be directly passed into the Matlab native function `substruct` to format it so that Matlab can assign the objects properly. See the Matlab documentation for [substruct](https://www.mathworks.com/help/matlab/ref/substruct.html) and [subsasgn](https://www.mathworks.com/help/matlab/ref/subsasgn.html?s_tid=doc_ta). Note that these links point to the documentation for the latest version of Matlab. In order to access archived documentation, you will need a Mathworks account.

## function passObject(self, innerIndex, outerIndex, method, args, argIndex)
This function passes the object at `innerIndex` to a method of the object at `outerIndex`. By default, this function passes the innerIndex object as the first argument. If it should not be the first argument, specify the other arguments in the `args` parameter and where the object should go using the `argIndex` parameter. This function will effectively run
```
args{argIndex} = innerObj;
outerObj.method(args{:});
```
Both objects must be in the ensemble for this method to work.

## function setObjectProperty(self, property, value, index)
Sets the value of a property at for the object at the specified `index`.

## function value = getObjectProperty(self, property, index)
Retrieves the value of a property for an object at the specified index.

## function result = callObjectMethod(self, method, args, index, isCell)
Calls a common method among all the objects in the ensemble using the `args` as inputs if provided. `Index` can be used to specify which objects to all the method on and `isCell` specifies whether the inputs should be encapsulated in a cell array.

## function index = automateObjectMethod(self, name, method, args, index, isCell, isActive)
This sets up a `method` to be automatically called when `run()` or `runBriefly()` is invoked on the ensemble. `isCell` tells function to pass all the arguments in one cell array to the method. If `isActive` is set to false, this named function call will be ignored when `run()` or `runBriefly()` is called.