myname="Prashanth"
s3_bucket="upgrad-prashanth"

# To update all packages
sudo apt update -y


## To check and install apache2
if [ $(apache2 -v 2)>/dev/null ];then
	echo "Apache is installed"; 
else
	echo "install apache"
	apt-get install apache2 -y
fi

## To start apache as service(This will make apache server to run automatically whenever restart happens)
systemctl start apache2.service

## To check apache is running or not, if not restart the apache service
if ! pidof apache2 > /dev/null
then
    # web server down, restart the server
    echo "Server down"
    /etc/init.d/apache2 restart > /dev/null
    sleep 10

    #checking if apache restarted or not
    if pidof apache2 > /dev/null
	then
		echo "Apache is in stoped state, Automatically restarted succesfully."
	else
		echo "Apache is in stoped state, Automatically restart failed. Please check manually."
    fi
fi


##Creating tar file and copying the tar file s3

# Time stamp
timestamp=$(date '+%d%m%Y-%H%M%S')

# Creating a tar file of .log files to tmp location
tar -cvf /tmp/${myname}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log

# Copying the tar file from tmp location to S3 bucket
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar