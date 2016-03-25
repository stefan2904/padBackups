#!/bin/bash

# update urls-list, etc
git pull origin master
git checkout backup
git pull origin backup
git merge master

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

  echo "${NAME}: Loading.."
  HTTPSTATUSCODE="$(wget -S --no-check-certificate -O ${TMPDIR}/${NAME}.tmp $URL 2>&1 | grep "HTTP/" | tail -1 | awk '{print $2}')"
  MD5EPDUMP=`md5sum $EPDUMPFILE | cut -d " " -f 1`

  if (( $HTTPSTATUSCODE < 300 )) && (($HTTPSTATUSCODE >= 200 )); then
    echo "HTTP Status Code Success:" $HTTPSTATUSCODE

        if [ $MD5BACKUP != $MD5EPDUMP ]; then

             mv $EPDUMPFILE $BACKUPFILE
             GITM="$URL backed up on "`date +%d.%m.%Y\ %H:%M:%S`
             echo "Backed up on "`date +%d.%m.%Y\ %H:%M:%S`
             git commit -m "$GITM" $BACKUPFILE

        else
            echo "Backup up-to-date"
            rm $EPDUMPFILE
        fi
    else
        echo "HTTP Status Code Failed:" $HTTPSTATUSCODE
        rm $EPDUMPFILE
   fi
done

# push new backups
git push

exit 0;
