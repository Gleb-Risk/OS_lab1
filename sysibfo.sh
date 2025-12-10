!/bin/bash

echo -n "OS: "
if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$PRETTY_NAME"
elif command -v lsb_release >/dev/null 2>&1; then
        lsb_release -d | cut -d":" -f2 | sed 's/^[ /t]*//'
else
        echo "Unknown"
fi

echo -n "Kernel: "
uname -r

echo -n "Architecture: "
uname -m

echo -n "Hostname: "
hostname

echo -n "User: "
whoami

echo "RAM: "
free -m | awk '/Mem:/ {print $7 "MB free / " $2 "MB total"}'
echo "swap: "
free -m | awk '/Mem:/ {print $4 "MB free / " $2 "MB total"}'

ram_total=$(free -m | awk '/Mem:/ {print $2}')
swap_total=$(free -m | awk '/Swap:/{print $2'})
virtual_mem=$((ram_total + swap_total))
echo "Virtual memory: ${virtual_mem} MB"


echo -n "Processors: "
nproc

echo -n "Load average; "
cat /proc/loadavg | awk '{print $1 ", "$2", " $3}'

echo "Drivers"
df -h --output=target,fstype,avail,size | tail -n +2 | while read -r mountpoint fstype avail size; do
        echo "  $mountpoint $fstype $avail free / $size total"
done


