#! /bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
    echo "** Trapped CTRL-C"
    if [ -n $pid1 ]; then kill $pid1; fi
    if [ -n $pid2 ]; then kill $pid2; fi
    exit 1
}

function webgoat {
    java -javaagent:contrast.jar -Dcontrast.dir=working -Dcontrast.standalone.appname="$app" -Dcontrast.override.appname="$app" -Dcontrast.path="/$path" -Dcontrast.server="$server" -Dcontrast.log.daily=true -Dcontrast.level=info -jar webgoat-container-7.0.1-war-exec.jar --server.port=9090 > /dev/null 2>&1 &
}

function sheepdog {
    java -jar sheepdog-1.0-SNAPSHOT.jar -t 3 -s 3600 -d 1500 250 -a 90 -p 9090 > /dev/null 2>&1 &
}

declare -a configs=(
    "WebGoat7|DEV-42|TEST-113|STAGE-1002|PROD-134"
    "Liferay|DEV-1382|STAGE-1002|PROD-9190"
    "JSPWiki|DEV-992|TEST-113|PROD-99"
    "EnterpriseTPS|DEV-42|STAGE-1382|PROD-134"
    "FuAdmin|DEV-1|TEST-1|PROD-1"
    "FuAmics|DEV-1|TEST-1|PROD-1"
    "FuAPI|DEV-1|TEST-1|PROD-1"
    "OnlineBank|DEV-2|TEST-2|PROD-2"
    'XcalerNet|DEV-3|TEST-3|PROD-3'
    "XcalerBilling|DEV-3|TEST-3|PROD-3"
    "XcalerAdmin|DEV-3|TEST-3|PROD-3"
    "Anertix|DEV-992|TEST-2002|PROD-99"
    "Xiozo|DEV-77|TEST-77|PROD-77"
    "Putoga|DEV-77|TEST-77|PROD-77"
    "Daringo|DEV-77|TEST-77|PROD-77"
    "Baketasty|DEV-77|TEST-77|PROD-77"
    "HealPhase|DEV-77|TEST-77|PROD-77"
    "Trinuvo|DEV-77|TEST-77|PROD-77"
    "Jetstripe|DEV-77|TEST-77|PROD-77"
    "LoyalPack|DEV-77|TEST-77|PROD-77"
    "MintLevel|DEV-77|TEST-77|PROD-77"
    "FundMaturity|DEV-77|TEST-77|PROD-77"
    "Zabata|DEV-77|TEST-77|PROD-77"
    "Aqizo|DEV-77|TEST-77|PROD-77"
    "SelectValve|DEV-77|TEST-77|PROD-77"
    "UniqueSquad|DEV-77|TEST-77|PROD-77"
    "VortexDrive|DEV-77|TEST-77|PROD-77"
    "Vivup|DEV-77|TEST-77|PROD-77"
    "Knowvo|DEV-77|TEST-77|PROD-77"
    "Hoardd|DEV-77|TEST-77|PROD-77"
    "StartAgency|DEV-77|TEST-77|PROD-77"
    "LogicPost|DEV-77|TEST-77|PROD-77"
    "ActionBit|DEV-77|TEST-77|PROD-134"
    "Batayo|DEV-77|TEST-77|PROD-77"
    "Rentaga|DEV-77|TEST-77|PROD-77"
    "HitchLab|DEV-77|TEST-77|PROD-77"
    "Trackize|DEV-77|TEST-77|PROD-77"
    "Pillario|DEV-77|TEST-77|PROD-77"
    "Xixth|DEV-77|TEST-77|PROD-77"
    "Savoh|DEV-77|TEST-77|PROD-77"
    "Sarlana|DEV-77|TEST-77|PROD-77"
    "ShareChimp|DEV-77|TEST-77|PROD-77"
    "OracleFS|DEV-OFS|TEST-OFS|PROD-OFS"
    "CustomerCare|DEV-CCB|TEST-CCB|PROD-CCB"
    "WebStore|DEV-WS|STAGE-WS|PROD-WS"
    "MedicalRecords|DEV-EMR|STAGE-EMR|PROD-EMR"
    "WebPOS|DEV-WPOS|STAGE-WPOS|PROD-WPOS"
    "TradingFloor|DEV-TF|TEST-TF|PROD-TF"
    "Distable|DEV-1|TEST-1|PROD-1"
    "CContrast|DEV-1|TEST-1|PROD-1"
    "UContrast|DEV-2|TEST-2|PROD-2"
    "Vivity|DEV-3|TEST-3|PROD-3"
    "Advantly|DEV-1|TEST-1|PROD-1"
    "Precise|DEV-1|TEST-1|PROD-1"
    "Hypering|DEV-1|TEST-1|PROD-1"
    "Parally|DEV-1|TEST-1|PROD-1"
    "Notional|DEV-2|TEST-2|PROD-2"
    "Flectiv|DEV-3|TEST-3|PROD-3" )

for config in "${configs[@]}"
do
    IFS='|' read -a item <<<"$config"
    app=${item[0]}

    for ((i = 1; i < ${#item[@]}; i++))
    do
        server=${item[i]}
        path=$(echo "/$app" | tr '[:upper:]' '[:lower:]')
        echo "Starting $app on $server using $path"
        webgoat
        pid1=$!
        sleep 60
        echo "Attacking $app on $server using $path"
        sheepdog
        pid2=$!
        sleep 120
        kill -KILL $pid1
        kill -KILL $pid2
        echo "----------------"
    done

done
