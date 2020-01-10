# Write data
As of commit [d2013c25](https://github.com/TheGoldLab/Lab-Matlab-Control/commit/d2013c2508ef8ec2a9d97fa96d6aaee7a7606f49), any task object that inherits from [topsTreeNodeTask](https://github.com/TheGoldLab/Lab-Matlab-Control/blob/d2013c2508ef8ec2a9d97fa96d6aaee7a7606f49/tower-of-psych/foundation/runnable/topsTreeNodeTask.m) has the ability to automatically dump data collected during the experiment into a `.mat` file.

## Setting up the directory structure for automatic data dump

Before running your task for the first time, you should do the following:  
1. Decide in which folder on your computer you would like your experiment to dump the data. If you pick folder `bar` with full path `/foo/bar`, then you should make sure that your `MachineConfig.xml` file contains the following line:`<dataPath>['/foo/bar']</dataPath>`
2. Give your experiment a name, and create the appropriate directory structure. This is done as follows. If you call your experiment _myXpt_, then you should construct the top node of your experiment as follows: `topNode = topsTreeNodeTopNode('myXpt');`. Then, you should create the folders `/foo/bar/myXpt` and `/foo/bar/myXpt/raw` on your computer.

Once the above is done, you may run your experiment as many times as you wish. Every time, a new directory will automatically be created by MATLAB, with the current timestamp as name. If you run your task at 9:54 PM on 13 March 2019, your task will create the folder `/foo/bar/myXpt/raw/2019_03_13_21_54`. The data itself will be written to the file `/foo/bar/myXpt/raw/2019_03_13_21_54/2019_03_13_21_54_topsDataLog.mat`.
We describe below how to read this data, post hoc.

# Read data
To read the fictitious example data dumped from the previous section, we can use the following code:
```
[topNode, FIRA] = topsTreeNodeTopNode.loadRawData('myXpt', '2019_03_13_21_54');
```