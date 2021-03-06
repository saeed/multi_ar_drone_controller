/**
 * @file ATCmd.cpp
 * @author Karl Leplat (karl.leplat.ext@parrot.com) updated by Ahmed Saeed and Tom Krajnik
 * @date 2009/07/01
 * @brief The class reponsible for sending AT commands to the drone.
 */




/* AT constant */

#include "ATCmd.h"

#define MYKONOS_NO_TRIM				\
    ((1 << MYKONOS_UI_BIT_TRIM_THETA) |		\
	 (1 << MYKONOS_UI_BIT_TRIM_PHI) |	\
	 (1 << MYKONOS_UI_BIT_TRIM_YAW) |	\
	 (1 << MYKONOS_UI_BIT_X) |		\
	 (1 << MYKONOS_UI_BIT_Y))


void ATCmd::boot_drone(int attempt)
{
	char cmds[1000];
	INFO ("Attempting to boot \n");
	sprintf(cmds,"AT*CONFIG=%i,\"general:navdata_demo\",\"TRUE\"\r",nb_sequence++);
	nb_sequence = nb_sequence+2;
	at_write ((int8_t*)cmds, strlen (cmds));
	//printf (cmds);
	at_comwdg();
	if ( get_mask_from_state( mykonos_state,MYKONOS_NAVDATA_BOOTSTRAP)) {
		at_write ((int8_t*)cmds, strlen (cmds));

		int retry = 20;
		int bcontinue = true;
		int next = 0;
		while (bcontinue && retry) {
			if (next == 0) {
				if (get_mask_from_state(mykonos_state, MYKONOS_NAVDATA_BOOTSTRAP)) {
					INFO ("[CONTROL] Processing the current command ... \n");
					next++;
				}else{
					sprintf(cmds,"AT*CONFIG=%i,\"general:navdata_demo\",\"TRUE\"\r",nb_sequence++);
					at_write ((int8_t*)cmds, strlen (cmds));
				}
				fprintf(stdout,"Mykonos 1\n");
			}
			else {
/*				char str[AT_BUFFER_SIZE];
				memset (str, 0, AT_BUFFER_SIZE); 
				sprintf (str, "AT*CTRL=%d,%d\r", ACK_CONTROL_MODE, 0);
				at_write ((int8_t*)str, strlen (str));
				fprintf(stdout,"Mykonos 2\n");*/

				if ( !get_mask_from_state( mykonos_state, MYKONOS_COMMAND_MASK )) {
					INFO ("[CONTROL] Ack control event OK, send navdata demo\n");
					bcontinue = FALSE;
				}
			}
			usleep (100000);
			retry--;
		}
	}
	at_comwdg();
}

void* at_cmds_loop(void * atCmdObj)
{
	unsigned long current, deadline;
	ATCmd* atCmdr = (ATCmd*) atCmdObj;

	INFO("AT commands thread starting (thread=%ld)...\n", (intptr_t)pthread_self());

	atCmdr->user_input = MYKONOS_NO_TRIM;
	atCmdr->ocurrent = get_time_ms();
	while (atCmdr->at_thread_alive) {
		    
		if (atCmdr->get_mask_from_state(atCmdr->mykonos_state, MYKONOS_NAVDATA_BOOTSTRAP)) {
			atCmdr->boot_drone(atCmdr->nb_sequence++);
			continue;
		}

//		INFO("Comm_attempt %i\n",mykonos_state);
		// compute next loop iteration deadline
		deadline = get_time_ms() + MYKONOS_REFRESH_MS;

		// send pilot command
		atCmdr->send_command(0);

		// sleep until deadline
		current = get_time_ms();
		if (current < deadline) {
			usleep(1000*(deadline-current));
		}
	}

	INFO("AT commands thread stopping\n");
    return NULL;
}

