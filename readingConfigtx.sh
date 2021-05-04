echo > outputFile.txt
IFS=''
j=2
k=2
flag=0

function removeFile {
	rm outputFile.txt
}

function startNetwork {
	cp outputFile.txt /Users/aurachristinateasley/fresh-fabric/fabric-samples/test-network/configtx/configtx.yaml
	pushd /Users/aurachristinateasley/fresh-fabric/fabric-samples/fabcar
	./startFabric.sh
	pushd /Users/aurachristinateasley/fresh-fabric/fabric-samples/fabcar/go
	(time go run attemptingConcurrency.go) &>CPUandTime"$j""$k".txt
	go run queryAllHighThroughput.go &>ledger"$j""$k".txt
	docker logs -t peer0.org1.example.com &>peerLog"$j""$k".txt
	cp ledger"$j""$k".txt /Users/aurachristinateasley/Desktop/"Lab Meetings"/"Weekly Pursuits 4.12 - 4.19"/MontyCarloResults/Ledger
	cp CPUandTime"$j""$k".txt /Users/aurachristinateasley/Desktop/"Lab Meetings"/"Weekly Pursuits 4.12 - 4.19"/MontyCarloResults/CPUandTime
	cp peerLog"$j""$k".txt /Users/aurachristinateasley/Desktop/"Lab Meetings"/"Weekly Pursuits 4.12 - 4.19"/MontyCarloResults/PeerLog
	rm CPUandTime"$j""$k" ledger"$j""$k" peerLog"$j""$k"
	popd
	popd
}

function decrementK () {
	k=2
}

function incrementK () {
	k=$(($k+2))
}

function incrementJ () {
	j=$(($j+2))
}

function readFile () {
	removeFile
	input="/Users/aurachristinateasley/Desktop/configtx.yaml" 
	while read data; do 
		if [ "$data" == "    BatchTimeout: 0s" ]; then
			echo "    BatchTimeout: "$j"s" >> outputFile.txt
		elif [ "$data" == "        MaxMessageCount: 0" ]; then
			echo "        MaxMessageCount: "$k"" >> outputFile.txt
		else
			echo $data >> outputFile.txt
		fi
	done < $input
	if [ $k -ge 50 ]; then
		incrementJ
		decrementK
	fi
	incrementK
	startNetwork
	echo "Done: j is now $j, k is now $k"
}

while [ $j -le 50 ]; do
        readFile $j $k
done
