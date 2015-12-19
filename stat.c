#include "types.h"
#include "stat.h"
#include "user.h"
#include "ls.h"

int
main(int argc, char *argv[])
{
  int i, r;
  struct stat st;
  for (i = 1; i < argc; i++)
  {
    r = stat(argv[i], &st);
    if (r < 0) {
      printf(1, "stat: error\n");
      continue;
    }
    printf(1, "name:%s type:%d ino:%d size:%d nlink:%d\n", fmtname(argv[i]), st.type, st.ino, st.size, st.nlink);
  }
  exit();
}
