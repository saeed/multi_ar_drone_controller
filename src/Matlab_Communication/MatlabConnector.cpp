/**
 * @file   MatlabConnector.cpp
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  Communicates with the main surveillance of CPS algorithm written in a matlab server.
*/

#include <MatlabConnector.h>



MatlabConnector::MatlabConnector()
{

	//////////////////////
	///////// SOCKETS ////
	//////////////////////
	struct sockaddr_in remoteSocketInfo;
	struct hostent *hPtr;

	char remoteHost [] ="localhost";
	int portNumber = 5000;
	
	bzero(&remoteSocketInfo, sizeof(sockaddr_in));  // Clear structure memory

	// Get system information

	if((hPtr = gethostbyname(remoteHost)) == NULL)
	{
		cerr << "System DNS name resolution not configured properly." << endl;
		cerr << "Error number: " << 111 << endl;
	}

	// create socket

	if((socketHandle = socket(AF_INET, SOCK_STREAM, 0)) < 0)
	{
		close(socketHandle);
	}

	// Load system information into socket data structures

	memcpy((char *)&remoteSocketInfo.sin_addr, hPtr->h_addr, hPtr->h_length);
	remoteSocketInfo.sin_family = AF_INET;
	remoteSocketInfo.sin_port = htons((u_short)portNumber);      // Set port number

	if(connect(socketHandle, (struct sockaddr *)&remoteSocketInfo, sizeof(sockaddr_in)) < 0)
	{
		close(socketHandle);
	}


}

MatlabConnector::~MatlabConnector()
{
	close(socketHandle);
}



void MatlabConnector::getDroneNewDist(double droneCoordinates [3][3], uint32_t & numberOfDrones, int targetsColorID, TargetLocator * locator)
{
	uint32_t targetCount;
	targetCount = locator->getTargetCount(targetsColorID);
	targetCount = htonl(targetCount);
	send(socketHandle, &targetCount, sizeof(uint32_t), 0);	
	targetCount = ntohl(targetCount);

	for (uint32_t i = 0 ; i <targetCount ; i++)
	{
		uint32_t tmp;

		tmp = (uint32_t)(locator->getTargetY(targetsColorID,i)*100.0);
		tmp = htonl(tmp);
		send(socketHandle, &tmp, sizeof(tmp), 0);

		tmp = (uint32_t)(locator->getTargetX(targetsColorID,i)*100.0);
		tmp = htonl(tmp);
		send(socketHandle, &tmp, sizeof(tmp), 0);

		
	}
	
	uint32_t droneCount;
	recv(socketHandle,&droneCount,sizeof(uint32_t),0);
	numberOfDrones = ntohl(droneCount);	
	cout << numberOfDrones <<endl;
	uint32_t droneXint, droneYint, droneAngleint;

	for (uint32_t i = 0 ; i < numberOfDrones ; i++)
	{
		recv(socketHandle,&droneXint,sizeof(uint32_t),0);
		droneXint = ntohl(droneXint);
		droneCoordinates[i][0] = droneXint/100.0;
		cout << droneCoordinates[i][0] << endl;

		recv(socketHandle,&droneYint,sizeof(uint32_t),0);
		droneYint = ntohl(droneYint);
		droneCoordinates[i][1] = droneYint/100.0;
		cout << droneCoordinates[i][1] << endl;

		recv(socketHandle,&droneAngleint,sizeof(uint32_t),0);
		droneAngleint = ntohl(droneAngleint);
		droneCoordinates[i][2] = droneAngleint/100.0;
		cout << droneCoordinates[i][2] << endl;

	}
}
