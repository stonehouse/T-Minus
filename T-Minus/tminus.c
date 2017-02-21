//
//  tminus.c
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#include "tminus.h"


Countdown* Countdown_create(char *title, int year, int month, int day, int hour, int minute)
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
    
    Countdown *ctdn = malloc(sizeof(Countdown));
    ctdn->deadline = deadline;
    strncpy(ctdn->title, title, MAX_TITLE-1);
    
    return ctdn;
}

Tminus* Countdown_tminus(Countdown *countdown)
{
    return Countdown_tminusRelative(countdown, time(NULL));
}

Tminus* Countdown_tminusRelative(Countdown *countdown, time_t currentTime)
{
    long diff = difftime(countdown->deadline, currentTime);
    
    int SECONDS_IN_DAY = 60 * 60 * 24;
    long rem = (long) diff % (long) SECONDS_IN_DAY;
    int hours = round(rem / 60 / 60);
    rem = rem % (60*60);
    int minutes = round(rem/60);
    int seconds = rem % 60;
    int days = round(diff / SECONDS_IN_DAY);
    
    Tminus *tminus = malloc(sizeof(Tminus));
    tminus->difference = diff;
    
    sprintf(tminus->description, "%d days %d:%d:%d", days, hours, minutes, seconds);
    
    return tminus;
}


void Countdown_destroy(Countdown *countdown)
{
    free(countdown);
}

void Tminus_destroy(Tminus *tminus)
{
    free(tminus);
}

