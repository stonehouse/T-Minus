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

#define MAX_ROWS 10
#define MAX_TITLE 256
#define MAX_BACKGROUND_PATH 512
#define MAX_DESCRIPTION 100

#define SECONDS_IN_HOUR 3600
#define SECONDS_IN_DAY 86400
#define SECONDS_IN_YEAR 31536000

typedef struct Countdown {
    int index;
    time_t deadline;
    char title[MAX_TITLE];
    char background[MAX_BACKGROUND_PATH];
} Countdown;

typedef struct Tminus {
    int finished;
    time_t difference;
    int days;
    int hours;
    int minutes;
    int seconds;
    char description[MAX_DESCRIPTION];
} Tminus;

typedef struct Database Database;

typedef struct Connection Connection;

Connection* Database_open(const char *filename);
void Database_close(Connection *conn);

time_t createTimestamp(int year, int month, int day, int hour, int minute);
int Countdown_count(Connection *conn);
Countdown* Countdown_get(Connection *conn);
Countdown* Countdown_create(Connection *conn);
Countdown* Countdown_createWithTimestamp(Connection *conn, const char *title, time_t deadline, const char *bgPath);
void Countdown_save(Connection *conn, Countdown *ctdn);
void Countdown_delete(Connection *conn, Countdown *ctdn);

Tminus* Countdown_tminus(Countdown *countdown);
Tminus* Countdown_tminusRelative(Countdown *countdown, time_t currentTime);

void Countdown_destroy(Countdown *countdown);
void Tminus_destroy(Tminus *tminus);

// Test helpers
Connection *Database_openInMemory();

#endif /* tminus_h */
