//
//  tminus.c
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#include "tminus.h"

typedef struct Database {
    Countdown rows[MAX_ROWS];
} Database;

typedef struct Connection {
    FILE *file;
    int readIndex;
    Database *db;
} Connection;

void Database_load(Connection *conn)
{
    size_t rc = fread(conn->db, sizeof(Database), 1, conn->file);
    
    if (rc != 1) printf("Error reading database!");
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

Countdown* Countdown_getIndex(Connection *conn, int index)
{
    Countdown ctdn = conn->db->rows[index];
    
    if (ctdn.deadline == 0) {
        return NULL;
    } else {
        Countdown *ptr = malloc(sizeof(Countdown));
        ptr->index = ctdn.index;
        ptr->deadline = ctdn.deadline;
        strncpy(ptr->title, ctdn.title, MAX_TITLE-1);
        strncpy(ptr->background, ctdn.background, MAX_BACKGROUND_PATH-1);
        return ptr;
    }
}

Countdown* Countdown_get(Connection *conn)
{
    int i = conn->readIndex;
    Countdown *ctdn;
    
    for (i = 0; i < MAX_ROWS; i++) {
        ctdn = Countdown_getIndex(conn, i);
        conn->readIndex++;
        if (ctdn) {
            return ctdn;
        }
    }
    
    return NULL;
}

Countdown* Countdown_create(Connection *conn)
{
    int i;
    Countdown *ctdn;
    
    for (i = 0; i < MAX_ROWS; i++) {
        ctdn = Countdown_getIndex(conn, i);
        if (!ctdn) {
            ctdn = malloc(sizeof(Countdown));
            ctdn->index = i;
            return ctdn;
        }
    }
    
    return NULL;
}

Countdown* Countdown_createWithTimestamp(Connection *conn, const char *title, time_t deadline, const char *bgPath)
{
    Countdown *ctdn = Countdown_create(conn);
    if (ctdn) {
        ctdn->deadline = deadline;
        strncpy(ctdn->title, title, MAX_TITLE-1);
        strncpy(ctdn->background, bgPath, MAX_BACKGROUND_PATH-1);
    }
    
    return ctdn;
}

time_t createTimestamp(int year, int month, int day, int hour, int minute)
{
    struct tm t;
    time_t timestamp;
    t.tm_year = year-1900;
    t.tm_mon = month-1;
    t.tm_mday = day;
    t.tm_hour = hour;
    t.tm_min = minute;
    t.tm_sec = 0;
    t.tm_isdst = -1;
    timestamp = mktime(&t);
    
    return timestamp;
}

void Countdown_save(Connection *conn, Countdown *ctdn)
{
    printf("Saving countdown %d with deadline: %ld", ctdn->index, ctdn->deadline);
    
    Countdown *row = &conn->db->rows[ctdn->index];
    row->deadline = ctdn->deadline;
    strncpy(row->title, ctdn->title, MAX_TITLE-1);
    strncpy(row->background, ctdn->background, MAX_BACKGROUND_PATH-1);
    
    Database_write(conn);
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

