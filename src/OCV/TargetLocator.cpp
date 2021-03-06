/**
 * @file   TargetLocator.cpp
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  OpenCV part of the testbed. More in TargetLocator class description.
*/
#include <TargetLocator.h>

struct memoryStruct2 {
  char *memory;
  size_t size;
};

////////////// ADD TO CALIBRATOR

double TargetLocator::getOrientation(vector<Point> &pts, Mat &img)
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
 
    return atan2(eigen_vecs[0].y, eigen_vecs[0].x)*180/3.14;
}


static void* CURL_realloc2(void *ptr, size_t size)
{
  /* There might be a realloc() out there that doesn't like reallocing
     NULL pointers, so we take care of it here */
  if(ptr)
    return realloc(ptr, size);
  else
    return malloc(size);
}

size_t WriteMemoryCallbackTarget (void *ptr, size_t size, size_t nmemb, void *data)
{
  size_t realsize = size * nmemb;
  struct memoryStruct2 *mem = (struct memoryStruct2 *)data;

  mem->memory = (char *)
		CURL_realloc2(mem->memory, mem->size + realsize + 1);
  if (mem->memory) {
    memcpy(&(mem->memory[mem->size]), ptr, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;
  }
  return realsize;
}



void TargetLocator::morphOps(Mat &thresh){
	//create structuring element that will be used to "dilate" and "erode" image.
	//the element chosen here is a 3px by 3px rectangle

	Mat erodeElement = getStructuringElement( MORPH_RECT,Size(1,1));
    	//dilate with larger element so make sure object is nicely visible
	Mat dilateElement = getStructuringElement( MORPH_RECT,Size(12,12));

	erode(thresh,thresh,erodeElement);
	erode(thresh,thresh,erodeElement);


	dilate(thresh,thresh,dilateElement);
	dilate(thresh,thresh,dilateElement);
}


void TargetLocator::findReds( Mat& image, Mat& original, int targetId)
{


    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
 
    findContours(image, contours, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);

    std::vector<std::vector<cv::Point> > contours_poly( contours.size() );

    

    for( unsigned int i = 0; i < contours.size(); i++ )
    { 
        cv::approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
	currentTargetsOrientationV1[targetId][i] = getOrientation(contours[i], original);
    }

    vector<Moments> mu(contours_poly.size());
    for (unsigned int i = 0; i < contours_poly.size(); i++)
    {
        mu[i] = moments(contours_poly[i], false);
    }

    vector<Point2f> mc (contours_poly.size());
    for (unsigned int i = 0; i <contours_poly.size(); i++)
    {

        mc[i] = Point2f(mu[i].m10/mu[i].m00, mu[i].m01/mu[i].m00);
    }


    for(unsigned  int i = 0; i < contours_poly.size(); i++ )
    {
	circle(original, mc[i], 4, Scalar(255,0,0), -1, 8,0);
    }

    targetCount[targetId] = mu.size();
    if (mu.size() > 10)
	printf("WARNING: CHECK COLOR FILTERS - MORE THAN 10 TARGETS PER COLOR \n");


    for (int i = 0 ; i < mu.size() && i < 10; i ++)
    {
	currentTargetsX[targetId][i] = mu[i].m10/mu[i].m00;
        currentTargetsY[targetId][i] = mu[i].m01/mu[i].m00;
        targetVisible[targetId][i] = 1;

    }
    for (int i = mu.size(); i < 10; i++)
    {
        targetVisible[targetId][i] = 0;	
    }


/*    if(mu.size()>0)
    {
        currentTargetsX[targetId] = mu[0].m10/mu[0].m00;
        currentTargetsY[targetId] = mu[0].m01/mu[0].m00;
        targetVisible[targetId] = 1;
	//printf("Target # %d, at (%f,%f) \n",targetId, currentTargetsX[targetId], currentTargetsY[targetId] );
    }
    else
    {
        targetVisible[targetId] = 0;
    }*/
}


TargetLocator::TargetLocator(int numberOfTrackedObjects, int * h_min_in, int * h_max_in, int * s_min_in, int * s_max_in, int * v_min_in, int * v_max_in)
{
	stop=false;
	numberOfTargets = numberOfTrackedObjects;
	H_MIN = h_min_in;
	H_MAX = h_max_in;
	S_MIN = s_min_in;
	S_MAX = s_max_in;
	V_MIN = v_min_in;
	V_MAX = v_max_in;
	//targetCount = new int [numberOfTrackedObjects];
	//currentTargetsX = new double [numberOfTrackedObjects][10];
	//currentTargetsY =  new double [numberOfTrackedObjects][10];
        //targetVisible = new int[numberOfTrackedObjects][10];
	for (int q =0 ; q< numberOfTrackedObjects; q++)
	{
		targetCount[q] = 0; 
		for (int p = 0 ; p < 10 ; p ++)
		{
			currentTargetsX[q][p] = 0.0;
			currentTargetsY[q][p] = 0.0;
			targetVisible[q][p] = 0;
		}
	}
	//default capture width and height
	FRAME_WIDTH = 640;
	FRAME_HEIGHT = 480;
	//minimum and maximum object area
	MIN_OBJECT_AREA = 20*20;
	MAX_OBJECT_AREA = FRAME_HEIGHT*FRAME_WIDTH/1.5;

	curl = curl_easy_init(); // init CURL library object/structure
}

void TargetLocator::run()
{
	thread = SDL_CreateThread(StartThread,static_cast<void*>(this));
}

TargetLocator::~TargetLocator()
{
	stop = true;
	//delete currentTargetsX;
	//delete currentTargetsY;
	//delete targetVisible;
}



int TargetLocator::DoExecute()
{
	struct timeval start, end;

	long mtime, seconds, useconds;  
	//matrix storage for HSV image
	Mat HSV;
	//matrix storage for binary threshold image
	Mat threshold;

	cv::Mat image, dst; 	// image object
	memoryStruct2 buffer; // memory buffer

	int mnopq = 0;
	while(stop == false){
		buffer.memory = NULL;
	        buffer.size = 0;
		

		//gettimeofday(&start, NULL);
	        // (N.B. check this URL still works in browser in case image has moved)
	        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.200.102/axis-cgi/jpg/image.cgi");
		
		//gettimeofday(&end, NULL);

		//seconds  = end.tv_sec  - start.tv_sec;
		//useconds = end.tv_usec - start.tv_usec;

		//mtime = ((seconds) * 1000 + useconds/1000.0) + 0.5;

		//printf("Finished getting Elapsed time: %d milliseconds\n", mnopq);
		mnopq ++;



		
		gettimeofday(&start, NULL);
	        // tell libcurl where to write the image (to a dynamic memory buffer)
	        curl_easy_setopt(curl,CURLOPT_WRITEFUNCTION, WriteMemoryCallbackTarget);
	        curl_easy_setopt(curl,CURLOPT_WRITEDATA, (void *) &buffer);
	
	        // get the image from the specified URL
	        res = curl_easy_perform(curl);
		
	        // decode memory buffer using OpenCV
	        image = cv::imdecode(cv::Mat(1, buffer.size, CV_8UC1, buffer.memory), CV_LOAD_IMAGE_UNCHANGED);
		

		// SAEED // REMOVE HSV CONVERSION 
		//cvtColor(image,HSV,COLOR_BGR2HSV);
		

		for (int t=0; t < numberOfTargets; t++)
		{
			//filter HSV image between values and store filtered image to
			//threshold matrix

			// SAEED // REPLACE HSV WITH image
			//inRange(HSV,Scalar(H_MIN[t],S_MIN[t],V_MIN[t]),Scalar(H_MAX[t],S_MAX[t],V_MAX[t]),threshold);
			inRange(image,Scalar(H_MIN[t],S_MIN[t],V_MIN[t]),Scalar(H_MAX[t],S_MAX[t],V_MAX[t]),threshold);
			//perform morphological operations on thresholded image to eliminate noise
			//and emphasize the filtered object(s)
			morphOps(threshold);
			//pass in thresholded frame to our object tracking function
			//this function will return the x and y coordinates of the
			//filtered object
			//imshow(windowName2,threshold);	
			findReds(threshold, image, t);
		}

		//seconds  = end.tv_sec  - start.tv_sec;
		//useconds = end.tv_usec - start.tv_usec;

		//mtime = ((seconds) * 1000 + useconds/1000.0) + 0.5;

		//printf("Elapsed time: %ld milliseconds\n", mtime);*/


	}


	return 0;
}

double TargetLocator::getTargetX(int colorId){return currentTargetsX[colorId][0];}
double TargetLocator::getTargetY(int colorId){return currentTargetsY[colorId][0];}
int TargetLocator::isTargetVisible(int colorId){return targetVisible[colorId][0];}

uint32_t TargetLocator::getTargetCount(int colorId){return targetCount[colorId];}

double TargetLocator::getTargetX(int colorId, int targetId){return currentTargetsX[colorId][targetId];}
double TargetLocator::getTargetY(int colorId, int targetId){return currentTargetsY[colorId][targetId];}

double TargetLocator::getTargetOrientation(int colorId, int targetId){return currentTargetsOrientationV1[colorId][targetId];}
