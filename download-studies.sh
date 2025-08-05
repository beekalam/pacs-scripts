#!/bin/bash

server=""
server=""
port=""
aec=""
patientid=""
targetdir=""

while getopts 's:p:a:i:t:h' OPTION
do
    case $OPTION in
        s) server="$OPTARG" ;;
        p) port="$OPTARG" ;;
        a) aec="$OPTARG" ;;
        i) patientid="$OPTARG" ;;
        t) targetdir="$OPTARG" ;;
        h) printf "usage: download-studies.sh -s <server_ip> -p <port> -a <aec> -i <patient_id> -t <download_dir> \n"
           exit 2
           ;;
   esac
done

declare -A args
args=( [server]=$server [port]=$port [aec]=$aec [patientid]=$patientid [targetdir]=$targetdir )
for arg in ${!args[@]}
do
    if [[ -z "${args[$arg]}" ]]; then
        echo "$arg not provided."
        exit 1
    fi
done
echo "===> Download dir: $targetdir"
if [ ! -d "$targetdir" ]; then
    echo "===> $targetdir does not exist."
    exit 1
fi



echo "===> Testing connection with $server."
echoscu "$server" "$port" -aec "$aec" -q
if [[ $? == '0' ]]
then
    echo "===> Successfully connected to  $server $port $aec"
else
    echo "====> Can not connect to $server $port $aec"
    exit;
fi

patient_dir="$targetdir/$patientid"
xml_file_path="$targetdir/$patientid/$patientid.xml"
rm -rf $patient_dir
mkdir -p $patient_dir

echo "===> Finding studies."
findscu -aec "$aec" "$server" "$port" -S -k QueryRetrieveLevel=STUDY -k PatientID="$patientid" -k StudyInstanceUID -Xs "$xml_file_path"
study_uids=( $(cat "$xml_file_path" | grep StudyInstanceUID |  sed 's#<[^>]*>##g') )

for suid in "${study_uids[@]}"
do
    echo "===> getting study with UID: $suid"
    mkdir "$patient_dir/$suid"
    echo "getscu -v +v  -aec \"$aec\"  \"$server\" \"$port\" -P -k  \"0008,0052=STUDY\" -k \"0020,000D=$suid\" -k \"0010,0020=$patientid\" -od \"$patient_dir/$suid\""
    getscu -v +v  -aec "$aec"  "$server" "$port" -P -k  "0008,0052=STUDY" -k "0020,000D=$suid" -k "0010,0020=$patientid" -od "$patient_dir/$suid"
done

echo "===> Saved to: $patient_dir"

