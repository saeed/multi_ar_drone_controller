/**
 * @file navdataC.cpp
 * @author Karl Leplat (karl.leplat.ext@parrot.com) updated by Ahmed Saeed and Tom Krajnik
 * @date 2009/07/01
 * @brief The class reponsible for getting navdata information from the drone.
 */



#include "navdataC.h"





/* Private variables */


//navdata_option_t* navdata_search_option( navdata_option_t* navdata_options_ptr, uint32_t tag );



void NavdataC::mykonos_navdata_unpack_all(navdata_unpacked_t* navdata_unpacked, navdata_t* navdata, uint32_t* cks)
{
    navdata_cks_t navdata_cks = { 0 };
    navdata_option_t* navdata_option_ptr;

    navdata_option_ptr = (navdata_option_t*) &navdata->options[0];

    memset( navdata_unpacked, 0, sizeof(*navdata_unpacked) );

    navdata_unpacked->mykonos_state   = navdata->mykonos_state;
    navdata_unpacked->vision_defined  = navdata->vision_defined;
    while( navdata_option_ptr != NULL )
        {
            // Check if we have a valid option
            if( navdata_option_ptr->size == 0 )
                {
                    INFO ("One option is not a valid because its size is zero\n");
                    navdata_option_ptr = NULL;
                }
            else
                {
                    switch( navdata_option_ptr->tag )
                        {
                        case NAVDATA_DEMO_TAG:
//			    memcpy(navdata_unpacked->navdata_demo,navdata_ptr,navdata_ptr->size);
                            navdata_option_ptr = navdata_unpack( navdata_option_ptr, navdata_unpacked->navdata_demo );
                            break;
        
                        case NAVDATA_IPHONE_ANGLES_TAG:
                            navdata_option_ptr = navdata_unpack( navdata_option_ptr, navdata_unpacked->navdata_iphone_angles );
                            break;

                        case NAVDATA_VISION_DETECT_TAG:
                            navdata_option_ptr = navdata_unpack( navdata_option_ptr, navdata_unpacked->navdata_vision_detect );
                            break;

                        case NAVDATA_CKS_TAG:
                            navdata_option_ptr = navdata_unpack( navdata_option_ptr, navdata_cks );
                            *cks = navdata_cks.cks;
			     navdata_option_ptr = NULL;
                            break;

                        default:
                            INFO ("Tag %d is not a valid navdata option tag\n", (int) navdata_option_ptr->tag);
                            navdata_option_ptr = NULL;
                            break;
                        }
                }
        }
}

navdata_unpacked_t navdata_unpacked;

