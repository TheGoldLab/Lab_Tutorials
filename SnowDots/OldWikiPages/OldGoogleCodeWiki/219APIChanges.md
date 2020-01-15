I made a few changes to function names. They're all cases where the I needed to generalize things and it just made sense to rename them. They are all find-and-change type substitutions: just the names have changed by not the behaviors.

You might need to do nothing, but if you use some of these functions or class properties in your own code, you'll have to change them after you "svn update" past revision 219.

Sorry for the pain!

Here are the changes:

**dotsTheDrawablesManager**

The old function addDrawableToGroupWithRank() is gone. Instead use addObjectToGroup(), which can accept an optional rank argument exactly like the old method. 

|old|new| 
|:----|:----| 
|addDrawableToGroupWithRank()|addObjectToGroup(..., rank)|

addObjectToGroup() is actually a method of the dotsAllObjectManagers superclass, so now any manager can have groups of sorted objects. The rank can be a number or a string (sorted alphabetically).

Instead of setting the isAccumulating property directly, use the setIsAccumulating() method. 

|old|new| 
|:----|:----| 
|isAccumulating|setIsAccumulating()|

Instead of setting the activeGroup property directly, use the activateGroup() method. 

|old|new| 
|:----|:----| 
|activeGroup|activateGroup()|

These last two make it easer to coordinate between client and server counterparts. They're also easier to call from an fevalable or anonymous function.

**dotsQueryableEye (and subclasses)**

I realized it was restrictive only to consider pupil "diameter". Instead classes should consider the "pupil" or "pupil size", which might be diameter, area, or whatever.

So I changed the following: 

|old|new| 
|:----|:----| 
|diameter|pupil| 
|dMax |pupilMax| 
|diameterID|pupilID|

And then I realized that "size" as it referred to the size of a discrete dimension was confusing. So I changed it to "points" 

|old|new| 
|:----|:----| 
|dSize|pupilPoints| 
|xySize|xyPoints|
