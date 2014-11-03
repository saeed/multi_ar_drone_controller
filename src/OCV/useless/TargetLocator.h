#include <stdio.h>
#include "opencv2/core/core.hpp"
#include "opencv2/features2d/features2d.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/nonfree/nonfree.hpp"
#include "opencv2/contrib/contrib.hpp"

#include <iostream>
using namespace std;

using namespace cv;


class TargetLocator:CThread
{
public:
	double** getTargetsLocations (Mat img1);
}
