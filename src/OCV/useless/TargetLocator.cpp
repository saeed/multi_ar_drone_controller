#include <TargetLocator.h>

TargetLocator::TargetLocator()
{
}

TargetLocator::~TargetLocator()
{
}

void TargetLocator::getTargetsLocations (Mat img, double ** locations, int numberOfTargets)
{

    Mat t1 = imread("/target_queries/t1.png", CV_LOAD_IMAGE_GRAYSCALE);
    Mat t2 = imread("/target_queries/t2.png", CV_LOAD_IMAGE_GRAYSCALE);

    if(t1.empty() || img.empty() || t2.empty())
    {
        printf("Can't read one of the images\n");
        return -1;
    }

    // detecting keypoints
    SurfFeatureDetector detector(400);
    vector<KeyPoint> keypointsT1, keypointsT2, keypointsImg;
    detector.detect(t1, keypointsT1);
    detector.detect(t2, keypointsT2);
    detector.detect(img, keypointsImg);

    // computing descriptors
    SurfDescriptorExtractor extractor;
    Mat descriptorsT1, descriptorsT2, descriptorsImg ;
    extractor.compute(t1, keypointsT1, descriptorsT1);
    extractor.compute(t2, keypointsT2, descriptorsT2);
    extractor.compute(img, keypointsImg, descriptorsImg);

    // matching descriptors
    BFMatcher matcher(NORM_L2);
    vector<DMatch> matchesT1;
    vector<DMatch> matchesT2;
    matcher.match(descriptorsT1, descriptorsImg, matchesT1);
    matcher.match(descriptorsT2, descriptorsImg, matchesT2);

    // drawing the results
    //namedWindow("matches", 1);
    //Mat img_matches;
    //drawMatches(img1, keypoints1, img2, keypoints2, matches, img_matches);



//////////////////////////////////////////////////////////

	vector<Point2f> matched_points_T1;
	vector<KeyPoint> tmpKey = keypointsImg;  
	for (int kk = 0; kk < matchesT1.size() ; kk++)
	{
		matched_points.push_back (tmpKey[matchesT1[kk].trainIdx].pt);
	}
	Moments mu = moments( matched_points_T1, false);
	cout << "###########" << mu.m10/mu.m00 << "      " << mu.m01/mu.m00 << endl;
	



	vector<Point2f> matched_points_T1;
	vector<KeyPoint> tmpKey = keypointsImg;  
	for (int kk = 0; kk < matchesT1.size() ; kk++)
	{
		matched_points.push_back (tmpKey[matchesT1[kk].trainIdx].pt);
	}
	Moments mu = moments( matched_points_T1, false);
	cout << "###########" << mu.m10/mu.m00 << "      " << mu.m01/mu.m00 << endl;


//////////////////////////////////////////////////////////

}



