/**
 * @file   MatlabConnector.h
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  Communicates with the main surveillance of CPS algorithm written in a matlab server. More details in MatlabConnector.
*/

#ifndef MATLAB_COM_H
#define MATLAB_COM_H

#include <stdio.h>


#include <sys/socket.h>
#include <netdb.h>
#include <string.h>
#include <iostream>

#include "TargetLocator.h"


using namespace std;

//!  The class that connects through sockets to a Matlab server to send it the targets coordinates and get the drones new locations.
/*!
This class assumes that there is a Matlab server (or any server that wraps the simulation code) running on the local machine listening on port 5000. The server is expected to be waiting first for the number of targets, then for the x coordinate followed by the y coordinate of each target. It then replies with the number of drones, followed by the x coordinate and y coordinate of each drone. 
*/
class MatlabConnector
{
public:
	//! Class constructor which starts the sockets communication with the server.
	MatlabConnector();
	//! Class destructor which halts the sockets communication with the server.
	~MatlabConnector();
	//! sends targets coordinates to the Matlab server and fills droneCoordinates array with drone coordinates as received from the server. [Fix Me!!]
	/*!
	This function queries the TargetLocator object itself to get the most recent coordinates of targets. All communication with the server is made by exchanging integers. We implement this in a very simply way, all doubles are multiplied by 100 at the sender then divided by 100 at the receiver. This is made at both the testbed code and at the server code. This simplifies communication significantly as the server in this case is written in Java wrapped in Matlab and the client is in C [Fix Me!!].
	\param droneCoordinates array to filled with drone coordinates. The maximum number of drones is 3. (output)
	\param numberOfDrones number of required drones as set by the server. (output)
	\param targetsColorID the color ID of the targets to query the TargetLocator. We assume that all targets have the same color. [Fix Me!!]
	\param locator the TargetLocator object which determines the location of the targets.
	*/
	void getDroneNewDist(double droneCoordinates [3][3], uint32_t & numberOfDrones, int targetsColorID, TargetLocator * locator);
private:
	int socketHandle;
};


#endif
