#include <ARDroneLocator.h>

//names that will appear at the top of each window
string windowName = "Original Image";
string windowName1 = "HSV Image";
string windowName2 = "Thresholded Image";
string windowName3 = "After Morphological Operations";
string wndname_2 = "Square Detection Demo";
string trackbarWindowName = "Trackbars";


struct memoryStruct {
  char *memory;
  size_t size;
};


static void* CURL_realloc(void *ptr, size_t size)
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
		CURL_realloc(mem->memory, mem->size + realsize + 1);
  if (mem->memory) {
    memcpy(&(mem->memory[mem->size]), ptr, realsize);
    mem->size += realsize;
    mem->memory[mem->size] = 0;
  }
  return realsize;
}


void on_trackbar( int, void* ){}



void ARDroneLocator::morphOps(Mat &thresh){
	//create structuring element that will be used to "dilate" and "erode" image.
	//the element chosen here is a 3px by 3px rectangle

	Mat erodeElement = getStructuringElement( MORPH_RECT,Size(3,3));
    	//dilate with larger element so make sure object is nicely visible
	Mat dilateElement = getStructuringElement( MORPH_RECT,Size(12,12));

	erode(thresh,thresh,erodeElement);
	erode(thresh,thresh,erodeElement);


	dilate(thresh,thresh,dilateElement);
	dilate(thresh,thresh,dilateElement);
}


void ARDroneLocator::findReds( Mat& image, Mat& original)
{


    std::vector<std::vector<cv::Point> > contours;
    std::vector<cv::Vec4i> hierarchy;
 
    findContours(image, contours, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);


    std::vector<std::vector<cv::Point> > contours_poly( contours.size() );

    for( int i = 0; i < contours.size(); i++ )
    { 
        cv::approxPolyDP( cv::Mat(contours[i]), contours_poly[i], 3, true );
	//const Point* p = &contours_poly[i][0];
        //int n = (int)contours_poly[i].size();
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
    if(mu.size()>0)
    {
        currentDroneX = mu[0].m10/mu[0].m00;
        currentDroneY = mu[0].m01/mu[0].m00;
        droneVisible = 1;
    }
    else
    {
        droneVisible = 0;
    }

    
    //imshow(wndname_2, original);   
}


ARDroneLocator::ARDroneLocator(int h_min_in, int h_max_in, int s_min_in, int s_max_in, int v_min_in, int v_max_in)
{
	stop=stopped=false;
//	H_MIN = 0;
//	H_MAX = 256;
//	S_MIN = 52;
//	S_MAX = 187;
//	V_MIN = 235;
//	V_MAX = 256;




//	H_MIN = 24;
//	H_MAX = 68;/
//	S_MIN = 77;
//	S_MAX = 256;
//	V_MIN = 155;
//	V_MAX = 256;


	H_MIN = h_min_in;
	H_MAX = h_max_in;
	S_MIN = s_min_in;
	S_MAX = s_max_in;
	V_MIN = v_min_in;
	V_MAX = v_max_in;


	currentDroneX = 0.0;
	currentDroneY = 0.0;
        droneVisible = 1;
	//default capture width and height
	FRAME_WIDTH = 640;
	FRAME_HEIGHT = 480;
	//minimum and maximum object area
	MIN_OBJECT_AREA = 20*20;
	MAX_OBJECT_AREA = FRAME_HEIGHT*FRAME_WIDTH/1.5;

	curl = curl_easy_init(); // init CURL library object/structure
	Size S = Size(FRAME_WIDTH,FRAME_HEIGHT);    
	//outputVideo.open("camera_up_top.avi", CV_FOURCC('P','I','M','1'), 20, S, true);  
	//if (!outputVideo.isOpened())
	//{
	//	cout  << "Could not open the output video for write: " << endl;
	//}

}

void ARDroneLocator::run()
{
	thread = SDL_CreateThread(StartThread,static_cast<void*>(this));
}

ARDroneLocator::~ARDroneLocator()
{
	stop = true;
}



int ARDroneLocator::DoExecute()
{
	//matrix storage for HSV image
	Mat HSV;
	//matrix storage for binary threshold image
	Mat threshold;

	cv::Mat image, dst; 	// image object
	memoryStruct buffer; // memory buffer

	while(stop == false){
		buffer.memory = NULL;
	        buffer.size = 0;

	        // (N.B. check this URL still works in browser in case image has moved)
	        curl_easy_setopt(curl, CURLOPT_URL, "http://192.168.200.102/axis-cgi/jpg/image.cgi");
		//curl_easy_setopt(curl, CURLOPT_URL, "http://files.myopera.com/papyleblues/albums/8125202/tour-de-pise.jpg");


	        // tell libcurl where to write the image (to a dynamic memory buffer)
	        curl_easy_setopt(curl,CURLOPT_WRITEFUNCTION, WriteMemoryCallback);
	        curl_easy_setopt(curl,CURLOPT_WRITEDATA, (void *) &buffer);
	
	        // get the image from the specified URL
	        res = curl_easy_perform(curl);

	        // decode memory buffer using OpenCV
	        image = cv::imdecode(cv::Mat(1, buffer.size, CV_8UC1, buffer.memory), CV_LOAD_IMAGE_UNCHANGED);
		

		cvtColor(image,HSV,COLOR_BGR2HSV);
		//filter HSV image between values and store filtered image to
		//threshold matrix

		inRange(HSV,Scalar(H_MIN,S_MIN,V_MIN),Scalar(H_MAX,S_MAX,V_MAX),threshold);
		//perform morphological operations on thresholded image to eliminate noise
		//and emphasize the filtered object(s)
		morphOps(threshold);
		//pass in thresholded frame to our object tracking function
		//this function will return the x and y coordinates of the
		//filtered object
		//imshow(windowName2,threshold);	
		findReds(threshold, image);
		//show frames 
		
		//imshow(windowName1,HSV);
		cv::resize(image,image,cv::Size(FRAME_WIDTH,FRAME_HEIGHT));
		//outputVideo << image;
		//outputVideo << image;

		//delay 30ms so that screen can refresh.
		//image will not appear without this waitKey() command
		usleep(3000);
	}


	return 0;
}


double ARDroneLocator::getDroneX(){return currentDroneX;}
double ARDroneLocator::getDroneY(){return currentDroneY;}
int ARDroneLocator::isDroneVisible(){return droneVisible;}
