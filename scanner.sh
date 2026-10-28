#!/bin/bash

declare -A service=(
    [20]="FTP-Data"
    [21]="FTP"
    [22]="SSH"
    [23]="Telnet"
    [25]="SMTP"
    [53]="DNS"
    [67]="DHCP-Server"
    [68]="DHCP-Client"
    [69]="TFTP"
    [80]="HTTP"
    [110]="POP3"
    [111]="RPCbind"
    [123]="NTP"
    [135]="MS-RPC"
    [139]="NetBIOS"
    [143]="IMAP"
    [161]="SNMP"
    [389]="LDAP"
    [443]="HTTPS"
    [445]="SMB"
    [465]="SMTPS"
    [587]="SMTP-Submission"
    [993]="IMAPS"
    [995]="POP3S"
    [1433]="MSSQL"
    [1521]="Oracle-DB"
    [2049]="NFS"
    [3306]="MySQL"
    [3389]="RDP"
    [5432]="PostgreSQL"
    [5900]="VNC"
    [6379]="Redis"
    [8080]="HTTP-Proxy"
    [8443]="HTTPS-Alt"
    [27017]="MongoDB"
)


echo "welcome in mini scanner "

read -p "enter target ip : " ip

echo "please wait..................."

start_time=$(date +%s)

if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
statue="ping target reachable"
else
echo "Target Unreachable"
statue="Target Unreachable"
exit 1
fi

read -p "Port Range from 1-65535 : " port
start=$(echo $port | cut -d- -f1)
end=$(echo $port | cut -d- -f2)
if (( start < 1 || end > 65535 || start > end )); then
echo "Error : range must be between 1 and 65535"
exit 1
fi

oport=$(for ((port=start; port<=end; port++)); do
        nport=${service[$port]:-Unknown}
        if timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null; then
                echo "$port          OPEN      $nport "
        else    echo "$port          CLOSE     $nport"
        fi
done)



echo "================ Network scannner ================"

echo "1. Target ip : $ip "

echo "2. statue : $statue" 

echo "3. port range :$start-$end "

echo "portnum     state     service "

echo "$oport"

echo "=================================================="
                       echo   " End "
echo "=================================================="





end_time=$(date +%s)
elapsed=$((end_time - start_time))
minute=$((elapsed / 60))
second=$((elapsed % 60))
echo "time spent : ${minute}m ${second}s "


mkdir -p Report
{
        echo "$ip"
        echo "$statue"
        echo "port you choose range :$start-$end"
        echo "$oport"
        echo "time spent : ${minute}m ${second}s "
        echo ""

} > Report/$ip.txt
