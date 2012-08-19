#
# used to check if there is any assets is odd in wid or height
#

require "rubygems" # you use rubygems
require "image_size"
require "open-uri"

if ARGV[0].nil?
    p "Put folder name as argument"
else
    Dir.glob("#{ARGV[0]}/**/*.png") { |file|
        open(file,"rb") do |fh|
            size = ImageSize.new(fh.read).get_size
            if size[0] % 2 != 0 || size[1] % 2 != 0
                p "#{size}-- File: #{file}"
            end
        end
    }
end

