#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"

#define RECURSION_LIMIT 5

static int cleverexec(char *, char **, int);
static char checkshebang(struct inode *);
static int scriptexec(struct inode *, char *, char **, int);

int
exec(char *path, char **argv)
{
  return cleverexec(path, argv, RECURSION_LIMIT);
}

static int
cleverexec(char *path, char **argv, int recursion_limit)
{
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if(!recursion_limit) {
    return -1;
  }

  begin_op();
  if((ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto script;
  if(elf.magic != ELF_MAGIC)
    goto script;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
  proc->tf->esp = sp;
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;

 script:
  return scriptexec(ip, path, argv, recursion_limit);
}

char
checkshebang(struct inode *ip)
{
  char fstr[2];
  int ln = readi(ip, fstr, 0, 2);
  return ln >= 2 && fstr[0] == '#' && fstr[1] == '!'; 
}

static int
getaddargv(char *interpreter_path, char **newargv)
{
  int curarg = 0, curlen = 0, i, firstnonspace = 0;
  for(i = 0; interpreter_path[i]; i++) {
    if(interpreter_path[i] == ' ') {
      if(curlen) {
        interpreter_path[i] = 0;
        newargv[curarg++] = interpreter_path + firstnonspace;
        curlen = 0;
        if(curarg == MAXARG){
          return MAXARG;
        }
      }
    } else {
      if(curlen == 0){
        firstnonspace = i;
      }
      curlen++;
    } 
  }
  if(curlen){
    newargv[curarg++] = interpreter_path + firstnonspace;
  }
  return curarg;
}

static int
scriptexec(struct inode *ip, char *pathname, char **argv, int recursion_limit)
{
  char *interpreter_path = 0, *addargv[MAXARG];
  int ln, argc, i, res, size, addargc;
  if(!checkshebang(ip)){
    goto bad;
  }
  interpreter_path = kalloc();
  size = readi(ip, interpreter_path, 2, PGSIZE);

  iunlockput(ip);
  end_op();
  ip = 0;
  for(ln = 0; ln < size && interpreter_path[ln] != '\n'; ln++) {}
  if(ln == size){
    goto bad;
  }
  interpreter_path[ln] = 0;
  for(argc = 0; argv[argc]; argc++) {}
  addargc = getaddargv(interpreter_path, addargv);
  if(!addargc || addargc + argc >= MAXARG){
    goto bad;
  }
  for(i = argc; i >= 0; i--) {
    argv[i + addargc] = argv[i]; 
  }
  for(i = 0; i < addargc; i++) {
    argv[i] = addargv[i];
  }
  pathname = argv[0];
  res = cleverexec(pathname, argv, recursion_limit - 1);
  kfree(interpreter_path);
  return res;
 bad:
  if(ip){
    iunlockput(ip);
    end_op();
  }
  if(interpreter_path){
    kfree(interpreter_path);
  }
  return -1;
}
