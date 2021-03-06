/**
 * @file   CoordinateController.cpp
 * @author Ahmed Saeed (ahmed.saeed@gatech.edu)
 * @date   June, 2014
 * @brief  Main controller of the drone. More details in CoordinateController.
*/

#include <CoordinateController.h>




CoordinateController::CoordinateController(TargetLocator * lc, int tol, int id, char * dIP, char * dName, int port)
{	
	droneId = id;
	locator= lc;
	TOLERANCE = tol;

	heli = new CHeli(dIP, dName, port);
	flying= 0;
	i =0;
	killSwitch = 0;
	hovering =0;
	moveCommandGiven = 0;
}

CoordinateController::~CoordinateController()
{
	killSwitch = 1;
	while(flying){}
	delete heli;
}

void CoordinateController::stopHovering()
{
	hovering = 0;
}



void CoordinateController::hover()
{
	hovering = 1;
	if (killSwitch)
	{
		printf("I CAN'T FIND IT \n");
		return;
	}
	while (hovering)
	{
		heli->setAngles(0.0,0.0,0.0,0.0);	
		usleep(10000*100);
	}
}


void CoordinateController::hover(double time)
{
	if (killSwitch)
	{
		printf("I CAN'T FIND IT \n");
		return;
	}
	int outOfViewCounter = 0;
	int xx = (int) (time / 100);
	for (int q = 0; q < xx ; q++)
	{
		if (locator->isTargetVisible(droneId) == 0 )
		{
			printf("KILLING IT !! \n");
			outOfViewCounter++;
			if(outOfViewCounter >2)
			{
				//emergency landing 
				heli->land();
				killSwitch = 1;
				printf("I CAN'T FIND IT \n");
				break;
			}
		}

		heli->setAngles(0.0,0.0,0.0,0.0);	
		usleep(1000000);
	}
}




void CoordinateController::hover_stable(double time)
{
	if (killSwitch)
	{
		printf("I CAN'T FIND IT \n");
		return;
	}
	double initialAngle = 	heli->myNavdataReader->helidata.psi;
	int xx = (int) (time / 100);
	int outOfViewCounter = 0;
	for (int q = 0; q < xx ; q++)
	{
		if (locator->isTargetVisible(droneId) == 0 )
		{
			printf("KILLING IT !! \n");
			outOfViewCounter++;
			if(outOfViewCounter >2)
			{
				//emergency landing 
				heli->land();
				killSwitch = 1;
				printf("I CAN'T FIND IT \n");
				break;
			}
		}

		heli->setAngles(0.0,0.0,0.0,0.0);	
		stablizeOrientation(initialAngle, 5000, 0);
		usleep(1000000);
	}
}

void CoordinateController::moveOnYAxisTo(double y, double x)
{
	if (killSwitch)
	{
		printf("I CAN'T FIND IT \n");
		return;
	}
	double currentY, currentX, originalX, xDrift = 0.0;
	originalX = x;
	currentY = locator->getTargetY(droneId);
	int outOfViewCounter = 0;	
	while (y > currentY+TOLERANCE || y <= currentY-TOLERANCE)
	{
		if (locator->isTargetVisible(droneId) == 0 )
		{
			printf("KILLING IT !! \n");
			outOfViewCounter++;
			if(outOfViewCounter >4)
			{
				//emergency landing 
				heli->land();
				killSwitch = 1;
				printf("I CAN'T FIND IT \n");
				break;
			}
		}
		else
		{
			outOfViewCounter = 0;
		}


		if(y <= currentY)
		{
			//printf("moving to the front \n");
			heli->setAngles(-3000.0,xDrift,0.0,0.0);
		}
		else
		{
			//printf("moving to the back \n");
			heli->setAngles(3000.0,xDrift,0.0,0.0);
		}

		currentX = locator->getTargetX(droneId);
		currentY = locator->getTargetY(droneId);

		//adjust errors in the y axis
		if(originalX+TOLERANCE < currentX)
		{
			if(xDrift < 0 && xDrift >= -1500.0) xDrift -= 500.0;
			else xDrift = -500.0;
			//printf("Realized x drift to the right\n Adjusting ..  \n");
		}
		else if(originalX-TOLERANCE >= currentX)
		{
			if(xDrift > 0 && xDrift <= 1500.0) xDrift += 500.0;
			else xDrift = 500.0;
			//printf("Realized x drift to the left\n Adjusting ..  \n");
		}
		//maintainHeliImage();
		usleep(20000);
	}
}



