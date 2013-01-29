#!/bin/bash
cd sounds
for i in *.wav; do
  afconvert -f caff -d LEI16 $i
done