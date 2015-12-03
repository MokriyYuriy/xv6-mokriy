#define PIPESIZE 512

struct pipe {
  struct spinlock lock;
  struct file *fifofr, *fifofw;
  char data[PIPESIZE];
  uint nread;     // number of bytes read
  uint nwrite;    // number of bytes written
  int readopen;   // number of read fd is still open
  int writeopen;  // number of write fd is still open
};
