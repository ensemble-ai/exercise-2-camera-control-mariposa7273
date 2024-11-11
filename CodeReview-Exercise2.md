# Peer-Review for Programming Exercise 2 #

# Solution Assessment #

## Peer-reviewer Information

* *name:* Yujin Cho
* *email:* yujcho@ucdavis.edu

## Solution Assessment ##

### Stage 1 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera follows the general location of the vessel. Camera lags in front of the vessel a bit, then snaps back to vessel when it is stationary instead of being always centered on the vessel.

The lagging was actually caused by [this line](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/postion_lock.gd#L21). It seems to be unnecessary to change the camera's position using velocity if it is always set to the vessel's position.

___
### Stage 2 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Camera constantly scrolls at a fixed speed. Vessel can move freely within the auto-scroll box, but is bounded by the box edges and correctly gets pushed along by the furthest edge when it is stationary. 

The box does not scroll on the z axis. I'm not sure if it was required to have the box move on both the z and x axes, but the prompt seems to imply it. This can be easily implemented by changing [this vector's](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/auto_scroller.gd#L8) z value, however.

___
### Stage 3 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
When the vessel is moving, camera correctly follows the vessel at a speed slower than it. When the vessel is stationary, camera correctly slowly catches up to the vessel and snaps back onto it.

Student did not correctly implement the leash - when moving at hyper-speed, the vessel moves away from the camera at a distance greater than the leash distance.

___
### Stage 4 ###

- [ ] Perfect
- [ ] Great
- [x] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
When the vessel is moving, camera correctly travels in front of the vessel at a speed faster than it. When the vessel is stationary, camera correctly pauses for the length of catchup_delay_duration and then catches up to the vessel.

Student did not correctly implement the leash - when moving at hyper-speed, the vessel speeds up ahead of the camera and the distance between the camera and the vessel exceeds the leash distance.

___
### Stage 5 ###

- [ ] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [x] Unsatisfactory

___
#### Justification ##### 
Student did not implement part 5. The camera is stationary while the vessel moves.

___
# Code Style #

#### Style Guide Infractions ####
Code is well structured and student did a good job following the style guide. Because I couldn't find any major infractions, I listed some nitpicky details about comments and indentation below:

* [Incorrect comment formatting](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/postion_lock.gd#L51): Regular comments that are not code that is commented out should have a space between the # and the text. This happens a couple times in various files.
* [Incorrect comment indentation](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/auto_scroller.gd#L21): Some comments are not indented properly along with the rest of the code. Comments should generally be indented along with the code blocks they are referencing. This also happens a couple times across different files.

#### Style Guide Exemplars ####

* Student consistently uses snake_case for variables and camelCase for class names. 
* [Student spaces out their logic blocks correctly](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/auto_scroller.gd#L29) - one blank line between each block. This allows for good readability.
* [Student followed code order when adding new variables](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/target_focus.gd#L8). This public variable is below the export variables as required.

___

# Best Practices #

#### Best Practices Infractions ####
I also couldn't find any infractions of what would be considered a best practice, so I'm being nitpicky.

* The file postion_lock.gd should be spelled position_lock.gd.

#### Best Practices Exemplars ####
* [Student always multiplies their velocity vectors by delta](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/position_leash.gd#L36). This is good practice because it ensures that the game runs the same regardless of changes in framerate.

* [Student declares new variables for complicated calculations](https://github.com/ensemble-ai/exercise-2-camera-control-mariposa7273/blob/e1b672c6aeb9759444dca363f357186966736b8f/Obscura/scripts/camera_controllers/target_focus.gd#L29), and new variables are clearly and appropriately named. This makes code shorter and easier to read.

* Extensive commenting: Each block of logic in the code has a comment explaining what the code does, which is helpful for the reader and grader.

* Student made numerous commits at each stage of the project, which is good practice.


