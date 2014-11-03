/**
 * @file   CImageClient.cpp
 * @author Tom Krajnik (tkrajnik@lincoln.ac.uk) updated by Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   2014
 * @brief  The class reponsible for getting images from the drone and saving them as bmp files [Fix Me !! - Save as videos].
 *
*/

#include "CImageClient.h"

static unsigned char header2[] =  {66,77,54,16,14,0,0,0,0,0,54,0,0,0,40,0,0,0,128,2,0,0,224,1,0,0,1,0,24,0,0,0,0,0,0,16,14,0,18,11,0,0,18,11,0,0,0,0,0,0,0,0,0,0};

#define NETWORK_BLOCK MSG_WAITALL

CImageClient::CImageClient(sem_t *im,char * dName)
{
	droneName = dName;
	imageSem = im;	
	stop=stopped=false;
}

void CImageClient::run(CRawImage *im)
{
	image  = im;
	codec = new CDecoder(imageSem,im);
	thread = SDL_CreateThread(StartThread,static_cast<void*>(this));
}

CImageClient::~CImageClient()
{
	stop = true;
	int wait = 10;
	while (stopped == false && wait > 0){
	       	usleep(100000);
		wait--;
	}
	close(socketNumber);
	delete codec;
}

int CImageClient::connectServer(const char * ip,const char* port)
{
  int result = -1;
  socketNumber = socket(AF_INET, SOCK_STREAM, 0);
  if (socketNumber <0 )
  {
    return -1;
  }
  struct sockaddr_in server_addr;
  struct hostent *host_info;
  host_info =  gethostbyname(ip);
  if (host_info != NULL)
  {
    server_addr.sin_family = host_info->h_addrtype;
    memcpy((char *) &server_addr.sin_addr.s_addr,
           host_info->h_addr_list[0], host_info->h_length);
    server_addr.sin_port = htons(atoi(port));
    fprintf(stdout,"Connecting to %s:%s \n",ip,port);
    result = connect(socketNumber,(struct sockaddr*) &server_addr,sizeof(server_addr));
    if (result == 0)
    {
      fprintf(stderr,"Connection established.\n");
    }
    else
    {
      fprintf(stderr,"Connect error is %s \n",strerror(errno));
    }
  }
  return result;
}

int CImageClient::DoExecute()
{
//	cv::Mat image11;
//	cv::VideoWriter writer1 ("test.avi",CV_FOURCC('D','I','V','X'),20,cvSize(480,368), true); //initialize the VideoWriter object 


	parrot_video_encapsulation_t pave;
	unsigned int lengthReceived;
	unsigned int i=0, k=0;
	int numRuns = 0;
	unsigned int headerLength = 68;
	unsigned char *buf = (unsigned char*) malloc(1000000);
	while (stop == false){
		bool pavedetected = false;			
		lengthReceived = recv(socketNumber,buf,100000,NETWORK_BLOCK);
		i=0;
		for (i = 0;i<lengthReceived;i++){
			pavedetected = (memcmp(&buf[i],"PaVE",4)==0);
			if (pavedetected)
			{
				memcpy(&pave,&buf[i],headerLength);
				//fprintf(stdout,"Pave %c%c%c%c detected at %i - ",buf[i],buf[i+1],buf[i+2],buf[i+3],i);
				//fprintf(stdout,"%c%c%c%c: %05i - %ix%i - %i\n",pave.signature[0],pave.signature[1],pave.signature[2],pave.signature[3],pave.payload_size,pave.encoded_stream_width,pave.encoded_stream_height,pave.frame_type);

				if(lengthReceived - i + headerLength > pave.payload_size)
				{
					codec->decode(buf+i+68,pave.payload_size,pave.frame_type);
					char name[100];
					sprintf(name,"%s_%04i.bmp",droneName,k++);

					FILE* file = fopen(name,"wb");
					header2[18] = image->width%256;
					header2[19] = image->width/256;
					header2[22] = image->height%256;
					header2[23] = image->height/256;
					fwrite(header2,54,1,file);
					image->swap();
					fwrite(image->data,image->size,1,file);
					image->swap();
					fclose(file);
					i += pave.payload_size;
				}
								
			}
		}
		usleep(500000);
		continue;

	}
	free(buf);
	stopped = true;
	return numRuns;
}

