/**
 * @file   heli.cpp
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  The main file that has all basic configurations. 
 *
 *  This file is more of a configuration file that a main. It has all configurations of the testbed: 1) color filters, 2) drones IPs, 3) number of Targets, and 4) drone control error tolerance. The drone control error tolerance gives the controlling code a bit of tolerance (in pixels) in placing the drone. Drone control has a lot of inherent errors, thus we can not actually place the drone perfectly in the place we want due to problematic control of cheap drones and errors in the localization technique. Hence, we give the controller some tolerance so it won't enter infinite loop trying to place the drone perfectly.


The code then calls the rest of the testbed functions (like communicating with matlab to get the drone locations) and then instantiates a number of drones to do the tasks required. It also destroys drone instance (which causes the physical drones to land) when the drone is no longer needed. We define a step as a unit where Matlab call is made, and then drones are instantiated and moved. Note that between each step the user must enter a newline in the console. This allows the testbed controller to move targets between steps to change the experiment layout. It also allows for a closer monitoring of the testbed. The code in this file is commented enough to point you in the right direction.
 */


#include <MatlabConnector.h>
#include <CoordinateController.h>
#include <TargetLocator.h>

#define MAX_NUMBER_OF_DRONES 3
#define PIXEL_TOLERANCE 10

typedef enum
{
	YELLOW 		= 0,
	RED 		= 1,
	GREEN 		= 2,
	BLUE		= 3,
} colorTagsIds;

int main(int argc,char* argv[])
{

MatlabConnector * matlabC;
TargetLocator * globalLocator;


CoordinateController * droneControllerArray [MAX_NUMBER_OF_DRONES];;
double droneCoordinates [MAX_NUMBER_OF_DRONES][3];
uint32_t oldNumberOfDrones = 0;
uint32_t currentNumberOfDrones = 0;
char *  droneIPs [3] = {"192.168.1.1","192.168.20.146", "192.168.20.110"};
char *  droneNames [3] = {"d1","d2","d3"};
int  droneColorId [3] = {YELLOW, RED , BLUE};
int  droneLocalPort [3] = {1000, 2000, 3000};
/////////////////////////// BEGIN CODE THAT REQUIRES MASTER CAMERA ////////////////////////////////////////
	// ARRAY OF ALL COLOR FILTERS
	//yellow, red, green, blue
	int r_min_in [4] = {0,0,0,254};
	int r_max_in [4] = {140,135,255,255};
	int g_min_in [4] = {211,0,145,248};
	int g_max_in [4] = {255,92,255,255};
	int b_min_in [4] = {209,166,000,217};
	int b_max_in [4] = {255,255,108,218};

	// Initiate Target and Drone Locator and supply all colors to be detected
	globalLocator = new TargetLocator (4, r_min_in, r_max_in, g_min_in, g_max_in, b_min_in, b_max_in);
	globalLocator->run();

	// Wait for 10 seconds as the human operator needs to monitor 
	// the drone up close and the locator needs to stablize 
	int t = 0;
	for (t = 0; t < 3; t++)
	{
		globalLocator->getTargetX(3);
		printf("WAITING \n");
		usleep(1000000);
	}

/////////////////////////// END CODE THAT REQUIRES THE MASTER CAMERA ////////////////////////////////////////


/////////////////////////// BEGIN CODE THAT REQUIRES MATLAB SERVER  ////////////////////////////////////////		

	// Initiate matlab connector (make sure you ran the matlab server)
	// matlab connector will supply number of drones and 	
	matlabC = new MatlabConnector();

	for (int lol = 0 ; lol < 3 ; lol++)
	{
		matlabC->getDroneNewDist(droneCoordinates, currentNumberOfDrones,  GREEN,globalLocator);
/////////////////////////// END CODE THAT REQUIRES MATLAB SERVER ////////////////////////////////////////
	
/////////////////////////// BEGIN CODE THAT REQUIRES DRONES ////////////////////////////////////////
		for (int i = oldNumberOfDrones; i< currentNumberOfDrones ; i++)
		{
			droneControllerArray[i] = new CoordinateController(globalLocator, PIXEL_TOLERANCE ,droneColorId[i], droneIPs[i], droneNames[i], droneLocalPort[i]);
			droneControllerArray[i]->run();
		}
		for (int i = currentNumberOfDrones; i<  oldNumberOfDrones; i++)
		{
			delete droneControllerArray[i];
		}
		oldNumberOfDrones = currentNumberOfDrones;
/////////////////////////// THIS CODE REQUIRES MATLAB AND LOCATOR TOO //////////////////////////////

		for (uint32_t i = 0 ; i < currentNumberOfDrones; i++)
		{
			droneControllerArray[i]->goTo(droneCoordinates[i][0],droneCoordinates[i][1], droneCoordinates[i][2]*1000);
		}	

/////////////////////////// BEGIN CODE THAT REQUIRES DRONES ////////////////////////////////////////	


		char b;
		printf("PRESS ANY KEY FOR NEXT STEP \n");
		b = getc(stdin);

	}
	usleep(5000000);
	printf("MAIN THREAD DONE \n");
	

	delete globalLocator;
	delete matlabC;  
	for (uint32_t i = 0; i<  currentNumberOfDrones; i++)
	{
		delete droneControllerArray[i];
	}

		
	return 0;
}

