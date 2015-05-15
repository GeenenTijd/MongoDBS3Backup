#!/bin/bash
#
# Argument = -d database -b bucket
#

set -e

export PATH="$PATH:/usr/local/bin"

usage()
{
cat << EOF
usage: $0 options

This script dumps selected mongo database, tars it, then sends it to an Amazon S3 bucket.

OPTIONS:
   -d      Amazon S3 region
   -b      Amazon S3 bucket name
EOF
}

DATABASE=
S3_BUCKET=

while getopts “d:b:” OPTION
do
  case $OPTION in
    d)
      DATABASE=$OPTARG
      ;;
    b)
      S3_BUCKET=$OPTARG
      ;;
    ?)
      usage
      exit
    ;;
  esac
done

if [[ -z $S3_BUCKET ]]
then
  usage
  exit 1
fi

# Get the directory the script is being run from
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $DIR
# Store the current date in YYYY-mm-DD-HHMMSS
DATE=$(date -u "+%F-%H%M%S")
FILE_NAME="backup-$DATE"
ARCHIVE_NAME="$FILE_NAME.tar.gz"

# Dump the database
if [[ -z $DATABASE ]]
then
	mongodump --out $DIR/backup/$FILE_NAME
else
	mongodump --db $DATABASE --out $DIR/backup/$FILE_NAME
fi

# Tar Gzip the file
tar -C $DIR/backup/ -zcvf $DIR/backup/$ARCHIVE_NAME $FILE_NAME/

# Remove the backup directory
rm -r $DIR/backup/$FILE_NAME

# Send the file to the backup drive or S3

s3cmd put $DIR/backup/$ARCHIVE_NAME s3://$S3_BUCKET/$ARCHIVE_NAME

# File is uploaded, remove the archive

rm $DIR/backup/$ARCHIVE_NAME
