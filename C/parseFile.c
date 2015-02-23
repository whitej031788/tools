#include <sys/stat.h>   /* umask */
#include <sys/types.h>  /* umask */

#include <dirent.h>
#include <unistd.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>

#include <stdarg.h>
#include <errno.h>
#include <strings.h>
#include <getopt.h>
#include <string.h>

static int isEnd(char *);

FILE *output = NULL;
FILE *csvFile = NULL;

int main(int argc, char *argv[])
{
    char fileName[255];
    char newFile[255];
    char outputFile[255];
    char directory[255];
    char buffer[255];
    char fullPath[255];
    char *pA;
    int x,i;
    int count;
    int y = 0;
    DIR *maindir = NULL;
    struct dirent *file = NULL;

    memset(fileName, '\0', sizeof(fileName));
    memset(outputFile, '\0', sizeof(outputFile));
    memset(newFile, '\0', sizeof(outputFile));
    memset(directory, '\0', sizeof(directory));
    memset(fullPath, '\0', sizeof(fullPath));

    if (argc != 5)
    {
        printf("You must pass in only two arguments, a directory name after the -d flag and an output filename after the -f flag\n");
        printf("For example:\n\n");
        printf("./parseFile -f output.txt -d /home/jwhite/test\n");
        exit (EXIT_FAILURE);
    }

    while ((x = getopt(argc, argv, "f:d:")) != EOF)
    {
        switch (x)
        {
            case 'f':
                snprintf(outputFile, sizeof(outputFile), "%s", optarg);
                if ((output = fopen(outputFile, "w")) == NULL)
                {
                    printf("Cannot open output file!\n");
                    exit (EXIT_FAILURE);
                }
                break;
            case 'd':
                snprintf(directory, sizeof(directory), "%s", optarg);
                maindir = opendir(directory);
                if (NULL == maindir)
                {
                    printf("Can't open the download dir\n");
                    exit (EXIT_FAILURE);
                }
                break;
        }
    }

    while (file = readdir(maindir))
    {
        if (strcmp(file->d_name, ".") == 0 ||
                strcmp(file->d_name, "..") == 0)
        {
            continue;
        }
        
        snprintf(fileName, sizeof(fileName), "%s", file->d_name); 
        count = sizeof(fileName);
        pA = fileName;
        for (i = 0; i < count; i++)
        {
            switch (*pA)
            {
                case '_':
                    if (isEnd(pA))
                    {
                        y = 1;
                        break;
                    }
                    else
                    {
                        newFile[i] = ' ';
                        break;
                    }
                default:
                    newFile[i] = fileName[i];
                    break;
            }
            if (y == 1)
            {
                y = 0;
                break;
            }
            pA++;
        }
        //fprintf(output,"%s\n",newFile);
        snprintf(fullPath,sizeof(fullPath),"%s/%s",directory,fileName);
        csvFile = fopen(fullPath,"r");
        if (csvFile == NULL)
        {
            printf("Cannot open file %s",fileName);
            exit(EXIT_FAILURE);
        }
        memset(buffer,'\0',sizeof(buffer));
        while (fgets(buffer, sizeof(buffer), csvFile) != NULL)
        {
            if (strncmp(buffer,"email",5) == 0)
            {
                continue;
            }
            char *nlptr = strchr(buffer, '\n');
            if (nlptr)
            {
                *nlptr = '\0';
            }
            char *crptr = strchr(buffer, '\r');
            if (crptr)
            {
                *crptr = '\0';
            }
            strcat(buffer,",");
            strcat(buffer,newFile);
            strcat(buffer,"\n");
            fprintf(output,"%s",buffer);
            memset(buffer,'\0',sizeof(buffer));
        }
        memset(newFile,'\0',sizeof(newFile));
        fclose(csvFile);
        memset(fullPath,'\0',sizeof(fullPath));
    }

    fclose(output);

    return 0;
}

static int isEnd(char *str)
{
    if (strncmp(str,"_Opt_",5) == 0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
