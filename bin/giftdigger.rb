module Giftdigger
require 'watir'
require 'webdrivers'
require_relative 'botbones.rb'
require 'httparty'

gg = 0
while gg == 0 do
puts "Enter a number for your browser of choice: 1. Firefox, 2. Chrome, 3. Edge, 4. Safari"
browseopt = gets.to_i
puts "Please wait while your browser of choice is loaded."
if browseopt == 1
foxy = Watir::Browser.new :firefox
gg = 1
elsif browseopt == 2
foxy = Watir::Browser.new :chrome
gg = 1
elsif browseopt == 3
foxy = Watir::Browser.new :edge
gg = 1
elsif browseopt == 4
foxy = Watir::Browser.new :safari, technology_preview: true
gg = 1
else
puts "Selection is invalid, try again."
end
end
url = "www.steamgifts.com"
@home = URI(url)
foxy.goto(@home)
puts "After logging in, press enter to continue."
confirm = gets
puts "What term would you like to search for in the forum? 'train' is a really good option!"
term = gets
puts "How many discussions would you like to dig through? Higher numbers run into older discussions with mostly ended giveaways."
@digamount = gets.to_i
url = "www.steamgifts.com/discussions/search?q=#{term}"
@place = URI(url)
foxy.goto(@place)
@links = foxy.links.collect(&:href)
@finlinks = @links.uniq.select{|x| x.match("https://www.steamgifts.com/discussion/.*")}
num = 0
while num < @digamount do
@finlinks.each do |x|
@response = HTTParty.get(x)
givstring = "https://www.steamgifts.com/giveaway/.*\""
@fingas = Check(@response, givstring)
@fingas.each do |x|
  foxy.goto(x)
    enter = foxy.div(class: "sidebar__entry-insert")
  if enter.present? == true
    enter.click
  else
    next
  end
end
num += 1
end
puts "All done! Thanks for playing!"
end
end
