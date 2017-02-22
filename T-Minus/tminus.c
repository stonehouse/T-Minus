//
//  tminus.c
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#include "tminus.h"

void Database_load(Connection *conn)
{
    fread(conn->db, sizeof(Database), 1, conn->file);
}

void Database_close(Connection *conn)
{
    if (conn) {
        if (conn->file) {
            fclose(conn->file);
        }
        if(conn->db) {
            free(conn->db);
        }
        free(conn);
    }
}

void Database_write(Connection *conn)
{
    rewind(conn->file);
    
    size_t rc = fwrite(conn->db, sizeof(Database), 1, conn->file);
    
    if (rc != 1) printf("Error writing to db %ld", rc);
    
    rc = fflush(conn->file);
    
    if (rc == -1) printf("Error flushing db %ld", rc);
}

void Database_create(Connection *conn)
{
    int i = 0;
    
    for (i = 0; i < MAX_ROWS; i++) {
        Countdown ctdn = { .deadline = 0, .title = "" };
        
        conn->db->rows[i] = ctdn;
    }
}

Connection* Database_open(const char *filename)
{
    Connection *conn = malloc(sizeof(Connection));
    
    conn->db = malloc(sizeof(Database));
    
    FILE *file = fopen(filename, "r+");
    if (file) {
        // Loaded existing file
        conn->file = file;
        if (conn->file) {
            Database_load(conn);
        }
    } else {
        // New DB file
        conn->file = fopen(filename, "w");
        Database_create(conn);
    }
    
    return conn;
}

void Countdown_save(Connection *conn, Countdown *ctdn)
{
    Countdown dbRow = conn->db->rows[0];
    
    dbRow.deadline = ctdn->deadline;
    strncpy(dbRow.title, ctdn->title, MAX_TITLE-1);
    
    Database_write(conn);
}

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
    
    return Countdown_createWithTimestamp(title, deadline);
}

Countdown* Countdown_createWithTimestamp(char *title, time_t deadline)
{
    printf("Creating countdown with deadline: %ld", deadline);
    
    Countdown *ctdn = malloc(sizeof(Countdown));
    
    time_t now = time(NULL);
    if (deadline < now) {
        ctdn->deadline = now;
    } else {
        ctdn->deadline = deadline;
    }
    
    strncpy(ctdn->title, title, MAX_TITLE-1);
    
    return ctdn;
}

Tminus* Countdown_tminus(Countdown *countdown)
{
    return Countdown_tminusRelative(countdown, time(NULL));
}

Tminus* Countdown_tminusRelative(Countdown *countdown, time_t currentTime)
{
    Tminus *tminus = malloc(sizeof(Tminus));
    
    long diff = difftime(countdown->deadline, currentTime);
    if (diff <= 0) {
        tminus->difference = 0;
        sprintf(tminus->description, "Hope its not too late!");
    } else {
        long rem = (long) diff % (long) SECONDS_IN_DAY;
        int hours = round(rem / 60 / 60);
        rem = rem % (60*60);
        int minutes = round(rem/60);
        int seconds = rem % 60;
        int days = round(diff / SECONDS_IN_DAY);
        
        tminus->difference = diff;
        
        sprintf(tminus->description, "%d Days %d:%d:%d", days, hours, minutes, seconds);
    }
    
    
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