void* navdata_loop(void *arg)
{

	NavdataC * navo = (NavdataC*) arg;
	uint8_t msg[NAVDATA_BUFFER_SIZE];
	int sockfd = -1, addr_in_size;
	unsigned int cks, navdata_cks, sequence = NAVDATA_SEQUENCE_DEFAULT-1;
	int size;
	int sendstuff=1;
	struct sockaddr_in *my_addr, *from;

	INFO("NAVDATA thread starting (thread=%d)...\n", (int)pthread_self());


	addr_in_size = sizeof(struct sockaddr_in);

	navdata_t* navdata = (navdata_t*) &msg[0];

	from = (struct sockaddr_in *)malloc(addr_in_size);
	my_addr = (struct sockaddr_in *)malloc(addr_in_size);
	assert(from);
	assert(my_addr);

	memset((char *)my_addr,(char)0,addr_in_size);
	my_addr->sin_family = AF_INET;
	my_addr->sin_addr.s_addr = INADDR_ANY;
	my_addr->sin_port = htons(NAVDATA_PORT + navo->portShift);

	if((sockfd = socket (AF_INET, SOCK_DGRAM, 0)) < 0){
        INFO ("socket: %s\n", strerror(errno));
        goto fail;
	};

	if(bind(sockfd, (struct sockaddr *)my_addr, addr_in_size) < 0){
        INFO ("bind: %s\n", strerror(errno));
        goto fail;
	};

	{
		struct timeval tv;
		// 1 second timeout
		tv.tv_sec   = 1;
		tv.tv_usec  = 0;
		setsockopt( sockfd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
	}

	struct sockaddr_in to;
        memset((char*)&to, 0, sizeof(to));
        to.sin_family       = AF_INET;
        to.sin_addr.s_addr  = inet_addr(navo->droneIP); 
        to.sin_port         = htons(NAVDATA_PORT);
        sendstuff = sendto( sockfd, (void*)&sendstuff, sizeof(sendstuff), 0, (struct sockaddr*)&to, sizeof(to) );
	INFO ("Send %i %s",sendstuff,strerror(errno));

	INFO("Ready to receive\n");

	while ( navo->nav_thread_alive ) {

		//INFO("NAVDATA THREAD ALIVE \n");
		size = recvfrom (sockfd, &msg[0], NAVDATA_BUFFER_SIZE, 0, (struct sockaddr *)from,(socklen_t *)&addr_in_size);
		if (size > 0){
			//INFO("NAVDATA THREAD ALIVE and Receving \n");
			if( navdata->header == NAVDATA_HEADER )
			{
				navo->myATCmdr->mykonos_state = navdata->mykonos_state;
				if( navo->get_mask_from_state(navdata->mykonos_state, MYKONOS_COM_WATCHDOG_MASK) ) 
				{ 
					//INFO ("[NAVDATA] Detect com watchdog\n");
					sequence = NAVDATA_SEQUENCE_DEFAULT-1; 

					if( navo->get_mask_from_state(navdata->mykonos_state, MYKONOS_NAVDATA_BOOTSTRAP) == FALSE ) 
					{	
						//printf("I GOT THIS FAR \n");
						const char cmds[] = "AT*COMWDG\r";
						navo->myATCmdr->at_write ((int8_t*)cmds, strlen( cmds ));
						//printf("I GOT THIS FAR 2 \n");
					}
				} 
				if( navdata->sequence > sequence ) 
				{ 
					if ( navo->get_mask_from_state(navo->myATCmdr->mykonos_state, MYKONOS_NAVDATA_DEMO_MASK ))
					{
						navo->mykonos_navdata_unpack_all(&navdata_unpacked, navdata, &navdata_cks);
						cks = navdata_compute_cks(&msg[0],size-sizeof(navdata_cks_t));
						if( cks == navdata_cks)
						{
							navo->helidata.phi =(double) navdata_unpacked.navdata_demo.phi;
							navo->helidata.psi = -(double)navdata_unpacked.navdata_demo.psi;
							navo->helidata.theta = (double)navdata_unpacked.navdata_demo.theta;
							navo->helidata.altitude = (double)navdata_unpacked.navdata_demo.altitude;
							navo->helidata.battery = (double)navdata_unpacked.navdata_demo.vbat_flying_percentage;
							navo->helidata.vx = (double)navdata_unpacked.navdata_demo.vx;
							navo->helidata.vy = -(double)navdata_unpacked.navdata_demo.vy;
							navo->helidata.vz = (double)navdata_unpacked.navdata_demo.vz;
							//printf("NAV DATA THETA %f, PHI %f, PSI %f \n",helidata.theta, helidata.phi, helidata.psi);
						}else{
							INFO ("CKS Mismatch\n");
						}
					}
				} 
				else 
				{ 
					INFO ("[Navdata] Sequence pb : %d (distant) / %d (local)\n", navdata->sequence, sequence); 
				} 
				//INFO ("[Navdata] Sequence pb : %d (distant) / %d (local)\n", navdata->sequence, sequence); 
				navdata = (navdata_t*) &msg[0];
				sequence = navdata->sequence;
				//printf("I GOT THIS FAR 3\n");
			}
		}
	}
 fail:
    free(from);
    free(my_addr);

    if (sockfd >= 0){
        close(sockfd);
    }

    if (navo->navdata_udp_socket >= 0){
        close(navo->navdata_udp_socket);
        navo->navdata_udp_socket = -1;
    }

	INFO("NAVDATA thread stopping\n");
    return NULL;
}

/* Public functions */
NavdataC::~NavdataC(  )
{

	if ( !nav_thread )
		return;
   
   nav_thread_alive = 0;
	pthread_join(nav_thread, NULL);
	nav_thread = 0;

	if (navdata_udp_socket >= 0){
		close(navdata_udp_socket);
		navdata_udp_socket = -1;
	}
}

NavdataC::NavdataC(ATCmd * atcmder, char * dIP, int port)
{
	portShift = port;
	droneIP = dIP;
	myATCmdr = atcmder;
   navdata_udp_socket  = -1;
   nav_thread = 0;
   nav_thread_alive = 1;

   if ( nav_thread )
      return;

   nav_thread_alive = 1;
	if ( pthread_create( &nav_thread, NULL, navdata_loop, this ) )
   {
		INFO("pthread_create: %s\n", strerror(errno));
	}
}


int NavdataC::get_mask_from_state( uint32_t state, uint32_t mask )
{
    return state & mask ? TRUE : FALSE;
}
