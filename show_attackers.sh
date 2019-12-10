#!/bin/bash
readonly LIMIT='10'
LOG_FILE="${1}"
#Make sure a file was suplied as an argument
if [[ ! -e "${LOG_FILE}" ]]; then
	echo "The file: ${LOG_FILE} doesn't exist" >&2
	echo "Please enter a parameter"
	exit 1
fi

#Display the CSV header
echo 'Count,IP,Location'

#Loop through the list of failed attempts and corresponding IP adresses
grep Failed syslog-sample | grep -Po "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" \
| sort | uniq -c | while read COUNT IP; do
	#If the number of failed attempts is greater than the limit, display count, IP and
	if [ "${COUNT}" -gt "${LIMIT}" ]; then
		LOCATION=$(geoiplookup "${IP}" | awk -F ', ' '{print $2}')
		echo "${COUNT},${IP},${LOCATION}"
	fi
done
exit 0
