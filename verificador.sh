#!/bin/bash


verificando_dev_ativos(){
	if [ -f "ativos.txt" ]; then
		rm ativos.txt
	fi
	lista=("sda" "sdc" "sdb" "nvme" "mmc")
	for i in "${lista[@]}"; do
		output=$(lsblk | grep $i )
		if [ "$?" -eq "0" ]; then
			echo "$i" >> ativos.txt  
		fi
	done
}
verificando_se_ha(){
	output=$(lsblk | tee temp.txt)
	lista=("sda" "sdc" "sdb" "nvme" "mmc")
	loop=0
	nova_lista=()
	while read -r linha; do
		indice=0
		for i in "${lista[@]}"; do
			if [ "$linha" == "${lista[$indice]}" ]; then
				unset lista[$indice]
			else
				nova_lista+=("${lista[$indice]}")
			fi
			indice=$((indice+1))
		done
		lista=("${nova_lista[@]}")

		nova_lista=()
		loop=$((loop+1))
	done < ativos.txt
	#debug

	for i in "${lista[@]}"; do
		output=$(lsblk | grep $i)
		if [ "$?" -eq "0" ]; then
			echo "Há um dispositivo novo: $i"
		fi
	done
}
verificando_dev_ativos
while true; do 
	verificando_dev_ativos
	sleep 4
	verificando_se_ha
done
