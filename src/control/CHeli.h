/**
 * @file   CHeli.h
 * @author Tom Krajnik (tkrajnik@lincoln.ac.uk) and updated by Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   2010 and June, 2014
 * @brief  The class that has low level representation of the drone. More details in CHeli.
*/

/*
 * Created on 2010 by Tom Krajnik
 * This class provides a basic interface to the AR-drone 
 * it envelopes the at commands, navdata and stream from ARDrone original SDK
 * the helidata structure (check app.h) contains the drone status 
 */


#include "stdio.h"
#include "CRawImage.h" 
#include "CImageClient.h" 
#include "ATCmd.h"
#include "navdataC.h"

typedef struct{
	int axis[6];
	bool buttons[11];
}TJoyState;



//!  The class provides a basic interface to the AR-drone it envelopes the at commands, navdata and stream from ARDrone original SDK.
/*!
Created on 2010 by Tom Krajnik. This class provides a basic interface to the AR-drone it envelopes the at commands, navdata and stream from ARDrone original SDK the helidata structure (check app.h) contains the drone status. However the older version that supported only one drone per run relied heavily on the functions in app.h. The updated version that allows for multiple drone instances, is more modular as ATCmd and NavadataC are now classes (not modules as in the older version). The new version allows for having different IPs for each drone and communicating with each separately.
*/
class CHeli
{
private:

public:
	//! The constructor which creates instance of ATCmd, NavadataC and CImageClient.
	/*!
	This class instanciates all low level drone handlers and assigns their parameters. As we cannot communicate with all drones on the same port. It also gives each drone a name which helps in logging events. 
	\param dIP drone IP.
	\param dName drone name for logging purposes.
	\param port communication port for AT commands and port+200 is the communication port for NavData.
	*/
	CHeli(char * dIP, char* dName, int port);
	~CHeli();

	//! resets the drone state, recalibrates sensors and takes off 
	void takeoff();				

	//! lands the drone
	void land();

	//! chooses the camera - 0-front, 1-bottom, 2,3-picture in picture mode
	void switchCamera(int camera); 		

	//! fills the "image" structure with the latest captured image, returns 0 (useless now and replaced by CImageClient).
	int renewImage(CRawImage* image);	

	//! sets the pitch, roll, yaw and vertical speed which are used to control all drone motion. Refer to google for more details on how to control the drone using angular velocities.
	void setAngles(float pitch, float roll,float yaw,float vertical);
	//! NavdataC instance used by others to query the readings from the drone's sensors.
	NavdataC * myNavdataReader;	
private:
	//closes communication with the drone 
	void close();			
	bool landed;
	int imageWidth,imageHeight;
	CImageClient *client;
	CRawImage *image;
	sem_t imageSem;

	ATCmd * myATCmdr;

};

