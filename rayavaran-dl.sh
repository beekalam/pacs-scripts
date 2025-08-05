#!/usr/bin/bash
links=( \
        '1783936'
        '1394641'
        '1192136'
        '2114547'
        '2114125'
        '1123231'
        '2109939'
        '1783936'
        '1538138'
        '2101217'
        '2113609'
        '2068040'
        '2114487'
        '2022830'
        '2107855'
        '1957715'
        '2114503'
        '729850'
        '2072594'
        '2114533'
)
for link in ${links[@]}
do
    out=`curl --location 'http://192.168.72.2:8082/api/Hospital/Get_Patient_Info' \
         --silent \
         --header 'Content-Type: application/json' \
         --header 'Authorization: Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoicGFja3N1c2VyIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiUHJhY3RpdGlvbmVyIiwiUGF0aWVudElEIjoiIiwiRW5jb3VudGVySUQiOiIiLCJQcmFjdGl0aW9uZXJJRCI6IiIsImV4cCI6MTcyNTg4MDU3MywiaXNzIjoiaHR0cHM6Ly93d3cuUmF5YXZhcmFuLmNvbSIsImF1ZCI6Imh0dHBzOi8vd3d3LlJheWF2YXJhbi5jb20ifQ.kdQncND_WN1vNxIOAldeJAtpWeIGJtyb7vtIKUL9SRI' \
         --data '{"patientID":"'$link'"}'`
    # echo $out
    nationalCode=`echo $out | jq .nationalCode`
    firstName=`echo $out | jq .firstName`
    lastName=`echo $out | jq .lastName`
    mobileNo=`echo $out | jq .mobileNo`
    echo $link,$nationalCode,$firstName,$lastName,$mobileNo
done
echo "================================================="
