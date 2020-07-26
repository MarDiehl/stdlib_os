#include <stdio.h>
#include <unistd.h>
#include <dirent.h>
#include <string.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/stat.h>

double getatime_c(char *path) {
  struct stat statbuf;
  if(stat(path, &statbuf) != 0)                                                                     /* error */
    return -1.0;
  return (double)statbuf.st_atime;
}

double getmtime_c(char *path) {
  struct stat statbuf;
  if(stat(path, &statbuf) != 0)                                                                     /* error */
    return -1.0;
  return (double)statbuf.st_mtime;
}

double getctime_c(char *path) {
  struct stat statbuf;
  if(stat(path, &statbuf) != 0)                                                                     /* error */
    return -1.0;
  return (double)statbuf.st_ctime;
}

long getsize_c(char *path) {
  struct stat statbuf;
  if(stat(path, &statbuf) != 0)                                                                     /* error */
    return -1;
  return (long)statbuf.st_size;
}

int isdir_c(char *path) {
  struct stat statbuf;
  if(stat(path, &statbuf) != 0)                                                                     /* error */
    return 0;
  return S_ISDIR(statbuf.st_mode);                                                                  /* 1 => is directory, 0 => this is NOT a directory */
}

int isfile_c(char *path) {
  struct stat statbuf;
  if(stat(path, &statbuf) != 0)                                                                     /* error */
    return 0;
  return S_ISREG(statbuf.st_mode);                                                                  /* 1 => is directory, 0 => this is NOT a directory */
}

int islink_c(char *path) {
  struct stat statbuf;
  if(stat(path, &statbuf) != 0)                                                                     /* error */
    return 0;
  return S_ISLNK(statbuf.st_mode);                                                                 /* 1 => is directory, 0 => this is NOT a directory */
}

int samefile_c(char *path1, char *path2) {
  struct stat statbuf1;
  if(stat(path1, &statbuf1) != 0)                                                                     /* error */
    return -1;
  struct stat statbuf2;
  if(stat(path2, &statbuf2) != 0)                                                                     /* error */
    return -1;
  return statbuf1.st_dev == statbuf2.st_dev && statbuf1.st_ino == statbuf2.st_ino;
}
