MongoDBS3Backup
=================================

This script is based on the [s3cmd](http://s3tools.org/s3cmd)

Setup
-----
1. Register for Amazon AWS 
2. Install s3cmd (following commands are for debian/ubuntu, but you can find how-to for other Linux distributions on [s3tools.org/repositories](http://s3tools.org/repositories))

		wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
		sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
		sudo apt-get update && sudo apt-get install s3cmd
	
3. Get your key and secret key at this [link](https://aws-portal.amazon.com/gp/aws/developer/account/index.html?ie=UTF8&action=access-key)
4. Configure s3cmd to work with your account

		s3cmd --configure

5. Make a bucket (must be an original name, s3cmd will tell you if it's already used)

		s3cmd mb s3://mybucket
	
Now we're set. You can use it manually:

	sh /home/youruser/backup.sh -d mydb -b mybucket
	
But, we don't want to think about it until something breaks! So enter `crontab -e` and insert the following after editing the folders

	# daily backup to S3
	0 3 * * * sh /home/youruser/mysqltos3.sh -d mydb -b mybucket
	# weekly backup to S3
	0 3 * * 0 sh /home/youruser/mysqltos3.sh -d mydb -b mybucket
	# monthly backup to S3
	0 3 1 * * sh /home/youruser/mysqltos3.sh -d mydb -b mybucket

And you're set.
