/**
 * @file   calibrator2.cpp
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  A Calibrator to Determine Filtering Paramters. 
 *
 *  This is a simple program that allows for detecting the filtering parameters for each of the colors that are used later by the master camera localization program.
  The program also allows for the detection of the orientation of each of the detected objects (yellow is the orientation). The program continously pulls footage from
  the camera and process each frame it pulls. This file is an extantion to the object tracking tutorial by Kyle Hounslow and uses the principal component analysis tutorial for OpenCV made by Robospace.
 */


/**
@mainpage
This program contains all files required to run the testbed. The testbed uses a master camera that is assumed to be at 192.168.200.102. Images are pullsed from the camera and processed by applying color filters to detect the location of the drones and the targets. A Matlab server processes the coordinates of the targets and determines the location of the drones. The drones are then controlled to move from their current location to the new location by moving first on the X-axis then on the Y-axis. This project is based on the work in <i><b>"Krajník, Tomáš, et al. "AR-drone as a platform for robotic research and education." Research and Education in Robotics-EUROBOT 2011. Springer Berlin Heidelberg, 2011. 172-186."</b></i> and some OpenCV tutorials. However, it was extended to allow for simultanious deployment of multiple drones and video decoding from the drone was made a bit faster to make decoding videos from multiple drones possible. Most of the older code is written by <a href="http://labe.felk.cvut.cz/~tkrajnik/">Tom Krajnik</a>. 

Samples of experiments made using this code can be found in : <a href="http://www.youtube.com/watch?v=9pDZtdtGm2g">Video 1</a>, <a href="http://www.youtube.com/watch?v=RRnp6REtDP8">Video 2</a>, and <a href="http://www.youtube.com/watch?v=OZhdTNw5eXM">Video 3</a>.

<h3>AR Drone Summary:</h3>

To control a single drone, 3 threads are required to allow for full control. The first thread (encapsulated by ATCmd) sends AT commands to the drone to control it. AT commands are generally responsible for controlling the drone's motion (e.g. take off, land, and changing it's angular velocities). It also allows you to update some of its parameters. If you are to edit this code significantly, you need to read more about AT commands in the <a href="http://www.msh-tools.com/ardrone/ARDrone_Developer_Guide.pdf">AR Drone SDK Developer Guide</a>. The second thread (encapsulated by NavdataC) is responsible for querying the state of the drone and its sensors to fill the navdata_unpacked structure, more details are available in the developers guide and the SDK documentation. The third thread (encapsulated by CImageClient) is responsible for getting, decoding, and recording images from the drone's cameras. All these threads are wrapped in the CHeli class. An instance of CHeli represents a physical drone. Thus we need one of these for each drone we create. CHeli class has functions like CHeli::takeoff(), CHeli::land(), and CHeli::setAngles() to control the drone. However, the controlling algorithm is wrapped implemented inside the CoordinateController and it is the only instance the main class needs to see to represent each drone. This separation allows for updating he controlling algorithm without touching the lower level classes representing the drone. It also allows for making the drone classes independent of any parameters required by the control algorithm.


<h3>For computer vision summary refer to calibrator2.cpp.</h3>

<h3>Pay careful attention to the following things while deploying the testbed:</h3>
- the drone must always be set at 90 degrees with respect to the view of the master camera.
- make sure that the starting location of the drone not close to the border of the master camera's view so that when it lefts off it doesn't go out view (remember that the view of the camera is cone shaped).
- make sure to supply the correct color tags and IPs of the drones to the main file found in "main" directory
- at the begining of each experiement, you will have to log on to the drone and execute a script that makes it dropout of the AccesPoint mode and join your local WiFi network. 
- at the begining of each experiement, you will have to execute the calibrator by executing the compile.sh script in "Calibrator" directory. The calibrator program allows you to make sure that you have the right view for the master camera. It also allows you to modify the color filters so you can get the best colors for your deployment.
*/




#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"


#include <sstream>
#include <curl/curl.h>
#include <iostream>


#include <math.h>
#include <string.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

using namespace cv;
using namespace std;
//initial min and max HSV filter values.
//these will be changed using trackbars
int H_MIN = 1;  //!< Minimum Hue or Red filter value
int H_MAX = 256; //!< Maximum Hue or Red filter value
int S_MIN = 1; //!< Minimum Saturation or Green filter value
int S_MAX = 256; //!< Maximum Saturation or Green filter value
int V_MIN = 1; //!< Minimum Value or Blue filter value
int V_MAX = 256; //!< Maximum Value or Blue filter value

//names that will appear at the top of each window
const string windowName = "Original Image";
const string windowName1 = "HSV Image";
const string windowName2 = "Thresholded Image";
const string windowName3 = "After Morphological Operations";
const char* wndname = "Square Detection Demo";
const string trackbarWindowName = "Trackbars";

Mat image; //!< Main image pulled from the master camera's URL using curl command  