void CoordinateController::moveOnXAxisTo(double x, double y)
{

	if (killSwitch)
	{
		printf("I CAN'T FIND IT \n");
		return;
	}
	double currentY, currentX, originalY, yDrift = 0.0;
	 currentX = locator->getTargetX(droneId);
	originalY = y;
	int outOfViewCounter = 0;	
		
	while (x > currentX+TOLERANCE || x <= currentX-TOLERANCE)
	{
		if (locator->isTargetVisible(droneId) == 0 )
		{
			printf("KILLING IT !! \n");
			outOfViewCounter++;
			if(outOfViewCounter >4)
			{
				//emergency landing 
				heli->land();
				killSwitch = 1;
				printf("I CAN'T FIND IT \n");
				break;
			}
		}
		else
		{
			outOfViewCounter = 0;
		}
		if(x <= currentX)
		{
			//printf("moving to the left\n");
			heli->setAngles(yDrift,-3000.0,0.0,0.0);
		}
		else
		{
			//printf("moving to the right\n");
			heli->setAngles(yDrift,3000.0,0.0,0.0);
		}

		currentX = locator->getTargetX(droneId);
		currentY = locator->getTargetY(droneId);

		//adjust errors in the y axis
		if(originalY+TOLERANCE < currentY)
		{
			if(yDrift < 0 && yDrift >= -1500.0) yDrift -= 500.0;
			else yDrift = -500.0;
			//printf("Realized x drift to the back\n Adjusting ..  \n");
		}
		else if(originalY-TOLERANCE >= currentY)
		{
			if(yDrift > 0 && yDrift <= 1500.0) yDrift += 500.0;
			else yDrift = 500.0;
			//printf("Realized x drift to the front\n Adjusting ..  \n");
		}
		//maintainHeliImage();
		usleep(20000);
	}
}


void CoordinateController::upDown(int down, double time)
{
	if (killSwitch)
	{
		printf("I CAN'T FIND IT \n");
		return;
	}
	double speed = 20000.0;
	if(!down) speed = speed*-1;
	heli->setAngles(0.0,0.0,0.0,speed);
	usleep(1000000*time);
}


void CoordinateController::stablizeOrientation(double desiredOrientation, double tolerance, int relative)
{
	if (killSwitch)
	{
		return;
	}
	desiredOrientation += 180000;
	if (relative)
	{	
		desiredOrientation = desiredOrientation - 180000 + zeroOrientation;
		if (desiredOrientation > 360000)  desiredOrientation =desiredOrientation-360000;
	}
	//desiredOrientation += zeroOrientation;

	//if (desiredOrientation > 360000 && relative)  desiredOrientation =desiredOrientation-360000;

	double current  = heli->myNavdataReader->helidata.psi + 180000;
	double speed = 5000.0;
	int outOfViewCounter = 0;	


	printf("Current %f, Initial %f, c1 %d, c2 %d\n",current,  desiredOrientation,current > desiredOrientation + tolerance ,  current < desiredOrientation - tolerance);

	while(current > desiredOrientation + tolerance || current < desiredOrientation - tolerance)
	{
		if (locator->isTargetVisible(droneId) == 0 )
		{
			outOfViewCounter++;
			if(outOfViewCounter >4)
			{
				//emergency landing 
				heli->land();
				killSwitch = 1;
				printf("I CAN'T FIND IT \n");
				break;
			}
		}
		printf("Current %f, Initial %f, c1 %d, c2 %d\n",current,  desiredOrientation,current > desiredOrientation + tolerance ,  current < desiredOrientation - tolerance);
		

		if(current > desiredOrientation + tolerance )// && current - desiredOrientation < 180000)
		{
			//printf("rotate clock wise\n");
			if(speed < 0) speed = speed*-1;
			heli->setAngles(0.0,0.0,speed,0.0);
			usleep(100000);
		}
		
		else if (current < desiredOrientation - tolerance)// && desiredOrientation - current < 180000)
		{
			//printf("rotate anticlock wise\n");
			if(speed > 0) speed = speed*-1;
			heli->setAngles(0.0,0.0,speed,0.0);
			usleep(100000);
			//usleep(20000*(desiredOrientation-current)/1000);
		}
		current  = heli->myNavdataReader->helidata.psi + 180000;
	}
}


void CoordinateController::run()
{
	thread = SDL_CreateThread(StartThread,static_cast<void*>(this));
}



int CoordinateController::DoExecute()
{
	//get current coordinates

	//wait 5 seconds for camera to collect some footage before takeoff 
	usleep(5000000);
	heli->takeoff();
	//wait 5 seconds for hovering and compass to stabelize 
	usleep(5000000);
	//hover_stable(2000);	
	
	zeroOrientation = heli->myNavdataReader->helidata.psi + 180000;
       	flying= 1;
	while(!killSwitch)
	{
		//while no new command given remain the same
		hover(200);		
		if(moveCommandGiven)
		{
			//reset moveCommandGiven to allow for intrruptions
			moveCommandGiven = 0;
			//new command given, so reset your orientation 
			hover_stable(300);
			//move
			moveOnXAxisTo(xDestination,yDestination);			
			moveOnYAxisTo(yDestination,xDestination);			
			stablizeOrientation(rotationDestination,10000, 1);
		}	
	}
	printf("Landing \n");
	heli->land();
	usleep(5000000);
       	flying= 0;
	return 0;
}

void CoordinateController::landNow()
{
	killSwitch = 1;
}

void CoordinateController::goTo(double x, double y, double rotateAngle)
{
	moveCommandGiven = 1;
	xDestination = x;
	yDestination = y;
	rotationDestination = rotateAngle;
}
