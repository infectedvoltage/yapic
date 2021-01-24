#!/bin/bash
#
# Autodiscover.sh
# this script will automatically discover any raspberry pi devices on your network, list them and create an ansible inventory file for them.
#

#init vars

get_network_range() {
    ip_dirty=$(ip a | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9/]*).*/\2/p')
    ip_clean=$(echo $ip_dirty | cut -d " " -f 1)


}


scan_for_pis() {
   mapfile -t pi_ips < <(sudo nmap -sP $ip_clean | awk '/^Nmap/{ip=$NF}/B8:27:EB|DC:A6:32|E4:5F:01/{print ip}'|sed 's/[()]//g'|sed 's/\s\+/\n/g')
}

check_if_clusterable(){
for key in ${pi_ips[@]}
do
echo $key
ssh ubuntu@$key hostname
done
}



get_network_range
scan_for_pis

echo $ip_clean



#check_if_clusterable