/// Determines and prints the angle of each detected object.
/** This function is based on Robospace's tutorial on principal component analysis for OpenCV. The function detects the two significant eign vectors of the contour of the detected objects and draws the lines representing both vectors (the length and color shows which is which).
\param pts the contour of the detected object which is detected in findObjects() function.
\param img the image structure to draw on.
*/
void getOrientation(vector<Point> &pts, Mat &img)
{
    //Construct a buffer used by the pca analysis
    Mat data_pts = Mat(pts.size(), 2, CV_64FC1);
    for (int i = 0; i < data_pts.rows; ++i)
    {
        data_pts.at<double>(i, 0) = pts[i].x;
        data_pts.at<double>(i, 1) = pts[i].y;
    }
 
    //Perform PCA analysis
    PCA pca_analysis(data_pts, Mat(), CV_PCA_DATA_AS_ROW);
 
    //Store the position of the object
    Point pos = Point(pca_analysis.mean.at<double>(0, 0),
                      pca_analysis.mean.at<double>(0, 1));
 
    //Store the eigenvalues and eigenvectors
    vector<Point2d> eigen_vecs(2);
    vector<double> eigen_val(2);
    for (int i = 0; i < 2; ++i)
    {
        eigen_vecs[i] = Point2d(pca_analysis.eigenvectors.at<double>(i, 0),
                                pca_analysis.eigenvectors.at<double>(i, 1));
 
        eigen_val[i] = pca_analysis.eigenvalues.at<double>(0, i);
    }
 
    // Draw the principal components
    circle(img, pos, 3, CV_RGB(255, 0, 255), 2);
    line(img, pos, pos + 0.02 * Point(eigen_vecs[0].x * eigen_val[0], eigen_vecs[0].y * eigen_val[0]) , CV_RGB(255, 255, 0),10);
    line(img, pos, pos + 0.02 * Point(eigen_vecs[1].x * eigen_val[1], eigen_vecs[1].y * eigen_val[1]) , CV_RGB(0, 255, 255),10);

    cout << atan2(eigen_vecs[0].y, eigen_vecs[0].x)*180/3.14 << endl;
//    return atan2(eigen_vecs[0].y, eigen_vecs[0].x);
}

///// Start CURL UTILs /////

struct memoryStruct {
  char *memory;
  size_t size;
};

static void* CURLRealloc(void *ptr, size_t size)
{
  /* There might be a realloc() out there that doesn't like reallocing
     NULL pointers, so we take care of it here */
  if(ptr)
    return realloc(ptr, size);
  else
    return malloc(size);
}

