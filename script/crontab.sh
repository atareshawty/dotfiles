#!/bin/bash

echo "17 20 * * * cd ~/src/atareshawty/ledger && bin/update-bean-price-db >> /tmp/cron.out" >> out
echo "15 20 * * * echo 'cron is working!' >> /tmp/cron.out" >> out
awk '!seen[$0]++' out > out_dedup
crontab out_dedup
rm -rf out out_dedup
