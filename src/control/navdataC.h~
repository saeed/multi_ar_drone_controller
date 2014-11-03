/**
 * @file navdataC.h
 * @author by Ahmed Saeed
 * @date 2014
 * @brief The class reponsible for getting navdata information from the drone.
 */

#ifndef NAVDATA_H_INCLUDED
#define NAVDATA_H_INCLUDED



#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <netdb.h>
#include <errno.h>
#include <arpa/inet.h>
#include <assert.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>

#include <sys/time.h>

#include <fcntl.h>
#include <sys/ioctl.h>
#include <net/if.h>

#include "app.h"
#include "ATCmd.h"

/* Navdata constant */
#define NAVDATA_SEQUENCE_DEFAULT  1
#define NAVDATA_PORT              5554
#define NAVDATA_HEADER            0x55667788
#define NAVDATA_BUFFER_SIZE       2048 

typedef enum _navdata_tag_t {
    NAVDATA_DEMO_TAG = 0,
    NAVDATA_VISION_DETECT_TAG = 16,
    NAVDATA_IPHONE_ANGLES_TAG = 18,
    NAVDATA_CKS_TAG = 0xFFFF
} navdata_tag_t;

typedef struct _matrix33_t
{ 
    float32_t m11;
    float32_t m12;
    float32_t m13;
    float32_t m21;
    float32_t m22;
    float32_t m23;
    float32_t m31;
    float32_t m32;
    float32_t m33;
} matrix33_t;

typedef struct _vector31_t {
    union {
        float32_t v[3];
        struct    
        {
            float32_t x;
            float32_t y;
            float32_t z;
        };
    };
} vector31_t; 

typedef struct _navdata_option_t {
    uint16_t  tag;
    uint16_t  size;

    uint8_t   data[];
} navdata_option_t;
typedef struct _navdata_t {
    uint32_t    header;
    uint32_t    mykonos_state;
    uint32_t    sequence;
    int      vision_defined;

    navdata_option_t  options[1];
} __attribute__ ((packed)) navdata_t;

typedef struct _navdata_cks_t {
    uint16_t  tag;
    uint16_t  size;

    // Checksum for all navdatas (including options)
    uint32_t  cks;
} __attribute__ ((packed)) navdata_cks_t;

typedef struct _navdata_demo_t {
    uint16_t    tag;
    uint16_t    size;

    uint32_t    ctrl_state;             /*!< instance of #def_mykonos_state_mask_t */
    uint32_t    vbat_flying_percentage; /*!< battery voltage filtered (mV) */

    float32_t   theta;                  /*!< UAV's attitude */
    float32_t   phi;                    /*!< UAV's attitude */
    float32_t   psi;                    /*!< UAV's attitude */

    int32_t     altitude;               /*!< UAV's altitude */

    float32_t   vx;                     /*!< UAV's estimated linear velocity */
    float32_t   vy;                     /*!< UAV's estimated linear velocity */
    float32_t   vz;                     /*!< UAV's estimated linear velocity */

    uint32_t    num_frames;			  /*!< streamed frame index */

    // Camera parameters compute by detection
    matrix33_t  detection_camera_rot;
    matrix33_t  detection_camera_homo;
    vector31_t  detection_camera_trans;

    // Camera parameters compute by drone
    matrix33_t  drone_camera_rot;
    vector31_t  drone_camera_trans;
} __attribute__ ((packed)) navdata_demo_t;

typedef struct _navdata_iphone_angles_t {
    uint16_t   tag;
    uint16_t   size;

    int32_t    enable;
    float32_t  ax;
    float32_t  ay;
    float32_t  az;
    uint32_t   elapsed;
} __attribute__ ((packed)) navdata_iphone_angles_t;

typedef struct _navdata_time_t {
    uint16_t  tag;
    uint16_t  size;
  
    uint32_t  time;
} __attribute__ ((packed)) navdata_time_t;

typedef struct _navdata_vision_detect_t {
    uint16_t   tag;
    uint16_t   size;
  
    uint32_t   nb_detected;  
    uint32_t   type[4];
    uint32_t   xc[4];        
    uint32_t   yc[4];
    uint32_t   width[4];     
    uint32_t   height[4];    
    uint32_t   dist[4];      
} __attribute__ ((packed)) navdata_vision_detect_t;

typedef struct _navdata_unpacked_t {
    uint32_t  mykonos_state;
    int    vision_defined;
    navdata_demo_t           navdata_demo;
    navdata_iphone_angles_t  navdata_iphone_angles;
    navdata_vision_detect_t  navdata_vision_detect;
} navdata_unpacked_t;


static inline uint8_t* navdata_unpack_option( uint8_t* navdata_ptr, uint8_t* data, uint32_t size )
{
    memcpy(data, navdata_ptr, size);

    return (navdata_ptr + size);
}


static inline navdata_option_t* navdata_next_option( navdata_option_t* navdata_options_ptr )
{
    uint8_t* ptr;

    ptr  = (uint8_t*) navdata_options_ptr;
    ptr += navdata_options_ptr->size;

    return (navdata_option_t*) ptr;
}

static inline uint32_t navdata_compute_cks( uint8_t* nv, int32_t size )
{
    int32_t i;
    uint32_t cks = 0;
    for( i = 0; i < size; i++ )cks += nv[i];
    return cks;
}


#define navdata_unpack( navdata_ptr, option ) (navdata_option_t*) navdata_unpack_option( (uint8_t*) navdata_ptr, \
                                                                                         (uint8_t*) &option, \
                                                                                         navdata_ptr->size )


//!  The class the represents NAVData communiction with a drone. [Fix Me !! - This class's implementation can be improved significantly.]
/*!
This class keeps track of sensor readings for a drone sends AT commands using ATCmd intsance passed by the CHeli instance so that it can request updates. <b> Note that following the flow of this class needs deep knowledge of how the SDK works and the format of AT commands and NAVData data structures, however, this implementation hides all that from any casual user of the testbed</b>.
*/
class NavdataC
{
public:
	//! The constructor that sets all parameters and starts the navdata_loop thread [Fix Me !! - the threading should be embedded in the class like the rest of the classes] 
	/* \param atcmder the instance of ATCmd that communicates with the same drone this instance of NavdataC communicates with.
	\param dIP the IP of the drone
	\param port the navdata port which is a 200 shift from the at command port.
	*/
	NavdataC(ATCmd * atcmder, char * dIP, int port);
	~NavdataC();
	void mykonos_navdata_unpack_all(navdata_unpacked_t* navdata_unpacked, navdata_t* navdata, uint32_t* cks);
	int get_mask_from_state( uint32_t state, uint32_t mask );
//variables
	int navdata_udp_socket;
	int portShift;
	ATCmd * myATCmdr;
	SHeliData helidata;
	int32_t nav_thread_alive;
	char * droneIP;
private:
	pthread_t nav_thread;

};


#endif 
