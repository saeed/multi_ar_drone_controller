/**
 * @file   CImageClient.h
 * @author Tom Krajnik (tkrajnik@lincoln.ac.uk) updated by Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   2014
 * @brief  The class reponsible for getting images from the drone and saving them as bmp files [Fix Me !! - Save as videos].
 *
*/

#ifndef CIMAGECLIENT_H
#define CIMAGECLIENT_H

#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <iostream>
#include <fcntl.h>
#include <errno.h>
#include "CRawImage.h"
#include "CDecoder.h"
#include "CThread.h" 
#include <semaphore.h> 

#include "opencv2/core/core.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"


typedef enum
{
	CMD_NONE = 0,
	CMD_IMAGE,
	CMD_COMPRESS,
	CMD_START_TRACK,
	CMD_STOP_TRACK,
	CMD_QUIT,
	CMD_NUMBER
}
TCommandType;
//!  The class the is repsonsible for receiving images from the drone.
/*!
The class the is repsonsible for receiving images from the drone, decodes them, and saves them as a series of BMP files. It runs a separate thread that doesn't interact with any other part of the testbed. However, any computer vision processing made on the drone's footage should communicate with this thread.
*/
class CImageClient:CThread
{
public:
    CImageClient(sem_t *im, char * dName);
    ~CImageClient();

    //! Connect to the drone's image server.
    int connectServer(const char * ip,const char* port);
    //! Run the drone image processing main thread.
    void run(CRawImage* image);
    //! CRawImage object to be updated with the latest image from the drone   
    CRawImage* image;

private:
    int DoExecute();
    int socketNumber;
    CDecoder* codec;
    SDL_Thread * thread;
    bool stop,stopped;
    sem_t *imageSem;
    char * droneName;
};

#endif
