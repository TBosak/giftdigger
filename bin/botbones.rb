def Check(response, term)
  array=[]
  response.each_line { |line| pulled = /#{term}/.match(line); array<<pulled}
  @finarray = []
  array.each do |x|
      if x == nil
      next
      else
      y = x.to_s
      @finarray<<y.gsub(/\"/,"")
      end
  end
  return @finarray
end