void ATCmd::send_command(int nab_sequence)
{
	unsigned long current;

	// send command to drone
	current = get_time_ms();

	pthread_mutex_lock( &at_cmd_lock );
	int flag = 0;
	if (radiogp_cmd.pitch == 0 && radiogp_cmd.roll == 0) flag = 0; else flag = 1;
	snprintf(str, AT_BUFFER_SIZE, "AT*PCMD=%d,%d,%d,%d,%d,%d\r",nb_sequence++,flag,*(int*)&radiogp_cmd.pitch,*(int*)&radiogp_cmd.roll,*(int*)&radiogp_cmd.gaz,*(int*)&radiogp_cmd.yaw);
//	printf("AT*PCMD=%d,%i,%lf,%lf,%lf,%lf\n",nb_sequence++,flag,radiogp_cmd.pitch,radiogp_cmd.roll,radiogp_cmd.gaz,radiogp_cmd.yaw);
	pthread_mutex_unlock( &at_cmd_lock );
	at_write((int8_t*)str, strlen (str));

/*	pthread_mutex_lock( &at_cmd_lock );
	snprintf(str,AT_BUFFER_SIZE,"AT*COMWDG=%i\r",nb_sequence++);
	pthread_mutex_unlock( &at_cmd_lock );
	at_write((int8_t*)str, strlen (str));*/
	//snprintf(str,AT_BUFFER_SIZE,"AT*COMWDG=%i\r",nb_sequence);


	// check 30 ms overflow
	if (current > ocurrent + 30) {
		overflow += current - ocurrent - MYKONOS_REFRESH_MS;
	}
	ocurrent = current;

	/* dump command every 2s */
	if ((nb_sequence & 63) == 0) {
		pthread_mutex_lock( &at_cmd_lock );
		//INFO("seq=%d radgp(%f,%f,%f,%f) ui=0x%08x over=%d\n", nb_sequence,radiogp_cmd.pitch, radiogp_cmd.roll, radiogp_cmd.gaz, radiogp_cmd.yaw, user_input, overflow);
		pthread_mutex_unlock( &at_cmd_lock );
		overflow = 0;
	}
}

void ATCmd::at_comwdg()
{
	snprintf(str,AT_BUFFER_SIZE,"AT*COMWDG=%i\r",nb_sequence++);
	at_write((int8_t*)str, strlen (str));
}

void ATCmd::at_write (int8_t *buffer, int32_t len)
{
	struct sockaddr_in to;
	int32_t flags;

	//fprintf(stdout,"Prelock\n ");
	pthread_mutex_lock( &at_cmd_lock );
	//fprintf(stdout,"Pastlock\n ");
	if( at_udp_socket < 0 ) {
		struct sockaddr_in at_udp_addr;

		memset( (char*)&at_udp_addr, 0, sizeof(at_udp_addr) );
							 
		at_udp_addr.sin_family      = AF_INET;
		at_udp_addr.sin_addr.s_addr = inet_addr("192.168.1.3");
		at_udp_addr.sin_port        = htons( AT_PORT + portShift );

		at_udp_socket = socket( AF_INET, SOCK_DGRAM, 0 );

		if( at_udp_socket >= 0 )
		{
			flags = fcntl(at_udp_socket, F_GETFL, 0);
			if( flags >= 0 )
			{
				flags |= O_NONBLOCK;

				flags = fcntl(at_udp_socket, F_SETFL, flags );
			}
			else
			{
				INFO("Get Socket Options failed\n");
			}

			if (bind(at_udp_socket, (struct sockaddr*)&at_udp_addr, sizeof(struct sockaddr)) < 0) {
				INFO ("at_write:bind: %s\n", strerror(errno));
			}
		}
	}

	if( at_udp_socket >= 0 )
	{

		memset( (char*)&to, 0, sizeof(to) );
		to.sin_family       = AF_INET;
		to.sin_addr.s_addr  = inet_addr(droneIP); // BROADCAST address for subnet 192.168.1.xxx
		//printf("%s:%d\n", droneIP,AT_PORT);
		to.sin_port         = htons (AT_PORT);
		//printf("%s \n",buffer);
		sendto( at_udp_socket, (char*)buffer, len, 0, (struct sockaddr*)&to, sizeof(to) );
		buffer[strlen((char*)buffer)-1] = '\n';
		//fprintf(stdout,"Send %s \n",buffer);
	}
	//fprintf(stdout,"Prelock\n ");
	pthread_mutex_unlock( &at_cmd_lock );
	//fprintf(stdout,"Pastlock\n ");
}

