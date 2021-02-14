/* On Windows we need to distinguish between Cygwin (very like Linux),
   MinGW-w64/MSYS2 (to use the full name) and plain Windows

   The macro _WIN32 is defined on plain Windows and MinGW, not on Cygwin
*/

#include <string.h>
#ifndef _WIN32
#include <pwd.h>
#include <unistd.h>
#else
#include <stdio.h>
#include <stdlib.h>
#endif
#include <limits.h>

/* https://stackoverflow.com/questions/8953424 */
#ifndef _WIN32
void getuser_c(char user[], int *stat) {
  struct passwd *pw = getpwuid(geteuid());
  if (pw) {
    strcpy(user, pw->pw_name);
    *stat = 0;
  } else {
    *stat = 1;
  }
}

void gethome_c(char home[], int *stat) {
  struct passwd *pw = getpwuid(getuid());
  if (pw) {
    strcpy(home, pw->pw_dir);
    *stat = 0;
  } else {
    *stat = 1;
  }
}

int path_max_c() { return PATH_MAX; }
#else

/* On plain Windows and MinGW use environment variables */
#if defined(__MINGW32__) || defined(__MINGW64__)
#define USER "USER"
#define HOME "HOME"
#else
#define USER "USERNAME"
#define HOME "USERPROFILE"
#endif

void getuser_c(char user[], int *stat) {
  strcpy(user, getenv(USER));
  *stat = (strlen(user) == 0);
}

void gethome_c(char home[], int *stat) {
  strcpy(home, getenv(HOME));
  *stat = (strlen(home) == 0);
}

int path_max_c() { return _MAX_PATH; }
#endif
