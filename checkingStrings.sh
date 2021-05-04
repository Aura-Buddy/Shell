echo > outputFile.txt
IFS=''
i="hi"
j=0
input="check.txt"
while read data; do
	echo "1 $data"
done < $input
echo done
