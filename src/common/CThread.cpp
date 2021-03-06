/** @file CThread.cpp
* @brief Class for thread encapsualation
* @author Jan Faigl
* @date 23.06.2004
*/

#include "CThread.h"
extern "C" {
   int StartThread(void* arg) {
      CThread * thread = static_cast<CThread*>(arg);
      return thread->DoExecute();
   }
}

//----------------------------------------------------------------------------
//Class CThread
//----------------------------------------------------------------------------
CThread::~CThread() {
}
