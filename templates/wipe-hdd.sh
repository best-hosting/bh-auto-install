
### sh: Wipe beginning and end of disk BEGIN

for d in {{ ['/dev'] | product (_install_conf.disks) | map('join', '/') | join(' ') }}; do
        s="$(fdisk -l "$d" | sed -nE "\_^Disk ${d}_s/.*, ([0-9]+) sectors/\1/p")"
        if [ "$s" -gt 65536 ]; then
                sk=$(($s - 65536))
        fi
        dd if=/dev/zero of="$d" bs=512 count=65536
        dd if=/dev/zero of="$d" bs=512 count=65536 seek="$sk"
done

### sh: Wipe beginning and end of disk END
