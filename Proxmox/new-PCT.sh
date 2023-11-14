pct create 115 /var/lib/vz/template/cache/ubuntu-22.10-standard_22.10-1_amd64.tar.zst \
    --arch amd64 --ostype ubuntu --hostname hostname --cores 2 --memory 1024 --cpulimit 2 \ 
    --swap 512 --storage local-lvm --password "password" --net0 name=eth0,firewall=0,hwaddr=xx:xx:xx:xx:xx:xx,ip=dhcp,bridge=vmbr0 \
    --ssh-public-keys /path/to/public/keys --nameserver "IP string" --searchdomain searchdomain --unprivileged true
