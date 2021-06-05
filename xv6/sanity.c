#include "user.h"
#include "fcntl.h"
#include "types.h"

#define bsize 512
#define MB 1000000

typedef unsigned int   uint;

int main(){
    int i;
    char buffer[bsize];
    char s[bsize];
    for (i =0; i < bsize; i++){
        s[i] = 's';
    }

    int fd = open("tmp.txt",O_CREATE | O_RDWR);
    if (fd < 0)
        printf(1,"cant create file\n");
    for (i = 0; i < 12; i++){
        write(fd,s,bsize);
    }
    printf(1,"Finished writing 6KB (direct)\n");
    for (i = 0; i < 128; i++){
        write(fd,s,bsize);
    }
    printf(1,"Finished writing 70KB (single indirect)\n");
    for (i = 0; i < 128 * 16; i++){
        if (write(fd,s,bsize) < 512){
            printf(1, "write not working good single indirect\n");
        }
    }
    printf(1,"Finished writing 1MB (double indirect)\n");
    close(fd);
    fd = open("tmp.txt",O_RDONLY);          // not sure why, but we need to close the file and reopen it read only in order for read to work
    memset(buffer,0, bsize);
    for(int i = 0;i < MB / bsize; i+= bsize){
        if(read(fd,buffer,bsize) < 0)
            printf(1,"read failed\n");
        int data = ((int *)buffer)[0];
        if(data != i)
            printf(1,"read failed?\n", i);
    }
    close(fd);
    exit();
}