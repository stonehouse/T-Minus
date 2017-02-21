//
//  tminus.h
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#ifndef tminus_h
#define tminus_h

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include <math.h>

#define MAX_TITLE 256
#define MAX_DESCRIPTION 100
#define SECONDS_IN_DAY 86400
#define SECONDS_IN_YEAR 31536000

typedef struct Countdown {
    time_t deadline;
    char title[MAX_TITLE];
} Countdown;

typedef struct Tminus {
    time_t difference;
    char description[MAX_DESCRIPTION];
} Tminus;

Countdown* Countdown_create(char *title, int year, int month, int day, int hour, int minute);
Countdown* Countdown_createWithTimestamp(char *title, time_t deadline);

Tminus* Countdown_tminus(Countdown *countdown);
Tminus* Countdown_tminusRelative(Countdown *countdown, time_t currentTime);

void Countdown_destroy(Countdown *countdown);
void Tminus_destroy(Tminus *tminus);


#endif /* tminus_h */
