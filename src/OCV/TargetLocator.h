/**
 * @file   TargetLocator.h
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  OpenCV part of the testbed. More in TargetLocator class description.
*/
#ifndef TARGET_LOCATOR_H
#define TARGET_LOCATOR_H

#include "CThread.h" 
#include <semaphore.h> 
#include "CRawImage.h"
#include "CDecoder.h"
#include <sys/time.h>
#include <unistd.h>

#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"


#include <curl/curl.h>

#include <math.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <iostream>

using namespace cv;
using namespace std;

//!  The class that uses color filters to detect the location of targets and drones (check calibrator2.cpp too).
/*!
This class takes in the number of tracked objects and the color filter for each object. Then it detects the location and orientation of up to 10 instances of each object. We note that for most cases, we don't care about differentiating between different targets, however, we care about differentiating between drones. Thus, for each color, we can have up to 10 targets if it is a target color and only one drone if it is a drone color.

The class responsible for each object connects with this class to get the location of its object of interest. This class uses the same computer vision techniques discussed in calibrator2.cpp, so I only document how this class do differently. This class inherits from CThread to allow it to run as light weight side thread to continously detect and update object location.
*/


class TargetLocator:CThread
{
public:
	//! The constructor.
	/*!
	      It takes in the number of objects and an integer vector for each filtering parameters. Each member of the vector maps to a certain object. Later, objects are indexed based on the indexes of colors in these vectors. The constructor creates arrays to store the location of each of the detected objects (with a maximum of 10 objects per color). It also starts the curl process that communicates with the master camera.
	\param numberOfTrackedObjects the number of tracked objects
	\param h_min_in a vector of minimum red filter
	\param h_max_in a vector of maximum red filter
	\param s_min_in a vector of minimum green filter
	\param s_max_in a vector of maximum green filter
	\param v_min_in a vector of minimum blue filter
	\param v_max_in a vector of maximum blue filter
	*/
	TargetLocator(int numberOfTrackedObjects, int * h_min_in, int * h_max_in, int * s_min_in, int * s_max_in, int * v_min_in, int * v_max_in);
	//! The distructor which kills the detection thread.
	/*!
	*/
	~TargetLocator();

	//! Starts the thread which is an infinite loop that pulls images from the master camera.
	/*!
	      Starts an SDL thread for the instance of the object which calls in its turn the private DoExecute() function. That function has an infinite loop which does the same thing as the loop in the main fuction in calibrator2.cpp.
	*/
	void run();

	//! Gets X coordinate of the first of the 10 targets with colorId.
	/*!
	\param colorId which maps to the index of the color in the vector of color filters in the constructor.
	*/
	double getTargetX(int colorId);
	//! Gets Y coordinate of the first of the 10 targets with colorId.
	/*!
	\param colorId which maps to the index of the color in the vector of color filters in the constructor.
	*/
	double getTargetY(int colorId);
	//! Returns 1 or 0 depending on whether there is a target with that color that is visible.
	/*!
	\param colorId which maps to the index of the color in the vector of color filters in the constructor.
	*/
	int isTargetVisible(int colorId);

	
	//! Gets the number of objects seen with colorId (maximum of 10).
	/*!
	\param colorId which maps to the index of the color in the vector of color filters in the constructor.
	*/
	uint32_t getTargetCount(int colorId);
	//! Gets X coordinate of target number targetId with color colorId.
	double getTargetX(int colorId, int targetId);
	//! Gets Y coordinate of target number targetId with color colorId.
	double getTargetY(int colorId, int targetId);
	//! Gets orientation of target number targetId with color colorId. [FIX ME !!]
	double getTargetOrientation(int colorId, int targetId);
	

private:

	double getOrientation(vector<Point> &pts, Mat &img);
	int DoExecute();
	void morphOps(Mat &thresh);
	void findReds( Mat& image, Mat& original, int);

	VideoWriter outputVideo;                                        // Open the output

	SDL_Thread * thread;
	bool stop,stopped;
	CURL *curl;       // CURL objects
	CURLcode res;

	int numberOfTargets;

	int * H_MIN;
	int * H_MAX;
	int * S_MIN;
	int * S_MAX;
	int * V_MIN;
	int * V_MAX;
	int  targetCount [4];
	double currentTargetsX [4][10];
	double  currentTargetsY [4][10];
	double  currentTargetsOrientationV1 [4][10];
	double  currentTargetsOrientationV2 [4][10];
	int  targetVisible [4][10];
	//default capture width and height
	int FRAME_WIDTH;
	int FRAME_HEIGHT;
	//minimum and maximum object area
	int MIN_OBJECT_AREA;
	int MAX_OBJECT_AREA;


};


#endif
