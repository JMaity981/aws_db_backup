#!/bin/bash

#***********************************************************************************************#
#                       Website source and database back script                                 #
#Executable parameter : backup_dbnsource.sh <backup_type>  					#
#Executable parameter : backup_dbnsource.sh F/I (F=Full backup, I=Incremental backup)		#
# Created by : 	Soumen (soumenmiddey@gmail.com)							#
#***********************************************************************************************#
#echo $#

vuser=$USER
vdbname=lalbaba
#vuser=lalbaba
cd $HOME

LOGFILE=$vdbname'_DBbackup.log'
SOURCE_PATH='/var/www/html/'

dt=`date +%d/%m/%Y`
tm=`date +%H:%M:%S`

hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
bk_type=$1


echo "**************************************" >> $LOGFILE
echo "================Starting==============" >> $LOGFILE
echo "**************************************" >> $LOGFILE
echo " " >> $LOGFILE

echo "Backup Started at $hhmiss" >> $LOGFILE



if [ "$bk_type" = "F" ] 
then
	DATABASE_BK_FILE='backup/'$vdbname'_proddbFull_'`date +%d%m%Y_%H%M%S`'.sql'
	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	echo "Database Full Backup STARTING at $hhmiss : FILENAME=$DATABASE_BK_FILE" >> $LOGFILE

	mysqldump --defaults-extra-file=backup/.backup.inf --routines --events lalbabaonline_db>$DATABASE_BK_FILE
	retval=$?
	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	echo "Database Backup DONE   at $hhmiss : FILENAME=$DATABASE_BK_FILE ">> $LOGFILE

	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	if [ 0 = $retval ]
	then
		gzip $DATABASE_BK_FILE
	else
		echo "Database Full Backup FAILED  at $hhmiss : FILENAME=$DATABASE_BK_FILE with Error code=$retval">> $LOGFILE
	fi

	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	echo "Database Full Backup COMPRESSION DONE   at $hhmiss : FILENAME=$DATABASE_BK_FILE.gz" >> $LOGFILE
fi

if [ "$bk_type" = "I" ] 
then
	DATABASE_BK_FILE='backup/'$vdbname'_proddbINCR_'`date +%d%m%Y_%H%M%S`'.sql'
	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	echo "Database Incremental Backup STARTING at $hhmiss : FILENAME=$DATABASE_BK_FILE" >> $LOGFILE

	mysqldump --defaults-extra-file=backup/.backup.inf --routines --events lalbabaonline_db>$DATABASE_BK_FILE
	retval=$?
	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	echo "Database Backup DONE   at $hhmiss : FILENAME=$DATABASE_BK_FILE ">> $LOGFILE

	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	if [ 0 = $retval ]
	then
		gzip $DATABASE_BK_FILE
	else
		echo "Database Incremental Backup FAILED  at $hhmiss : FILENAME=$DATABASE_BK_FILE with Error code=$retval">> $LOGFILE
	fi

	hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
	echo "Database Full Backup COMPRESSION DONE   at $hhmiss : FILENAME=$DATABASE_BK_FILE.gz" >> $LOGFILE
fi

hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
echo "$hhmiss : * Disk Space Info *" >> $LOGFILE
echo "$hhmiss : ===================" >> $LOGFILE
df -h >> $LOGFILE
 
hhmiss="`date +%d/%m/%Y` `date +%H:%M:%S`"
echo "$hhmiss : * Memory Info *" >> $LOGFILE
echo "$hhmiss : ===============" >> $LOGFILE
grep Mem /proc/meminfo >>$LOGFILE
exit 0
