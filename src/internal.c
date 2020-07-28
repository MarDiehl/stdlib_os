#include <string.h>
#include <pwd.h>
#include <unistd.h>
#include <limits.h>

/* https://stackoverflow.com/questions/8953424 */
void getuser_c(char user[], int *stat){
  struct passwd *pw = getpwuid(geteuid());
  if (pw){
    strcpy(user,pw->pw_name);
    *stat = 0;
    }
  else{
    *stat = 1;
  }
}

void gethome_c(char home[], int *stat){
  struct passwd *pw = getpwuid(getuid());
  if (pw){
    strcpy(home,pw->pw_dir);
    *stat = 0;
    }
  else{
    *stat = 1;
  }
}

int path_max_c(){
  return PATH_MAX;
}
