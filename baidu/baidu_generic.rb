require 'nokogiri'
require 'open-uri'
require 'json'
require 'typhoeus'

class BaiduGeneric
  attr_accessor :proxy, :cookie, :hydra, :log_file
  def initialize
      @proxy = "http://0.0.0.0:8888"
      @cookie = "BAIDUID=689F6BC2253EDBF9E55B8C1189D992AE:FG=1; BAIDU_WISE_UID=bd_1353034968_829; BDUSS=jluLVByUHRTYVM2M1NyWWIxZEhPS0ZqZklVQVd0RjFvWXNKQlN4eGlyeEwzcUZSQVFBQUFBJCQAAAAAAAAAAAoqzCs5Hi0KY29vcGVyaGVhZF9tZQAAAAAAAAAAAAAAAAAAAAAAAACAYIArMAAAALDmpXwAAAAA6p5DAAAAAAAxMC4yNi4xOUuQtFBLkLRQa; BDUT=31pa689F6BC2253EDBF9E55B8C1189D992AE13a869a359b0; H_PS_PSSID=1427_1788_1896_1764; is_new_user=new; bdshare_firstime=1359388765059; outTime=1359388901350; Hm_lvt_d0ad46e4afeacf34cd12de4c9b553aa6=1359387412; Hm_lpvt_d0ad46e4afeacf34cd12de4c9b553aa6=1359393264; tracesrc=-1%7C%7C-1; u_lo=0; u_id=; u_t=; siteStartTime=1359393264274; curPageStartTime=1359393264274; openPageNum=3"
      @hydra = Typhoeus::Hydra.new(:max_concurrency => 20, :timeout => 200)
      @log_file = "download_index.txt"
  end
  
  
end