require 'px'

if ARGV[0].nil?
  puts "Usage: $0 <filename>"
  exit 1
end

px = Px.new(ARGV[0])
