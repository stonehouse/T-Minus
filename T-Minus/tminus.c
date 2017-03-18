//
//  tminus.c
//  T-Minus
//
//  Created by Alexander Stonehouse on 19/02/17.
//  Copyright © 2017 Alexander Stonehouse. All rights reserved.
//

#include "tminus.h"
#include <limits.h>

#define CURRENT_DB_VERSION 2

typedef struct Database {
    int version;
    Countdown rows[MAX_ROWS];
} Database;

typedef struct Connection {
    FILE *file;
    int readIndex;
    Database *db;
    int inMemory;
} Connection;

void Database_create(Connection *conn);

void Database_load(Connection *conn)
{
    size_t rc = fread(conn->db, sizeof(Database), 1, conn->file);
    
    if (rc != 1) printf("Error reading database! (%ld)\n", rc);
    
    if (conn->db->version != CURRENT_DB_VERSION) {
        printf("DB is out of date, creating new one\n");
        Database_create(conn);
    }
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
    if (conn->inMemory) {
        return; // Don't write to file if in memory
    }
    
    rewind(conn->file);
    
    size_t rc = fwrite(conn->db, sizeof(Database), 1, conn->file);
    
    if (rc != 1) printf("Error writing to db %ld\n", rc);
    
    rc = fflush(conn->file);
    
    if (rc == -1) printf("Error flushing db %ld\n", rc);
}

void Database_createRow(Connection *conn, int row)
{
    Countdown ctdn = { .index = row, .deadline = 0, .title = "" };
    
    conn->db->rows[row] = ctdn;
}

void Database_create(Connection *conn)
{
    int i = 0;
    
    conn->db->version = CURRENT_DB_VERSION;
    
    for (i = 0; i < MAX_ROWS; i++) {
        Database_createRow(conn, i);
    }
}

Connection* Database_open(const char *filename)
{
    Connection *conn = malloc(sizeof(Connection));
    
    conn->inMemory = 0;
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
    
    if (!conn->file) {
        Database_close(conn);
        printf("Creating in memory DB\n");
        return Database_openInMemory();
    }
    
    return conn;
}

Countdown* Countdown_getIndex(Connection *conn, int index)
{
    Countdown ctdn = conn->db->rows[index];
    
    long diff = difftime(ctdn.deadline, time(NULL));
    
    if (ctdn.deadline == 0 || diff <= 0) {
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
    int i;
    int index = conn->readIndex;
    Countdown *ctdn;
    
    for (i = index; i < MAX_ROWS; i++) {
        ctdn = Countdown_getIndex(conn, i);
        conn->readIndex++;
        if (ctdn) {
            return ctdn;
        }
    }
    
    return NULL;
}

Countdown* Countdown_getMostUrgent(Connection *conn)
{
    int i;
    int mostUrgentIndex = 0;
    long mostUrgent = LONG_MAX;
    Countdown *ctdn;
    
    for (i = 0; i < MAX_ROWS; i++) {
        ctdn = Countdown_getIndex(conn, i);
        if (ctdn) {
            if (ctdn->deadline < mostUrgent) {
                mostUrgent = ctdn->deadline;
                mostUrgentIndex = i;
            }
        }
    }
    
    return Countdown_getIndex(conn, mostUrgentIndex);
}

Countdown* Countdown_create(Connection *conn)
{
    int i;
    Countdown *ctdn;
    
    for (i = 0; i < MAX_ROWS; i++) {
        ctdn = Countdown_getIndex(conn, i);
        if (!ctdn) {
            printf("Creating countdown at index %d\n", i);
            ctdn = malloc(sizeof(Countdown));
            ctdn->index = i;
            ctdn->deadline = 0;
            ctdn->background[0] = '\0';
            ctdn->title[0] = '\0';
            return ctdn;
        }
    }
    
    printf("Max countdowns reached\n");
    return NULL;
}

void Countdown_delete(Connection *conn, Countdown *ctdn)
{
    int index = ctdn->index;
    // Replace existing row with empty template
    Database_createRow(conn, index);
    Database_write(conn);
}

Countdown* Countdown_createWithTimestamp(Connection *conn, const char *title, time_t deadline, const char *bgPath)
{
    Countdown *ctdn = Countdown_create(conn);
    if (ctdn) {
        ctdn->deadline = deadline;
        if (title) {
            strncpy(ctdn->title, title, MAX_TITLE-1);
        }
        if (bgPath) {
            strncpy(ctdn->background, bgPath, MAX_BACKGROUND_PATH-1);
        }
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
    printf("Saving countdown %d with deadline: %ld\n", ctdn->index, ctdn->deadline);
    
    Countdown *row = &conn->db->rows[ctdn->index];
    row->deadline = ctdn->deadline;
    strncpy(row->title, ctdn->title, MAX_TITLE-1);
    strncpy(row->background, ctdn->background, MAX_BACKGROUND_PATH-1);
    
    Database_write(conn);
}

Tminus Countdown_tminus(Countdown *countdown)
{
    return Countdown_tminusRelative(countdown, time(NULL));
}

Tminus Countdown_tminusRelative(Countdown *countdown, time_t currentTime)
{
    Tminus tminus;
    tminus.description[0] = '\0';
    
    long diff = difftime(countdown->deadline, currentTime);
    if (diff <= 0) {
        tminus.finished = 1;
        tminus.difference = 0;
        sprintf(tminus.description, "Lift Off!");
    } else {
        tminus.finished = 0;
        long rem = (long) diff % (long) SECONDS_IN_DAY;
        int hours = round(rem / 60 / 60);
        rem = rem % (60*60);
        int minutes = round(rem/60);
        int seconds = rem % 60;
        int days = round(diff / SECONDS_IN_DAY);
        
        tminus.days = days;
        tminus.hours = hours;
        tminus.minutes = minutes;
        tminus.seconds = seconds;
        tminus.difference = diff;
        
        if (days > 0) {
            sprintf(tminus.description, "%d Days %02d:%02d:%02d", days, hours, minutes, seconds);
        } else if (hours > 0) {
            sprintf(tminus.description, "%02d:%02d:%02d", hours, minutes, seconds);
        } else if (minutes > 0) {
            sprintf(tminus.description, "%d Minutes %d", minutes, seconds);
        } else if (seconds > 10) {
            sprintf(tminus.description, "%d Seconds", seconds);
        } else {
            char *finalCountdown[] = {
                "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"
            };
            sprintf(tminus.description, "%s...", finalCountdown[seconds-1]);
        }
    }
    
    return tminus;
}

int Countdown_count(Connection *conn)
{
    int i;
    int count = 0;
    
    for (i = 0; i < MAX_ROWS; i++) {
        Countdown ctdn = conn->db->rows[i];
        long diff = difftime(ctdn.deadline, time(NULL));
        
        if (ctdn.deadline != 0 && diff > 0) {
            count++;
        }
    }
    
    return count;
}


void Countdown_destroy(Countdown *countdown)
{
    free(countdown);
}

// Test helpers

Connection* Database_openInMemory() {
    Connection *conn = malloc(sizeof(Connection));
    
    conn->db = malloc(sizeof(Database));
    Database_create(conn);
    conn->inMemory = 1;
    return conn;
}

