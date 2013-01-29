require 'nokogiri'
require 'open-uri'
require 'json'
require 'typhoeus'
require 'digest/sha1'

class BaiduGeneric
  attr_accessor :proxy, :cookie, :hydra, :log_file, :default_download_folder, 
  :default_log_folder, :cache_folder
  def initialize
      @proxy = "http://0.0.0.0:8888"
      @cookie = "BAIDUID=689F6BC2253EDBF9E55B8C1189D992AE:FG=1; BAIDU_WISE_UID=bd_1353034968_829; BDUSS=jluLVByUHRTYVM2M1NyWWIxZEhPS0ZqZklVQVd0RjFvWXNKQlN4eGlyeEwzcUZSQVFBQUFBJCQAAAAAAAAAAAoqzCs5Hi0KY29vcGVyaGVhZF9tZQAAAAAAAAAAAAAAAAAAAAAAAACAYIArMAAAALDmpXwAAAAA6p5DAAAAAAAxMC4yNi4xOUuQtFBLkLRQa; BDUT=31pa689F6BC2253EDBF9E55B8C1189D992AE13a869a359b0; H_PS_PSSID=1427_1788_1896_1764; is_new_user=new; bdshare_firstime=1359388765059; outTime=1359388901350; Hm_lvt_d0ad46e4afeacf34cd12de4c9b553aa6=1359387412; Hm_lpvt_d0ad46e4afeacf34cd12de4c9b553aa6=1359393264; tracesrc=-1%7C%7C-1; u_lo=0; u_id=; u_t=; siteStartTime=1359393264274; curPageStartTime=1359393264274; openPageNum=3"
      @hydra = Typhoeus::Hydra.new(:max_concurrency => 20, :timeout => 200)
      @default_download_folder = "songs"
      @default_log_folder = "logs"
      @log_file = "#{@default_log_folder}/download_index.txt"
      @cache_folder = "cache"

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