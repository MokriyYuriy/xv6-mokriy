#include "types.h"
#include "defs.h"
#include "param.h"
#include "stat.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "file.h"
#include "fcntl.h"
#include "spinlock.h"
#include "pipe.h"
#include "mutex.h"


struct Mutex {
  short islock;
  struct spinlock lock;
  int curpid;
};

static struct Mutex mutex[MUTEXSIZE];


int
mlock(int n)
{
  acquire(&mutex[n].lock);
  while(1){
    if(mutex[n].islock){
      sleep(&mutex[n], &mutex[n].lock);
      continue;
    }
    proc->lockmutex[n] = 1;
    mutex[n].islock = 1;
    mutex[n].curpid = proc->pid;
    release(&mutex[n].lock);
    break;
  }
  return 0;
}

int
munlock(int n)
{
  acquire(&mutex[n].lock);
  if(proc->pid != mutex[n].curpid){
    release(&mutex[n].lock);
    return -1;
  }
  mutex[n].islock = 0;
  mutex[n].curpid = 0;
  proc->lockmutex[n] = 0;
  wakeup(&mutex[n]);
  release(&mutex[n].lock);
  return 0;
}
