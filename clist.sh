#!/bin/sh

#http://sfbay.craigslist.org/search/hhh/sfc?query=&srchType=A&minAsk=&maxAsk=3600&bedrooms=2&addTwo=purrr&nh=110&nh=3&nh=14&nh=15&nh=16&nh=18&nh=23&nh=26&nh=27&nh=28&nh=29&nh=114

if [ ! -f "output/curr" ];
then
  curl "$1" > output/curr
fi

mv output/curr output/last

curl -s "$1" > output/curr

diff output/curr output/last | grep -v '^>' | sed -e 's:^<[   ]*::g' | grep '^<a' | sed -e 's:<a href="\(.*\)">\(.*\)</a>:\2\: \1:g' > output/diff 

if [ -s "output/diff" ];
then
  diff output/curr output/last | grep '^<' | sed -e 's:^<::g' >> output/history
  ruby ./mail.rb '3172813881@txt.att.net', 'txteor@gmail.com', 'New Craigslist Posting', 'output/diff'
fi
