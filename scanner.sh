#!/usr/bin/env bash

# Educational TCP port scanner for authorized lab targets only.
# Usage: ./scanner.sh

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
    [8080]="HTTP-Alt"
    [8443]="HTTPS-Alt"
    [27017]="MongoDB"
)

echo "Welcome to Mini Bash Network Scanner"
read -r -p "Enter target IPv4 address: " ip

# Basic IPv4 format and octet validation
if [[ ! "$ip" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "Error: enter a valid IPv4 address."
    exit 1
fi

IFS='.' read -r -a octets <<< "$ip"
for octet in "${octets[@]}"; do
    if (( 10#$octet > 255 )); then
        echo "Error: IPv4 octets must be between 0 and 255."
        exit 1
    fi
done

read -r -p "Scan all TCP ports 1-65535? (y/N): " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Scan cancelled."
    exit 0
fi

echo "Checking target reachability..."
if ping -c 1 -W 1 "$ip" >/dev/null 2>&1; then
    status="ICMP reachable"
else
    status="No ICMP response (host may still be reachable)"
fi

start_time=$(date +%s)
report_dir="Reports"
mkdir -p "$report_dir"
report_file="$report_dir/${ip}.txt"

{
    echo "Mini Bash Network Scanner Report"
    echo "Target IP: $ip"
    echo "Reachability check: $status"
    echo "TCP port range: 1-65535"
    echo "Started: $(date)"
    echo
    printf "%-8s %-12s %s\n" "PORT" "STATE" "COMMON SERVICE"
    printf "%-8s %-12s %s\n" "--------" "------------" "--------------"
} > "$report_file"

echo "Target: $ip"
echo "Reachability: $status"
echo "Scanning TCP ports 1-65535. This may take a long time..."
echo "Only open ports will be displayed."

open_count=0
for ((port=1; port<=65535; port++)); do
    if timeout 1 bash -c "echo > /dev/tcp/$ip/$port" 2>/dev/null; then
        name="${service[$port]:-Unknown}"
        printf "%-8s %-12s %s\n" "$port" "OPEN" "$name" | tee -a "$report_file"
        ((open_count+=1))
    fi
done

end_time=$(date +%s)
elapsed=$((end_time - start_time))
minutes=$((elapsed / 60))
seconds=$((elapsed % 60))

{
    echo
    echo "Open TCP ports found: $open_count"
    echo "Elapsed time: ${minutes}m ${seconds}s"
    echo "Finished: $(date)"
} | tee -a "$report_file"

echo "Report saved to: $report_file"
echo "Note: service names are guesses based on common port numbers, not verified service detection."
