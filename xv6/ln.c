#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  if(argc != 3 && argc != 4){
    printf(2, "Usage: ln old new\n");
    exit();
  }
  // if(strcmp(argv[1], "-s") == 0){
  //   if(symlink(argv[2],argv[3]) < 0){
  //     printf(2,"symbolic link %s %s failed\n",argv[2],argv[3]);
  //     exit();
  //   }
  // }
  else if(link(argv[1], argv[2]) < 0)
    printf(2, "hard link %s %s: failed\n", argv[1], argv[2]);
    
  exit();
}