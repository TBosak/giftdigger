module Giftdigger
require 'watir'
require 'webdrivers'
require_relative 'botbones.rb'
require 'httparty'

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
