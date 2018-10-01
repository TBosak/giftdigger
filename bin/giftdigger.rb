module Giftdigger
require 'watir'
require 'webdrivers'
require 'httparty'
require_relative 'botbones.rb'

foxy = Watir::Browser.new :firefox, profile: 'default'
url = "www.steamgifts.com"
@home = URI(url)
foxy.goto(@home)
puts "After logging in, press any key to continue."
confirm = gets
puts "What term would you like to search for in the forum? 'train' is a really good option!"
term = gets
puts "How many discussions would you like to dig through? Higher numbers run into older discussions with mostly ended giveaways."
@digamount = gets.to_i
url = "www.steamgifts.com/discussions/search?q=#{term}"
otherurl = "https://www.steamgifts.com/discussions/search?q=#{term}"
@place = URI(url)
foxy.goto(@place)
response = HTTParty.get(URI(otherurl))
discustring="/discussion/...../[a-z 0-9 -]+\""
links = []
response.each_line { |line| link = /#{discustring}/.match(line); links<<link }
@newlinks = []
links.each do |x|
    if x == nil
      links.delete(x)
    else
    y = x.to_s
    @newlinks<<y.gsub(/\"/,"")
  end
end
x = 0
while x < @digamount do
foxy.goto(@place)
@discussion = foxy.link(href: @newlinks[x])
@discussion.click
@disq = foxy.url
response = HTTParty.get(@disq)
givstring = "https://www.steamgifts.com/giveaway/...../[a-z 0-9 -]+\""
@fingas = Check(response, givstring)
@fingas.each do |x|
  foxy.goto(@disq)
  newga = foxy.link(href: x)
  newga.click
  #begin
    enter = foxy.div(class: "sidebar__entry-insert")
  if enter.present? == true
    enter.click
  else
    next
  end
end
  x += 1
end
puts "All done! Thanks for playing!"
end
