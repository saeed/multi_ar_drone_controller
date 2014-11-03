#ifndef DRONE_LOCATOR_H
#define DRONE_LOCATOR_H

#include "CThread.h" 
#include <semaphore.h> 
#include "CRawImage.h"
#include "CDecoder.h"

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


class ARDroneLocator:CThread
{
public:
	ARDroneLocator(int h_min_in, int h_max_in, int s_min_in, int s_max_in, int v_min_in, int v_max_in);
	~ARDroneLocator();

	void run();
	double getDroneX();
	double getDroneY();
	int isDroneVisible();

private:
	int DoExecute();
	void morphOps(Mat &thresh);
	void findReds( Mat& image, Mat& original);

	VideoWriter outputVideo;                                        // Open the output

	SDL_Thread * thread;
	bool stop,stopped;
	CURL *curl;       // CURL objects
	CURLcode res;


	int H_MIN;
	int H_MAX;
	int S_MIN;
	int S_MAX;
	int V_MIN;
	int V_MAX;

	double currentDroneX;
	double currentDroneY;
	int droneVisible;
	//default capture width and height
	int FRAME_WIDTH;
	int FRAME_HEIGHT;
	//minimum and maximum object area
	int MIN_OBJECT_AREA;
	int MAX_OBJECT_AREA;


};


#endif
