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

typedef time_t Countdown;

Countdown Countdown_create(int year, int month, int day, int hour, int minute);
void Countdown_destroy(Countdown countdown);
char *Countdown_toString(Countdown countdown);
char *Countdown_toStringRelativeToCurrentTime(Countdown countdown, time_t currentTime);


#endif /* tminus_h */
