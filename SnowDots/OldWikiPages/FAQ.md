### How can I quickly know what MachineConfiguration.xml file is being used?
Typing the following in the MATLAB command window displays the default filename used by dots/tops:
```
filename = dotsTheMachineConfiguration.getHostFilename()
```
To see if the file exists and is on the Matlab path, then type:
```
which(filename)
```
### How can I quickly know the folder structure in which the `.mat` files generated by my task will be saved?
The default file structure and file names are created in the topsTreeNodeTopNode constructor method. To override, set the "filename" property to a new value.

The default names are defined by the static method topsTreeNodeTopNode.getFileparts, with three arguments:
1. studyTag, which by default is the name given to the topsTreeNodeTopNode object
2. sessionTag, which by default is a string made up of the current date and time
3. dataTag, which is used to make different data files (e.g., for the topsDataLog, it creates the suffix '_topsDataLog.mat')

The data path uses the value stored in 'dataPath' in the machine configuration file under 'defaults'; e.g., listed as:
```
<dataPath>['<PATHNAME>']</dataPath>
```
So by default, if you have dataPath set to '/Users/lab/data' and you are running a study called 'test' on 01/01/01 at 1:11:11 pm, then your topsDatLog data will be found in: /Users/lab/data/test/raw/2001_01_01_13_11_11/2001_01_01_13_11_11_topsDataLog.mat

### When writing the class for a task, what is the purpose of `protected` methods?
Protected methods are used when you want to restrict access to the method from just the class or subclass. 

### How can I set two or more readables in a task (to get input from several devices)? 