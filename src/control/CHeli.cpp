/**
 * @file   CHeli.cpp
 * @author Tom Krajnik (tkrajnik@lincoln.ac.uk) and updated by Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   2010 and June, 2014
 * @brief  The class that has low level representation of the drone. More details in CHeli.
*/

#include "CHeli.h"

float saturation(float a,float b)
{
	if (a > b) return b;
	if (a < -b) return -b;
	return a;
}

CHeli::CHeli(char * dIP, char * dName, int port)
{
	landed = true;
	
	myATCmdr = new ATCmd(dIP, port);
	myNavdataReader = new NavdataC (myATCmdr, dIP, port +200);
	printf("NAVDATA CREATED \n");
//	appInit();
	imageWidth = 640;
	imageHeight = 368;
//	sem_init(&imageSem,0,1);
	client = new CImageClient(&imageSem, dName);
	
	client->connectServer(dIP,"5555");
        image = new CRawImage(imageWidth,imageHeight);
	client->run(image);
	printf("Image Running \n");
}

CHeli::~CHeli()
{
	delete client;
	delete image;
//	appDeinit();
}

void CHeli::takeoff()
{
	if (landed){
		usleep(100000);
		myATCmdr->at_ui_reset();
		usleep(200000);
		myATCmdr->at_trim();
		usleep(200000);
		fprintf(stdout,"Taking off");
		myATCmdr->at_ui_pad_start_pressed();
		usleep(100000);
		myATCmdr->at_comwdg();
		landed = false;
	}
}

void CHeli::switchCamera(int cam){
	myATCmdr->at_zap(cam);
}

void CHeli::land()
{
	if (landed ==false){
		usleep(100000);
		myATCmdr->at_ui_pad_start_pressed();
		usleep(100000);
		landed = true;
	}
}

void CHeli::close()
{
//	appDeinit();
}

int CHeli::renewImage(CRawImage* im)
{
//	sem_wait(&imageSem);
	memcpy(im->data,client->image->data,im->size);
//	sem_post(&imageSem);
	return 0;
}

void CHeli::setAngles(float ipitch, float iroll,float iyaw,float iheight)
{
	int32_t yaw,pitch,roll,height;

	yaw = saturation(iyaw,33000);
	roll = saturation(iroll,33000);
	pitch = saturation(ipitch,33000);
	height = saturation(iheight,33000);

//	fprintf(stdout,"Angle request: %d %d %d %d ",pitch,roll,height,yaw);
	myATCmdr->at_set_radiogp_input(roll,pitch,height,yaw);
}	
