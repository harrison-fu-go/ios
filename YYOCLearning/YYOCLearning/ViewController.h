//
//  ViewController.h
//  YYOCLearning
//
//  Created by HarrisonFu on 2024/4/7.
//
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<errno.h>
#include<sys/types.h>
#include <unistd.h>
#include <time.h>
#include <signal.h>
#include <pthread.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/time.h>

typedef struct
{
    uint8_t alarmEn;  // 1=alarm enable
    uint8_t alarmHour;
    uint8_t alarmMin;
    uint8_t alarmRpeat; //bit0~6¥˙±Ì÷‹»’µΩ÷‹¡˘
    uint8_t alarmName[64];
} gmanLibWDPAlarmStruct;

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end

