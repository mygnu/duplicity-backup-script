#!/bin/bash
#using Duplicity to backup in GNU/Linux
#there is a lot of space for improvement
#

#Target folder in your home dir

TARGET="dirname"  # change to your folder name

# Record time and date at which this script is executed

TIMESTAMP=`date +"%d-%m-%Y_%H:%M"`
DATE=`date +"%d-%m-%Y"`

# The source directory to be backed up
SOURCE=$HOME/$TARGET


# The destination where backups are stored
# Backup is the name of my external HDD
# Create directory if it doesn't exist already'

if [ ! -d "/media/$USER/Backup/$TARGET-backup/" ]; then
  # Control will enter here if DIRECTORY doesn't exist.
mkdir /media/$USER/Backup/$TARGET-backup/

fi
DEST=file:///media/$USER/Backup/$TARGET-backup/ # where Backup is the backup external HDD, can be any dir

# Creating the logfiles with current date stamp to store backup results
LOGFILE="$TARGET-Backup_Log-$TIMESTAMP.log"
> $LOGFILE

# Create file to store current directory structure
DIR="$TARGET-Dir-$TIMESTAMP.log"
> $DIR

# Writing the Dir structure and files for later use(in case you need to restore a specific file/dir)
echo "\n===================================\n${TIMESTAMP} $HOME/$TARGET DIR STRUCTURE\n===================================\n" >> ${DIR}
ls -lR /$HOME/$TARGET >>${DIR} # I used this to have a snapshot of the current dir structure for later use

# Duration (in days) that a backup set spans
SETLIFE=14

# Maximum number of backup sets to keep
MAXSETS=1

# Set the size of the Backup archive files
VOLSIZE=256 #in MB

#########################################################
################# SCRIPT STARTS HERE ####################
#########################################################

# Begin new section in the log
echo "\n===================================\n${TIMESTAMP} NEW BACKUP $HOME/$TARGET \n===================================\n" >> ${LOGFILE}

# Perform cleanup if needed
duplicity cleanup --force ${DEST} >> ${LOGFILE}

# Delete older backup sets
duplicity remove-all-but-n-full ${MAXSETS} --force ${DEST} >> ${LOGFILE}

# Perform backup
duplicity --full-if-older-than ${SETLIFE}D --volsize $VOLSIZE ${SOURCE} ${DEST} >> ${LOGFILE}
###########################################################
############ Save your log files in a dir #################
###########################################################

# Create dir if it doesn't already exist

if [ ! -d "/media/$USER/Backup/$TARGET-backup/LOGS-$DATE" ]; then
  # Control will enter here if DIRECTORY doesn't exist.
mkdir /media/$USER/Backup/$TARGET-backup/LOGS-$DATE
fi

#moves all log files into the New folder with current Date

mv $LOGFILE /media/$USER/Backup/$TARGET-backup/LOGS-$DATE
mv $DIR /media/$USER/Backup/$TARGET-backup/LOGS-$DATE

exit 0 