/* Public functions */
ATCmd::~ATCmd(  )
{
	if ( !at_thread )
		return;
   
   at_thread_alive = 0;
	pthread_join(at_thread, NULL);
	at_thread = 0;
	pthread_mutex_destroy( &at_cmd_lock );

	if (at_udp_socket >= 0){
		close(at_udp_socket);
		at_udp_socket = -1;
	}
}

/************* at_init ****************
* Description : Initialize AT process.    
*/
ATCmd::ATCmd( char * dIP, int port )
{
	droneIP = dIP;
	portShift = port;
	user_input = MYKONOS_NO_TRIM;
	ocurrent = 0;
	mykonos_state = 0;
	nb_sequence = 1;
	at_thread = 0;
	at_thread_alive = 1;
	radiogp_cmd = {0};
	at_udp_socket  = -1;
	overflow = 0;

	if (at_thread)	return;

	/* Initialize mutex */
	if ( pthread_mutex_init( &at_cmd_lock, NULL ) != 0)
	{
		INFO("AT mutex init failed: %s\n", strerror(errno));
		return;
	}

	// AT cmds loop
	at_thread_alive = 1;
	if ( pthread_create( &at_thread, NULL, at_cmds_loop, this ) )
	{
		INFO("pthread_create: %s\n", strerror(errno));
	}
}


void ATCmd::at_trim( void )
{
	pthread_mutex_lock( &at_cmd_lock );
	snprintf(str, AT_BUFFER_SIZE, "AT*FTRIM=%d\r",nb_sequence++);
	pthread_mutex_unlock( &at_cmd_lock );
	at_write((int8_t*)str, strlen (str));
	usleep(100000);
	sprintf(str,"AT*CONFIG=%i,\"control:altitude_max\",\"5000\"\r",nb_sequence++);
	at_write((int8_t*)str, strlen (str));
}


void ATCmd::at_ui_reset( void )
{

	if (!at_thread)
		return;
	pthread_mutex_lock( &at_cmd_lock );
	user_input ^= 1 << MYKONOS_UI_BIT_SELECT;
	pthread_mutex_unlock( &at_cmd_lock );

	pthread_mutex_lock( &at_cmd_lock );
	snprintf(str, AT_BUFFER_SIZE, "AT*REF=%d,%d\r",nb_sequence++,user_input);
	pthread_mutex_unlock( &at_cmd_lock );
	at_write((int8_t*)str, strlen (str));
}

void ATCmd::at_zap(int cam)
{
	char str[1000];
	sprintf(str, "AT*CONFIG=%d,\"video:video_channel\",\"%d\"\r",nb_sequence++,cam);
	at_write ((int8_t*)str, strlen (str));
}

/************* at_ui_pad_start_pressed ****************
* Description : Takeoff/Landing, used with at_cmds_loop function.  
*/
void ATCmd::at_ui_pad_start_pressed( void )
{
	if (!at_thread)
		return;
	pthread_mutex_lock( &at_cmd_lock );
	user_input ^= 1 << MYKONOS_UI_BIT_START;
	pthread_mutex_unlock( &at_cmd_lock );

	pthread_mutex_lock( &at_cmd_lock );
	snprintf(str, AT_BUFFER_SIZE, "AT*REF=%d,%d\r",nb_sequence++,user_input);
	pthread_mutex_unlock( &at_cmd_lock );
	at_write((int8_t*)str, strlen (str));
}

void ATCmd::at_set_radiogp_input( int32_t pitch, int32_t roll, int32_t gaz, int32_t yaw )
{
	if (!at_thread)
		return;
	pthread_mutex_lock( &at_cmd_lock );
	radiogp_cmd.enable = 1.0;
	radiogp_cmd.pitch = pitch/33000.0;
	radiogp_cmd.roll = roll/33000.0;
	radiogp_cmd.gaz = -gaz/33000.0;
	radiogp_cmd.yaw = yaw/33000.0;
	pthread_mutex_unlock( &at_cmd_lock );
}


int ATCmd::get_mask_from_state( uint32_t state, uint32_t mask )
{
    return state & mask ? TRUE : FALSE;
}
