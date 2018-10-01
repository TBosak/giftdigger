require 'httparty'
x=0
while x == 0 do
@html = File.open("STEAMKEYS.html", "w+")
puts "Please enter the website url to begin scraping:"
url = gets.chomp
keys = []
@response = HTTParty.get(URI(url))
@response.each_line { |line| key = /(\w{5}-){2}\w{5}/.match(line); keys<<key }
keys.each do |x|
    if x == nil
      next
    else
      @html.write("<a href=\"https://store.steampowered.com/account/registerkey?key=#{x}\">#{x}</a><br>")
  end
end
end
