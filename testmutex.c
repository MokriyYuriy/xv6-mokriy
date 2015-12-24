#include "types.h"
#include "stat.h"
#include "user.h"

int
main() {
  int pid, i;
  pid = fork();
  if(!pid) {
    mlock(0);
    for (i = 0; i < 100; i++) {
     printf(1, "1 %d\n", i);
    }
    //munlock(0);
    exit();
  }
  pid = fork();
  if(!pid) {
    mlock(0);
    for (i = 0; i < 100; i++) {
     printf(1, "2 %d\n", i);
    }
    munlock(0);
    exit();
  }
  wait();
  wait();
  exit();
}
