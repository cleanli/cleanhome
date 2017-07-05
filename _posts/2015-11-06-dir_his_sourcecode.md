---
layout:     post
title:      "【原创】目录历史源码"
date:       2015-11-06 00:00:00 +0800
author:     "Clean Li"
categories: 技术
tags: ["原创"]
header-img: "img/post-bg-01.jpg"
---
自己写了一个记录访问目录历史的东西，code在这里备份一下。
```cpp
    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    int main(int argc, char** argv)
    {
            FILE* fp = NULL;
            char s[1000], t[1000];
            char *pwd;
            char *home;
            int i = 0, j;
            home = getenv("HOME");
            memset(s, 0, 1000);
            sprintf(s, "%s/.dhs/dhsty", home);
            fp = fopen(s, "r");
            if(fp){
                    while(!feof(fp)){
                            memset(s, 0, 1000);
                            fgets(s, 1000, fp);
                            s[strlen(s)-1] = 0;
                            printf("%d--%s ", i++, s);
                            //printf("%x == ", s[strlen(s)-1]);
                    }
                    fclose(fp);
                    fp = NULL;
            }
            if(i==0){
                    printf("no rec ");
                    return 0;
            }
            printf("input:");
            scanf("%d", &j);
            printf("get %d ", j);
            i = 0;
            memset(s, 0, 1000);
            sprintf(s, "%s/.dhs/dhsty", home);
            fp = fopen(s, "r");
            if(fp){
                    while(!feof(fp)){
                            fgets(s, 1000, fp);
                            if(s[strlen(s)-1] == 0x0a){
                                    s[strlen(s)-1] = 0;
                            }
                            if(i==j){
                                    printf("%d--%s ", i++, s);
                                    break;
                            }
                            i++;
                            //printf("%x == ", s[strlen(s)-1]);
                    }
                    fclose(fp);
                    fp = NULL;
            }
            memset(t, 0, 1000);
            sprintf(t, "%s/.dhs/wantedpath", home);
            fp = fopen(t, "w");
            if(fp){
                    fputs(s, fp);
                    fclose(fp);
                    fp = NULL;
            }
            return 0;
    }


    #include<stdio.h>
    #include<string.h>
    #include<stdlib.h>
    int main(int argc, char** argv)
    {
            FILE* fp = NULL;
            char s[1000];
            char *pwd;
            char *home;     
                            
            home = getenv("HOME");
            memset(s, 0, 1000);
            sprintf(s, "%s/.dhs/dhsty", home);
            fp = fopen(s, "r");
            //fp = fopen("/home/clean/.dhs/dhsty", "r");
            //fp = fopen("dhsty", "a");
            pwd = getenv("PWD");
            printf("%s", pwd);
            if(fp){
                    while(!feof(fp)){
                            fgets(s, 1000, fp);
                            //printf("%d-- %s ", (int)strlen(s), s);
                            //printf("%x == ", s[strlen(s)-1]);
                            s[strlen(s)-1] = 0;
                            if(!strcmp(s, pwd)){
                                    printf("-same exist ");
                                    fclose(fp);
                                    return 0;
                            }
                    }
                    fclose(fp);
            }               
            memset(s, 0, 1000);     
            sprintf(s, "%s/.dhs/dhsty", home);
            fp = fopen(s, "a");
            if(!fp){                
                    printf("open fail ");
                    return -1;
            }               
            /*
            strcpy(s, "cd ");
            */
            fputs(pwd, fp);
            fputs(" ", fp);
            printf("-added ");
            /*
            if(argc > 1){ 
                    strcpy(s+3, argv[1]);
                    printf("%s ", s);
                    system(s);
            }
            */
            fclose(fp);
            return 0;
    }
```
