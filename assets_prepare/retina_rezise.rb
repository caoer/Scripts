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
require 'colorize'

class RetinaRezise
  def initialize(args)

  end

  def self.resize(source_folder, target_folder, opt = {})
    opt = {
      :overwrite => true,
      :suffix => :none,
    }.merge(opt)
    puts opt
    Dir.glob("#{source_folder}/**/*.png").each do |image_path|

      new_path = image_path.sub(source_folder, target_folder)
      if opt[:suffix] != :none
        last_elements = new_path.split("/")[-1].split(".")
        puts "#{new_path} name error! can't contain .".red if last_elements.size != 2
        new_file_name = "#{last_elements[0]}#{opt[:suffix]}.#{last_elements[1]}"
        puts "#{new_file_name}".red
      end

      path_array = new_path.split('/')
      dir_path = path_array.first(path_array.size - 1).join("/")
      FileUtils.mkdir_p dir_path

      if File.exists?(new_path)
        if opt[:overwrite]
          puts "overwrote #{new_path}".red
          self.resize_image(image_path, new_path) 
        else
          puts "#{new_path} exists, skip".yellow
        end
      else
        puts "resized #{new_path}".green
        self.resize_image(image_path, new_path) 
      end
    end
  end

  private

  def self.resize_image(image_path, new_path)
    GC.start

    image = Magick::Image::read(image_path).first
    image = image.resize(image.columns / 2, image.rows / 2, Magick::LanczosFilter)

    puts new_path
    image.write new_path do 
      self.quality=100
    end

    image.destroy!
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

# RetinaRezise.resize("assets/ipad-hd", "assets/ipad", :overwrite => false, :suffix => "-ipad")
RetinaRezise.resize("assets/ipad-hd", "assets/ipad", :overwrite => false)