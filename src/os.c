#include <stdio.h>
#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#ifndef _WIN32
#include <unistd.h>
#else
#include <direct.h>
#if !defined(__MINGW32__) && !defined(__MINGW64__)
#define PATH_MAX _MAX_PATH
#endif
#define _getcwd getcwd
#define _mkdir   mkdir
#define _rmdir   rmdir
#define _unlink  unlink
#endif

int chdir_c(const char *path){
  return chdir(path);
}

void getcwd_c(char cwd[], int *stat){
  char cwd_tmp[PATH_MAX];
  if(getcwd(cwd_tmp, sizeof(cwd_tmp)) != NULL){
    strcpy(cwd,cwd_tmp);
    *stat = 0;
  }
  else{
    *stat = 1;
  }
}

#ifndef _WIN32
int mkdir_c(const char *path, int *mode){
  return mkdir(path,(mode_t)*mode);
}
#else
int mkdir_c(const char *path, int *mode){
  return _mkdir(path);
}
#endif

int rename_c(const char *src, const char *dst){
  return rename(src,dst);
}

int rmdir_c(const char *path){
  return rmdir(path);
}

#ifndef _WIN32
int symlink_c(const char *src, const char *dst){
  return symlink(src,dst);
}
#else
int symlink_c(const char *src, const char *dst){
  return 1;
}
#endif

int unlink_c(const char *path){
  return unlink(path);
}
