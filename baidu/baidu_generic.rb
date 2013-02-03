require 'nokogiri'
require 'open-uri'
require 'json'
require 'typhoeus'
require 'digest/sha1'
require 'colorize'

class BaiduGeneric
  attr_accessor :proxy, :cookie, :hydra, :log_file, :default_download_folder, 
  :default_log_folder, :cache_folder, :temp_folder
  def initialize
      @proxy = "http://0.0.0.0:8888"
      @cookie = "BAIDUID=689F6BC2253EDBF9E55B8C1189D992AE:FG=1; BAIDU_WISE_UID=bd_1353034968_829; BDUSS=jluLVByUHRTYVM2M1NyWWIxZEhPS0ZqZklVQVd0RjFvWXNKQlN4eGlyeEwzcUZSQVFBQUFBJCQAAAAAAAAAAAoqzCs5Hi0KY29vcGVyaGVhZF9tZQAAAAAAAAAAAAAAAAAAAAAAAACAYIArMAAAALDmpXwAAAAA6p5DAAAAAAAxMC4yNi4xOUuQtFBLkLRQa; BDUT=31pa689F6BC2253EDBF9E55B8C1189D992AE13a869a359b0"
      @hydra = Typhoeus::Hydra.new(:max_concurrency => 20, :timeout => 200)
      @default_download_folder = "songs"
      @default_log_folder = "logs"
      @log_file = "#{@default_log_folder}/download_index.txt"
      @cache_folder = "cache"
      @temp_folder = "temp"

      FileUtils.mkdir_p @default_log_folder
      FileUtils.mkdir_p @cache_folder
      FileUtils.mkdir_p @default_download_folder
  end
  
  def cache_file(cache_id)
    sha = Digest::SHA1.hexdigest cache_id
    "#{@cache_folder}/#{sha}"  
  end

  def save_to_cache(doc, file_name)
    File.open(file_name, "w") { |file| file.write doc }
  end

  def read_from_cache(file_name)
    File.read(file_name)  
  end

  
end