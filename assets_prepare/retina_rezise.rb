#
# used to check if there is any assets is odd in wid or height
#
# Availalbe Filter Type
# UndefinedFilter
# Bartlett
# BesselFilter
# BlackmanFilter
# Bohman
# BoxFilter
# CatromFilter
# CubicFilter
# GaussianFilter
# HammingFilter
# HanningFilter
# HermiteFilter
# KaiserFilter
# LagrangianFilter
# LanczosFilter
# MitchellFilter
# ParzenFilter
# PointFilter
# QuadraticFilter
# SincFilter
# TriangleFilter
# WelshFilter

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

class RetinaRezise
  def initialize(args)
    @folder_name = args
  end

  def resize(folder_name = @folder_name)
    Dir.glob("#{folder_name}/**/*.png").each do |image_path|
      GC.start

      image = Magick::Image::read(image_path).first
      image = image.resize(image.columns / 2, image.rows / 2, Magick::LanczosFilter)
      new_path = image_path.sub(/retina/, 'non_retina')
      path_array = new_path.split('/')
      dir_path = path_array.first(path_array.size - 1).join("/")
      FileUtils.mkdir_p dir_path
      image.write new_path do 
        self.quality=100
      end

      image.destroy!

    end
  end
end

# if ARGV[0].nil?
#   p "use default folder name: 'retina'"
#   folder_name = "retina"
# else
#   folder_name = ARGV[0]
#   p "process folder: #{folder_name}"
# end

# if ARGV[1].nil?
#   p "use default power_number as: 2"
#   power_number = 2
# else
#   power_number = ARGV[1]
#   p "use power_number as : #{power_number}"
# end

# hd_check = HdCheck.new(folder_name, 2)
# hd_check.check

resizer = RetinaRezise.new(folder_name)
resizer.resize

