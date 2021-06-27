#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define MAX_Attempt 3
#define BUFFLEN 64
#define REG_USERS 2
char *argv[] = {"login", 0};
char *regusers[] = {"suriya","aravinda"};
char *regpass[] = {"19BCE1050","19BCE1190"};

int login(char *u, char *p) {
  int i;
  int loggedIn = 0;
  for(i = 0 ; i < REG_USERS ; i++) {
    //printf(1, "%s %s %s %s %d %d\n", u, regusers[i], p, regpass[i], !strcmp(u, regusers[i]), !strcmp(p, regpass[i]));
    if(!strcmp(u, regusers[i]) && !strcmp(p, regpass[i])) {
      loggedIn = 1;
      break;
    }
  }

  return loggedIn;
}

int
main(void)
{
  int pid, wpid,loggedIn;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "Starting XV6 os by\n");
    printf(1, "Suriyakrishnan S - 19BCE1050\n");
    printf(1, "Aravinda B - 19BCE1190\n");
    printf(1, "init: starting login\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      // exec(argv[0], argv);
      // printf(1, "init: exec login failed\n");
      // exit();
      int count=0;
      while (count < MAX_Attempt)
      {
        printf(1, "Username: ");
        char *user = (char *)malloc(BUFFLEN);
        user = gets(user , 64);
        //remove enter key
        switch(user[strlen(user) - 1]) {
          case '\n': case '\r':
          user[strlen(user) - 1] = 0;
        }
        
        printf(1, "Password :  ");
        char *pass = (char *)malloc(BUFFLEN);
        pass = gets(pass , 20);
        //remove enter key
        switch(pass[strlen(pass) - 1]) {
          case '\n': case '\r':
          pass[strlen(pass) - 1] = 0;
        }

        loggedIn = login(user, pass);
        if(loggedIn) {
          char home_dir[64];
          strcpy(home_dir, "/home/");      
          mkdir(home_dir);      
          strcpy(home_dir + strlen(home_dir), "suriya");
          mkdir(home_dir);
          //opens shell for the user
          printf(1, "Welcome back %s!\n", user);          
          exec("sh", &user);
          printf(1, "init: exec login failed\n");
          exit();
        }
        else {
          printf(1, "User and password do not match, or user does not exist! Try again!\n");
          count++;
        }
      }

      printf(1, "Failed 3 attempts! Please reboot machine!\n");
      while(1); //stall
      exit();
      
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}