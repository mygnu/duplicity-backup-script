#!/bin/bash
#
# This script uses duplicity to back up key directories and files
# and send the compressed, encrypted archives to rsync.net
#
#
#############################################################################
## USING THIS SCRIPT
## copy this file to the directory you want to backup
## run the following command from terminal in the same directory
##
## sh backup.sh /path/to/backup/drive
##
## the path is the path to the folder where you want to store the backup files
## it will create a folder named after the current folder i.e. folder-backup 
## and store backup files inside it
## it will also create log files inside the backup folder
#############################################################################


#Target folder in home

TARGET=${PWD##*/} #current dir  

# Record time and date at which this script is executed

TIMESTAMP=`date +"%d-%m-%Y_%H:%M"`
DATE=`date +"%d-%m-%Y"`

# The current dir is the source directory to be backed up
SOURCE=$PWD

DESTDIR=$1/$TARGET-backup/
# The destination where backups are stored
# Create directory if it doesn't exist already'

if [ ! -d "$DESTDIR" ]; then
  # Control will enter here if DIRECTORY doesn't exist.

mkdir $DESTDIR

fi
DEST=file:///$DESTDIR

# Creating the logfiles with current date stamp to store backup results
LOGFILE="$TARGET-Backup_Log-$TIMESTAMP.log"
> $LOGFILE

# Create file to store current directory structure
DIR="$TARGET-Dir-$TIMESTAMP.log"
> $DIR

# Writing the Dir structure and files for later use(in case you need to restore a specific file/dir)
echo "\n===================================\n${TIMESTAMP} $HOME/$TARGET DIR STRUCTURE\n===================================\n" >> ${DIR}
ls -lR $SOURCE/ >>${DIR}

# Duration (in days) that a backup set spans
SETLIFE=14

# Maximum number of backup sets to keep
MAXSETS=1

# Set the size of the Backup archive files
VOLSIZE=256 #in MB

#########################################################
# SCRIPT STARTS HERE
#########################################################

# Begin new section in the log
echo "\n===================================\n${TIMESTAMP} NEW BACKUP $HOME/$TARGET \n===================================\n" >> ${LOGFILE}

# Perform cleanup if needed e.g. after a failed previous run
duplicity cleanup --force ${DEST} >> ${LOGFILE}

# Delete older backup sets
duplicity remove-all-but-n-full ${MAXSETS} --force ${DEST} >> ${LOGFILE}

# Perform backup
duplicity --full-if-older-than ${SETLIFE}D --volsize $VOLSIZE ${SOURCE} ${DEST} >> ${LOGFILE}


###########################################################

if [ ! -d "$DESTDIR/LOGS-$DATE" ]; then
  # Control will enter here if DIRECTORY doesn't exist.
mkdir $DESTDIR/LOGS-$DATE
fi

#moves all log files into the New folder with current Date
mv $LOGFILE $DESTDIR/LOGS-$DATE
mv $DIR $DESTDIR/LOGS-$DATE

##restore file creation




exit 0 
