#!/bin/sh

gmail_user=$1
gmail_pass=$2
to_address=$3
fr_address=$4
em_subject=$5
remote_url=$6

if [ ! -f "output/curr" ];
then
  curl -s "$remote_url" > output/curr
fi

mv output/curr output/last

curl -s "$remote_url" > output/curr

diff output/curr output/last | grep -v '^>' | sed -e 's:^<[   ]*::g' | grep '^<a' | sed -e 's:<a href="\(.*\)">\(.*\)</a>:\1\ \2:g' > output/diff 
diff output/curr output/last | grep -v '^>' | sed -e 's:^<[   ]*::g' | grep '^<a' | sed -e 's:<a href="\(.*\)">\(.*\)</a>:\1\ \2:g' 

if [ -s "output/diff" ];
then
  diff output/curr output/last | grep '^<' | sed -e 's:^<::g' >> output/history
  while read line; do
    ruby ./mail.rb "$gmail_user" "$gmail_pass" "$to_address" "$fr_address" "$em_subject" "$line"
  done < output/diff
  cat output/diff >> output/diff_history
fi
