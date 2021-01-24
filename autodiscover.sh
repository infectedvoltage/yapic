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
   #pi_ips=$(sudo nmap -sP $ip_clean | awk '/^Nmap/{ip=$NF}/B8:27:EB|DC:A6:32|E4:5F:01/{print ip}')
   #clean_pi_ips=$(echo $pi_ips |sed 's/[()]//g')

   #dirty file writes for tracing
   #echo $clean_pi_ips > /tmp/pi_ips.log
   #sed 's/\s\+/\n/g' /tmp/pi_ips.log > /tmp/pi_ips_clean.log

   #cleaner array storage
   mapfile -t pi_ips < <(sudo nmap -sP $ip_clean | awk '/^Nmap/{ip=$NF}/B8:27:EB|DC:A6:32|E4:5F:01/{print ip}'|sed 's/[()]//g'|sed 's/\s\+/\n/g')


}

check_if_clusterable(){
    while read line
    do
    #testing
        echo $line
        #ssh ubuntu@$line hostname
    done < /tmp/pi_ips_clean.log
}



get_network_range
scan_for_pis

echo $ip_clean

for key in ${pi_ips[*]}
do
echo "$key => ${pi_ips[$key]}"
done

#check_if_clusterable