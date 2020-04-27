
### sh: Create network aliases on CentOS BEGIN

nl='
'
OIFS="$IFS"

ip="{{ _os_install.net[0].ip | ipaddr('address') }}"
alias_ips="{{ _os_install.net[1:] | map(attribute='ip') | map('ipaddr', 'address') | join(' ') }}"

IFS="$nl"
set -- $(grep -l -r -F -e "$ip" /etc/sysconfig/network-scripts/ifcfg-*)
if [ $# -eq 0 ]; then
    echo "Interface for main IP '$ip' not found."
    echo "Skip interface alias configuration."
    exit 1
elif [ $# -gt 1 ]; then
    echo "More, than one interface uses main IP '$ip':${nl}$* "
    echo "Skip interface alias configuration."
    exit 1
else
    ifname="${1##*-}"
fi
IFS="$OIFS"

echo "Use interface '$ifname' for configuring aliases."

IFS=" $nl"
n=0
for ip in $alias_ips; do
    devn=$ifname:$n
    cat >"/etc/sysconfig/network-scripts/ifcfg-$devn" <<EOF
DEVICE="$ifname:$n"
BOOTPROTO="static"
ONBOOT="yes"
IPADDR="$ip"
NETMASK="255.255.255.255"
EOF
    n=$((n + 1))
done
IFS="$OIFS"

### sh: Create network aliases on CentOS END

