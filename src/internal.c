#include <string.h>
#include <pwd.h>
#include <limits.h>

/* https://stackoverflow.com/questions/8953424 */
void getuser_c(char user[], int *stat){
  uid_t uid = geteuid();
  struct passwd *pw = getpwuid(uid);
  if (pw){
    strcpy(user,pw->pw_name);
    *stat = 0;
    }
  else{
    *stat = 1;
  }
}

int path_max_c(){
  return PATH_MAX;
}
