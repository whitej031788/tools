#include <sys/stat.h>   /* umask */
#include <sys/types.h>  /* umask */

#include <dirent.h>
#include <unistd.h>
#ifdef __linux__
#  include <getopt.h>
#endif
#include <stdio.h>
#include <stdlib.h>

#include <stdarg.h>
#include <errno.h>
#include <strings.h>

#define DOWNLOADDIR "/home/rtorrent/Downloads"

#define DONE "UNRAR"

/* Short C program to unrar all *.rar files in a directory tree within
 * a base directory */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

FILE *change = NULL;
FILE *err = NULL;

int main(int argc, char *argv[])
{
    DIR *maindir = NULL;
    struct dirent *torent = NULL;
    DIR *subdir = NULL;
    struct dirent *onetor = NULL;
    char fullPath[500];
    char fullPathFile[500];
    char saveFile[500];
    int unrar = 0;
    int hasRar = 0;
    struct stat buf;
    char cmd[200];

    memset(cmd, '\0', sizeof(cmd));
    memset(saveFile, '\0', sizeof(saveFile));
    memset(fullPathFile, '\0', sizeof(fullPathFile));
    memset(fullPath, '\0', sizeof(fullPath));
    
    if ((change = fopen("/home/rtorrent/logs/rar.log", "w")) == NULL)
    {
	    printf("Can't Open Change File, Exiting\n");
    }

    if ((err = fopen("/home/rtorrent/logs/rar.err", "w")) == NULL)
    {
	    printf("Can't Open Err File, Exiting\n");
    }

    maindir = opendir(DOWNLOADDIR);

    if (NULL == maindir)
    {
        fprintf(err,"Can't open the download dir\n");
        exit;
    }

    while (torent = readdir(maindir))
    {
        if (strcmp(torent->d_name, ".") == 0 ||
                strcmp(torent->d_name, "..") == 0)
        {
            continue;
        }

        snprintf(fullPath,
                sizeof(fullPath),
                "%s/%s", DOWNLOADDIR, torent->d_name);

        stat(fullPath, &buf);

        if (!(buf.st_mode & S_IFDIR))
        {
            fprintf(change,"%s is not a directory\n", torent->d_name);
            continue;
        }

        subdir = opendir(fullPath);

        if (NULL == subdir)
        {
            fprintf(err,"Cannot open subdir %s\n",fullPath);
            continue;
        }

        while ((onetor = readdir(subdir)))
        {
            if (strcmp(onetor->d_name, ".") == 0 ||
                    strcmp(onetor->d_name, "..") == 0)
            {
                continue;
            }

            snprintf(fullPathFile,
                     sizeof(fullPathFile), "%s/%s",
                     fullPath, onetor->d_name);

            stat(fullPathFile,&buf);

            if (NULL != strstr(fullPathFile, DONE))
            {
                unrar = 1;
            }

            if (NULL != strstr(fullPathFile, "rar"))
            {
                hasRar = 1;
                snprintf(saveFile, sizeof(saveFile), "%s", fullPathFile);
            }
        }

        if (unrar)
        {
            unrar = 0;
            hasRar = 0;
            memset(saveFile, '\0', sizeof(saveFile));
            memset(fullPathFile, '\0', sizeof(fullPathFile));
            memset(cmd, '\0', sizeof(cmd));
            memset(fullPath, '\0', sizeof(fullPath));
            continue;
        }

        if (hasRar)
        {
            snprintf(cmd, sizeof(cmd), "cd %s", fullPath);
            system(cmd);
            snprintf(cmd, sizeof(cmd), "unrar e %s", saveFile);
            system(cmd);
            snprintf(cmd, sizeof(cmd), "touch %s/%s", fullPath, DONE);
            system(cmd);
            fprintf(change, "Unrared %s\n", saveFile);
        }
            memset(saveFile, '\0', sizeof(saveFile));
            memset(fullPathFile, '\0', sizeof(fullPathFile));
            memset(cmd, '\0', sizeof(cmd));
            memset(fullPath, '\0', sizeof(fullPath));
    }
}
