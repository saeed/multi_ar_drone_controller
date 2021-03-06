/**
 * @file ATCmd.h
 * @author Ahmed Saeed
 * @date 2014
 * @brief The class reponsible for sending AT commands to the drone.
 */


#ifndef ATCMD_H_INCLUDED
#define ATCMD_H_INCLUDED


#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <netdb.h>
#include <errno.h>
#include <arpa/inet.h>
#include <pthread.h>

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

#define AT_PORT                   5556
#define AT_BUFFER_SIZE            1024


#define MYKONOS_NO_TRIM							\
    ((1 << MYKONOS_UI_BIT_TRIM_THETA) |			\
	 (1 << MYKONOS_UI_BIT_TRIM_PHI) |			\
	 (1 << MYKONOS_UI_BIT_TRIM_YAW) |			\
	 (1 << MYKONOS_UI_BIT_X) |					\
	 (1 << MYKONOS_UI_BIT_Y))


typedef enum {
    MYKONOS_UI_BIT_AG             = 0, /* Button turn to left */
    MYKONOS_UI_BIT_AB             = 1, /* Button altitude down (ah - ab)*/
    MYKONOS_UI_BIT_AD             = 2, /* Button turn to right */
    MYKONOS_UI_BIT_AH             = 3, /* Button altitude up (ah - ab)*/
    MYKONOS_UI_BIT_L1             = 4, /* Button - z-axis (r1 - l1) */
    MYKONOS_UI_BIT_R1             = 5, /* Not used */
    MYKONOS_UI_BIT_L2             = 6, /* Button + z-axis (r1 - l1) */ 
    MYKONOS_UI_BIT_R2             = 7, /* Not used */
    MYKONOS_UI_BIT_SELECT         = 8, /* Button emergency reset all */
    MYKONOS_UI_BIT_START          = 9, /* Button Takeoff / Landing */
    MYKONOS_UI_BIT_TRIM_THETA     = 18, /* y-axis trim +1 (Trim increase at +/- 1??/s) */
    MYKONOS_UI_BIT_TRIM_PHI       = 20, /* x-axis trim +1 (Trim increase at +/- 1??/s) */
    MYKONOS_UI_BIT_TRIM_YAW       = 22, /* z-axis trim +1 (Trim increase at +/- 1??/s) */
    MYKONOS_UI_BIT_X              = 24, /* x-axis +1 */
    MYKONOS_UI_BIT_Y              = 28, /* y-axis +1 */
} mykonos_ui_bitfield_t;

typedef struct _radiogp_cmd_t {
  float32_t enable; 
  float32_t pitch; 
  float32_t roll;
  float32_t gaz; 
  float32_t yaw;
} radiogp_cmd_t;







static unsigned long get_time_ms(void)
{
	struct timeval tv;
	gettimeofday(&tv, NULL);
	return (tv.tv_sec*1000 + tv.tv_usec/1000);
}

//!  The class the represents AT commands communiction to a drone.
/*!
The class takes in the different parameters given by a CHeli instance and writes the correspoding AT command and send that command to the drone (MORE DOCUMENTATION IN ATCmd.cpp). <b> Note that following the flow of this class needs deep knowledge of how the SDK works and the format of AT commands </b>.
*/
class ATCmd
{
public:
	//! The constructor.
	/*! Initialize AT process.  
	\param dIP drone IP.
	\param port communication port for AT commands.
	*/
	ATCmd(char * dIP, int port );
	~ATCmd();
	//! Start the drone and make sure it works.
	void boot_drone(int attempt);
	//! Send AT*COMWDG
	void at_comwdg();
	//! Send AT command to the drone
	void at_write (int8_t *buffer, int32_t len);
	//void at_stop( void ); //destructor
	//void at_run( void ); //constructor
	//! Calibration of the ARDrone.
	void at_trim( void );
	//! Calibration of the ARDrone.
	void at_ui_reset( void );
	void at_zap(int cam);
	//! Take off / Land
	void at_ui_pad_start_pressed( void );
	//! Set angular velocities
	void at_set_radiogp_input( int32_t pitch, int32_t roll, int32_t gaz, int32_t yaw );
	//! Send pilot command
	void send_command(int nab_sequence);
	//! Get drone state
	int get_mask_from_state( uint32_t state, uint32_t mask );
//variables
	uint32_t user_input;
	unsigned long ocurrent;
	uint32_t mykonos_state;
	unsigned int nb_sequence ;
	int32_t at_thread_alive;

private:

//variables
	char str[AT_BUFFER_SIZE];
	char * droneIP;
	pthread_mutex_t at_cmd_lock;
	pthread_t at_thread ;
	int portShift;
	radiogp_cmd_t radiogp_cmd;
	int at_udp_socket ;
	int overflow;






};





#endif 

