require "rubygems" # you use rubygems
require "image_size"
require "open-uri"
require 'rmagick'
require 'fileutils'

class HdCheck
  def initialize(folder_name, power_number)
    @folder_name = folder_name
    @power_number = power_number
  end
  
  def check
    self.check_folder(@folder_name, @power_number)  
  end

  def check_folder(folder_name, power_number)
    puts "--out put path image width or height is not power of #{power_number}--"
    Dir.glob("#{folder_name}/**/*.png") { |file|
      open(file,"rb") do |fh|
        size = ImageSize.new(fh.read).get_size
        if size[0] % power_number != 0 || size[1] % power_number != 0
          printf "%-20s %s\n", size, file
        end
      end
    }
  end
end
