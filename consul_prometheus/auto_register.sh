#! /bin/bash
Red="\033[31m"
Green="\033[32m"
Yellow="\033[33m"
Color="\033[0m"
Env="prod"
consul_ip="192.168.0.204"
\rm -f ./node_expoter.ip
white_ip_list=(
192.168.0.31)

ip="192.168.0."
hosts=$(seq 1 255)

for host in ${hosts[*]}
do
	{
	nc -z -w 1  192.168.0.${host} 9100 > /dev/null 2>&1
if [ $? -eq 0 ]; then
	echo -e "$Green${ip}${host} ok." >> ./node_expoter.ip
	echo -e "$Green${ip}${host} ok."
	node_ip="${ip}${host}"
	mkdir -p ./ip_list
	echo ${white_ip_list} | grep ${node_ip}
	if [ $? -eq 0 ]
   	then
      		echo -e "$Red ${node_ip} in white_ip_list!"
      		continue
  	fi
	cp ./prod_consul.json.tem ./ip_list/${node_ip}prod_consul.json
	sed -i "s/127.0.0.1/${node_ip}/g" ./ip_list/${node_ip}prod_consul.json
	curl --request PUT --data @./ip_list/${node_ip}prod_consul.json http://${consul_ip}:8500/v1/agent/service/register
	cp ./prod_consul.json.tem ./prod_consul.json
else
	echo -e "$Red${ip}${host} error!" > /dev/null 2>&1
fi
	}&
done
