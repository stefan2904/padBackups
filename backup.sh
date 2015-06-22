#!/bin/bash

# update urls-list, etc
git pull

  BACKUPDIR=backup
  TMPDIR=.
  URLS=urls.list


 for URL in `cat $URLS`
  do
    NAME=`echo $URL | \
          sed 's,^http://,,g' | \
          sed 's/\./XjcuDCHX34/g'  | \
          sed 's,/export/txt,,g'   | \
          sed 's,/,835FtxcuzG,g'  | \
          sed 's/[^a-zA-Z0-9 ]//g' | \
          sed 's,835FtxcuzG,-,g'  | \
          sed 's/XjcuDCHX34/\./g'`
 
    BACKUPFILE=$BACKUPDIR/${NAME}.txt
    EPDUMPFILE=${TMPDIR}/${NAME}.tmp
  
    if [ -f $BACKUPFILE ]; then
  
         MD5BACKUP=`md5sum $BACKUPFILE | cut -d " " -f 1` 
    else
         MD5BACKUP=XX  
         touch $BACKUPFILE
         git add $BACKUPFILE 
    fi
  
    wget --no-check-certificate -O ${TMPDIR}/${NAME}.tmp $URL > /dev/null 2>&1
    MD5EPDUMP=`md5sum $EPDUMPFILE | cut -d " " -f 1`
  
    if [ $MD5BACKUP != $MD5EPDUMP ]; then
  
         mv $EPDUMPFILE $BACKUPFILE
         GITM="$URL backed up on "`date +%d.%m.%Y\ %H:%M:%S`
         echo $GITM
         git commit -m "$GITM" $BACKUPFILE
  
    else
         echo "${NAME}: Backup up-to-date"
         rm $EPDUMPFILE
    fi


 done

 # push new backups
 git push

 exit 0;


















exit 0;
