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

class RetinaRezise
  def initialize(args)

  end

  def self.resize(source_folder, target_folder)
    Dir.glob("#{source_folder}/**/*.png").each do |image_path|
      GC.start

      image = Magick::Image::read(image_path).first
      image = image.resize(image.columns / 2, image.rows / 2, Magick::LanczosFilter)
      new_path = image_path.sub(/"#{source_folder}"/, 'target_folder')
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

