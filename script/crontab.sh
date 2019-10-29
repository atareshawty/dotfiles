#!/bin/bash

crontab -l > out
echo "5 21 * * * cd ~/src/atareshawty/ledger && bin/update-bean-price-db >> /tmp/cron.out" >> out
awk '!seen[$0]++' out > out_dedup
crontab out_dedup
rm -rf out out_dedup
