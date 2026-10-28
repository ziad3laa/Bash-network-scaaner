# Mini Port Scanner

A simple port scanner I wrote in Bash.

## What it does

- Checks if the target is up (ping)
- Scans a range of ports that you choose
- Shows if each port is OPEN or CLOSE
- Shows the service name for common ports (SSH, HTTP, SMB, ...)
- Shows how long the scan took
- Saves the result in `Report/<ip>.txt`

## How to run

```bash
chmod +x scanner.sh
./scanner.sh
```

Then enter the target IP and the port range (example: `20-80`).

## Example

```
welcome in mini scanner
enter target ip : 127.0.0.1
please wait...................
Port Range from 1-65535 : 7998-8001
================ Network scannner ================
1. Target ip : 127.0.0.1
2. statue : ping target reachable
3. port range :7998-8001
portnum     state     service
7998          CLOSE     Unknown
7999          CLOSE     Unknown
8000          OPEN      Unknown
8001          CLOSE     Unknown
==================================================
 End
==================================================
time spent : 0m 0s
```

## Note

Only use it on devices you own or have permission to scan. This is for learning.