size_t WriteMemoryCallback (void *ptr, size_t size, size_t nmemb, void *data)
{
  size_t realsize = size * nmemb;
  struct memoryStruct *mem = (struct memoryStruct *)data;

  mem->memory = (char *)
		CURLRealloc(mem->memory, mem->size + realsize + 1);
  if (mem->memory) {
    memcpy(&(mem->memory[mem->size]), ptr, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;
  }
  return realsize;
}

///// End CURL UTILs /////


///// Start My Utils /////
void onTrackbar( int, void* )
{//This function gets called whenever a
 // trackbar position is changed
 // and we never use that
}

string intToString(int number){
	std::stringstream ss;
	ss << number;
	return ss.str();
}
///// End My Utils /////


/// Creates the trackbars window that control the color filtering thresholds.
void createTrackbars(){
	//create window for trackbars
	namedWindow(trackbarWindowName,0);
	//create memory to store trackbar name on window
	char TrackbarName[50];
	sprintf( TrackbarName, "H_MIN", H_MIN);
	sprintf( TrackbarName, "H_MAX", H_MAX);
	sprintf( TrackbarName, "S_MIN", S_MIN);
	sprintf( TrackbarName, "S_MAX", S_MAX);
	sprintf( TrackbarName, "V_MIN", V_MIN);
	sprintf( TrackbarName, "V_MAX", V_MAX);
	//create trackbars and insert them into window
	//3 parameters are: the address of the variable that is changing when the trackbar is moved(eg. H_LOW),
	//the max value the trackbar can move (eg. H_HIGH), 
	//and the function that is called whenever the trackbar is moved(eg. onTrackbar)
	//                                  ---->    ---->     ---->      
	createTrackbar( "H_MIN", trackbarWindowName, &H_MIN, H_MAX, onTrackbar );
	createTrackbar( "H_MAX", trackbarWindowName, &H_MAX, H_MAX, onTrackbar );
	createTrackbar( "S_MIN", trackbarWindowName, &S_MIN, S_MAX, onTrackbar );
	createTrackbar( "S_MAX", trackbarWindowName, &S_MAX, S_MAX, onTrackbar );
	createTrackbar( "V_MIN", trackbarWindowName, &V_MIN, V_MAX, onTrackbar );
	createTrackbar( "V_MAX", trackbarWindowName, &V_MAX, V_MAX, onTrackbar );
}


/// Performs morphing operations on objects to facilitate detection.
/** This function takes in the image after being filtered. Its purpose is to facilitate detecting objects correctly by removing noisy points that match the filtering paramters but are too small to be of interest. Also, it makes large areas larger so that any noise within the object of interest that doesn't match the filtering parameters are removed. In particular, small areas that match the color of interest (i.e. noise) are eroded and removed and large areas that match the color of interest are made larger for easier detection and fusion to eleminate noise.
\param thresh the image after filtering using inRange() function.
*/
void morphOps(Mat &thresh){

	//create structuring element that will be used to "dilate" and "erode" image.
	//the element chosen here is a 1px by 1px rectangle
	Mat erodeElement = getStructuringElement( MORPH_RECT,Size(1,1));
	//dilate with larger element so make sure object is nicely visible
	Mat dilateElement = getStructuringElement( MORPH_RECT,Size(12,12));

	erode(thresh,thresh,erodeElement);
	erode(thresh,thresh,erodeElement);


	dilate(thresh,thresh,dilateElement);
	dilate(thresh,thresh,dilateElement);
}

/// Detects the contours of the objects that match the color parameters and detects their orientation as well.
/** This function takes in the image after being filtered and morphed to detect the contours of the objects of interest. It uses OpenCV's findContours(). It also finds the centroid of each of the detected contours as that is used to represent the location of the detected object. Moreover, the function draws a blue circle that represents that location and uses getOrientation() to draw the axis representing the contours orientation.
\param image the filtered and morphoed image
\param original the original image to draw on
*/
void findObjects( Mat& image, Mat& original)
{
	std::vector<std::vector<cv::Point> > contours;
	std::vector<cv::Vec4i> hierarchy;

	findContours(image, contours, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);
	std::vector<std::vector<cv::Point> > contours_poly( contours.size() );

	for( int i = 0; i < contours.size(); i++ )
	{ 
		cv::approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
		const Point* p = &contours_poly[i][0];
		int n = (int)contours_poly[i].size();
		getOrientation(contours[i], original);
		//polylines(image, &p, &n, 1, true, Scalar(0,255,0), 3, CV_AA);
	}

	vector<Moments> mu(contours_poly.size());
	for (int i = 0; i < contours_poly.size(); i++)
	{
		mu[i] = moments(contours_poly[i], false);
	}

	vector<Point2f> mc (contours_poly.size());
	for (int i = 0; i <contours_poly.size(); i++)
	{
		mc[i] = Point2f(mu[i].m10/mu[i].m00, mu[i].m01/mu[i].m00);
	}


	for( int i = 0; i < contours.size(); i++ )
	{
		circle(original, mc[i], 4, Scalar(255,0,0), -1, 8,0);
	}
	if (mu.size() > 0)
	{ 
		// cout << mu[0].m10/mu[0].m00 << " &"  << mu[0].m01/mu[0].m00 << endl;
	}

	imshow(wndname, original);   
}



/// The main function that pulls images from the camera and process them to detect objects.
/** This function pulls images from the master camera through the cameras CGI ever 30 ms. The image is then decoded, filtered, morphed, and then used to detect objects of interest that match the color of the filter. 
*/


int main(int argc, char* argv[])
{
	//matrix storage for HSV image
	Mat HSV;
	//matrix storage for binary threshold image
	Mat threshold;
	//create slider bars for HSV filtering
	createTrackbars();
	
	CURL *curl;       // CURL objects
	CURLcode res;
	cv::Mat image, dst; 	// image object
	memoryStruct buffer; // memory buffer

	curl = curl_easy_init(); // init CURL library object/structure

	while(1){
		buffer.memory = NULL;
	        buffer.size = 0;
	
	        // (N.B. check this URL still works in browser in case image has moved)
	        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.200.102/axis-cgi/jpg/image.cgi");
	        //curl_easy_setopt(curl, CURLOPT_VERBOSE, 1); // tell us what is happening

	        // tell libcurl where to write the image (to a dynamic memory buffer)
	        curl_easy_setopt(curl,CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
	        curl_easy_setopt(curl,CURLOPT_WRITEDATA, (void *) &buffer);
	
	        // get the image from the specified URL
	        res = curl_easy_perform(curl);

	        // decode memory buffer using OpenCV
	        image = cv::imdecode(cv::Mat(1, buffer.size, CV_8UC1, buffer.memory), CV_LOAD_IMAGE_UNCHANGED);
		
		//We used to convert the image to HSV instead of RGB 
		//cvtColor(image,HSV,COLOR_BGR2HSV);
		
		//filter HSV image between values and store filtered image to
		//threshold matrix
		inRange(image,Scalar(H_MIN,S_MIN,V_MIN),Scalar(H_MAX,S_MAX,V_MAX),threshold);
		//perform morphological operations on thresholded image to eliminate noise
		//and emphasize the filtered object(s)
		morphOps(threshold);
		imshow(windowName2,threshold);

		//pass in thresholded frame to our object tracking function
		//this function will return the x and y coordinates of the
		//filtered object
		findObjects(threshold, image);

		//show frames 
		imshow(windowName1,image);


		//delay 30ms so that screen can refresh.
		//image will not appear without this waitKey() command
		waitKey(30);
	}

	return 0;
}

