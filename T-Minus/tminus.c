//
//  tminus.c
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#include "tminus.h"


Countdown Countdown_create(int year, int month, int day, int hour, int minute)
{
    struct tm t;
    time_t deadline;
    t.tm_year = year-1900;
    t.tm_mon = month-1;
    t.tm_mday = day;
    t.tm_hour = hour;
    t.tm_min = minute;
    t.tm_sec = 0;
    t.tm_isdst = -1;
    deadline = mktime(&t);
    return deadline;
}

void Countdown_destroy(Countdown countdown)
{
    // Don't do anything yet
}

char *Countdown_toString(Countdown countdown)
{
    return Countdown_toStringRelativeToCurrentTime(countdown, time(NULL));
}

char *Countdown_toStringRelativeToCurrentTime(Countdown countdown, time_t currentTime)
{
    long diff = difftime(countdown, currentTime);
    
    int SECONDS_IN_DAY = 60 * 60 * 24;
    long rem = (long) diff % (long) SECONDS_IN_DAY;
    int hours = round(rem / 60 / 60);
    rem = rem % (60*60);
    int minutes = round(rem/60);
    int seconds = rem % 60;
    int days = round(diff / SECONDS_IN_DAY);
    
    char *str = malloc(32*sizeof(char));
    sprintf(str, "%d days %d:%d:%d", days, hours, minutes, seconds);
    return str;
}
