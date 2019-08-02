#! /bin/sh

echo "Enter the file location: " 
read name
echo "$name/config.xml"
if [ -f "$name/config.xml" ]
	then
	sudo awk '{
		if(match($0,/[0-9]+\.[0-9]+\.[0-9]+/)){
			pattern = substr($0,RSTART,RLENGTH);
			printf "Current version of application is %s\n",pattern;
		}
	}' "$name/config.xml"
	echo "Enter the new version higher than the previous in the format x.x.x:"
	read version	
	sudo awk -v ver=$version '{
		 gsub(/version="[0-9]+\.[0-9]+\.[0-9]+"/,"version=\"" ver "\"",$0);print $0;
	}' "$name/config.xml" > temp ;mv "$name/config.xml" "$name/config.old.xml";mv temp "$name/config.xml"
else
	echo "Config.xml not exist in the directory"
fi

if [ -f "$name/platforms/android/AndroidManifest.xml" ]
	then
    sudo awk '{
    	match($0,/android:versionCode="([0-9]+)"/,versionCode)
		if(versionCode[0]){
			print "Current versionCode of application is" versionCode[1] "It is changed to " versionCode[1]+1;
		}
	}' "$name/platforms/android/AndroidManifest.xml"	
	sudo awk -v ver=$version '{
		match($0,/android:versionCode="([0-9]+)"/,versionCode)
		if(versionCode[0])
		gsub(versionCode[0],"android:versionCode=\"" versionCode[1]+1 "\"",$0);
		gsub(/android:versionName="[0-9]+\.[0-9]+\.[0-9]+"/,"android:versionName=\"" ver "\"",$0);
		gsub("android:debuggable=\"true\"","android:debuggable=\"false\"",$0);
		print $0;
	}' "$name/platforms/android/AndroidManifest.xml" > temp ;mv "$name/platforms/android/AndroidManifest.xml" "$name/AndroidManifest.old.xml";mv temp "$name/platforms/android/AndroidManifest.xml"

else
	echo "AndroidManifest.xml not exist in the directory platforms/android"

fi
