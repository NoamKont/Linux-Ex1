#!/bin/bash

NUMBERS_OF_BLOCKS=$1
MAIN_URL="https://api.blockcypher.com/v1/btc/main"

URL=$(wget -q -O - "$MAIN_URL"| grep latest_url | sed 's/"latest_url"://g' | sed 's/[", ]//g')

wget -O - "$URL" >> "blockChain.json" 2>/dev/null

for (( i = 1; i < $NUMBERS_OF_BLOCKS; i++ )); 
do
 
 URL=$(tail -n 44 blockChain.json | grep prev_block_url | sed 's/"prev_block_url"://g' | sed 's/[", ]//g')
 wget -O - "$URL" >> "blockChain.json" 2>/dev/null

done

cat blockChain.json | grep "hash\|height\|time\|prev_block\|relayed_by\|total"| sed 's/[",  ]//g' | sed '/prev_block_url/d' | sed '/prev_block/s/$/\n\t\t|\n\t\t|\n\t\t|\n\t\t|\n\t\tv/g' | head -n -5   > OUTPUT_FILE.json
 
 cat OUTPUT_FILE.json
 
rm blockChain.json
rm OUTPUT_FILE.json