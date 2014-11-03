/** @file CThread.h
* @brief Class for thread encapsualation
* @author Jan Faigl
* @date 23.06.2004
*/
#ifndef CThread_h
#define CThread_h
#include "SDL/SDL_thread.h"

extern "C" int StartThread(void* arg);
//!  Class for thread encapsualation.
/*!
Enforces the implementation of DoExecute which is called by SDL threading implementation when run() is called in any of this class's children.*/
class CThread {
      virtual int DoExecute(void) = 0; 
	 //! Function called by SDL thread calls.
      friend int StartThread(void*);
   public:
      virtual ~CThread() = 0;
};
#endif
