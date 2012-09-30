require 'gmailer'
data = File.read(ARGV[3])
Gmailer.mail 'txteor', 'password', ARGV[0], 'txteor@gmail.com', 'New Craigslist Posting', data
