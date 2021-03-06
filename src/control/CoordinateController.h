/**
 * @file   CoordinateController.h
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  Main controller of the drone. More details in CoordinateController.
*/


#ifndef COORD_CTRL_H
#define COORD_CTRL_H

#include "CRawImage.h"
#include "CDecoder.h"
#include "CHeli.h"
#include <TargetLocator.h>

#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"



#include "CThread.h" 
#include <semaphore.h> 



#include <curl/curl.h>

#include <math.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include <iostream>

using namespace cv;
using namespace std;

//!  The class that is that has the control algorithm controlling the drone (move on X axis then Y axis then rotate).
/*!
This class has the control algorithm that controls a drone. This version of the testbed uses a very simple and light way algorithm. It moves the drone on X-axis (left or right depending on the drone's current location) till it reaches the destination's X coordinate. Then, it moves the drone on the Y-axis (forward or backwards depending the the drone's current location) till it reaches the destination's Y coordinate. This class also provides methods for Hovering and changing orientation. This class is meant to be the interface between each drone and the rest of the testbed components. Thus, this class wraps the CHeli class that represents the drone. However, it's important to note that we need need a CoordinateController instance for each drone. An instance of CoordinateController runs a thread that continuously checks for updates in the required destination, if there is an update it moves the drone to that destination.

As a safety precaution, all control functions check first if the drone is seen by the master camera. If for some reason the master camera cannot see it, the killSwitch flag is set and the drone lands.
*/
class CoordinateController:CThread{
public:

	//! The constructor handles creating the CHeli instance controlled by this instance.
	/*!
	      It takes the TargetLocator instance to locate the drone, the drone color ID and the IP address to communicate with it. Then, uses those parameters to create a CHeli instance. <b> Remember to call run() to start the thread after creating the instance.</b>
	\param lc TargetLocator instance to locate the drone.
	\param tol control error in pixels (refer to heli.cpp for more information on control tolerance).
	\param id the color ID of the drone instance to query TargetLocator instance.
	\param dIP drone IP to create CHeli instance.
	\param dName drone name to create CHeli instance.
	\param port drone designated port to create CHeli instance.
	*/
	CoordinateController(TargetLocator * lc, int tol, int id, char * dIP, char * dName, int port);
	//! The destructor.
	~CoordinateController();
	

	//! The main control function.
	/*! <b> Remember to call run() to start the thread before calling this function.</b> This function updates the destination coordinates for the drone and sets moveCommandGiven flag to true. When the control thread finds that moveCommandGiven was to true, it starts moving the drone to the new destination coordinates. DO NOT call goTo() until the drone gets to its new destination because this code does not stop goTo from editing the destination variables with the thread is reading them. [Fix Me !!] (this is also another reason why we perform the runs in steps and the experiment human controller needs to explicitly start each step).
	\param x new destination x coordinate (update xDestination private variable).
	\param y new destination y coordinate (update yDestination private variable).
	\param rotateAngle new destination rotateAngle coordinate (update rotationDestination private variable).
	*/
	void goTo(double x, double y, double rotateAngle);
	//! Hover for one second (this function is rarely used).
	void hover();
	//! Hover for the set number of seconds.
	void hover(double time);
	//! Useless function [Fix Me !!].
	void stopHovering();
	//! Runs the control thread.
	/*! The basic idea of the control thread is simple:
		1) takeoff 	
		2) check if command given (hover if no command was given)
		3) if command was given: rotate to original heading (90 degree w.r.t. master camera view), move on x axis, move on y axis, then rotate to new angle.
	Due to the problematic compass readings, all rotation motions should be removed for now. Till the Raspberry Pis are attached to the drones.
	*/
	void run();
	//! Allows external entities to set the killSwitch flag to make the drone land.
	void landNow();
private:
	int DoExecute();
	void moveOnYAxisTo(double y, double x);
	void moveOnXAxisTo(double x, double y);
	void stablizeOrientation(double desiredOrientation, double tolerance, int relative);
	void upDown(int down, double time);
	void hover_stable(double time);
	
	void maintainHeliImage();

	double zeroOrientation;
	int droneId;
	TargetLocator * locator;
	CHeli * heli; 
	int TOLERANCE;
	CRawImage *imageMain;
	int i;
	int killSwitch;
	int hovering;
	int flying;

	SDL_Thread * thread;

	int moveCommandGiven;
	double xDestination;
	double yDestination;
	double rotationDestination;
};


#endif
