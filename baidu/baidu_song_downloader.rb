require_relative "baidu_generic"
require 'fileutils'

class BaiduSongDownloader < BaiduGeneric
  attr_accessor :id, :link, :filePath, :name, :xcode, :album_delegate

  def initialize(id)
    @id = id  
    @url = "http://music.baidu.com/song/#{id}/download"
    super()
  end
  
  def get_xcode
    #update attribe with network data
    onResponse(open(@url, :proxy => self.proxy, "Cookie" => @cookie))
    xcode = @link.split("xcode=")[-1]
    puts "updated xcode:#{xcode}".red.on_blue
    xcode
  end

  def update_xocde_with_link
    @link = @link.split("xcode=")[0] + "xcode=#{@xcode}"
  end

  def parse
    file_name = self.cache_file(@url)

    if File.exists?(file_name)
      self.onResponse(self.read_from_cache(file_name))
    else
      file = open(@url, :proxy => self.proxy, "Cookie" => @cookie)
      self.save_to_cache(file.read, file_name)
      self.onResponse(self.read_from_cache(file_name))
    end
  end

  def onResponse(response)
      doc =  Nokogiri::HTML(response)
      high_res = doc.css(".high-rate")[0]
      json = JSON.parse(high_res["data-data"])
      @link = "http" + json["link"].split("http")[1]

      if @xcode != nil
        self.update_xocde_with_link
      end

      @name = doc.css(".song-link-hook")[0]["title"]
      puts "Got mp3 link: #{@link}".green
  end

  def request
    request = Typhoeus::Request.new(@url, :proxy => self.proxy, :headers => {'Cookie' => @cookie})
    
    request.on_complete do |response|   
      self.onResponse(response.body)
    end

    request
  end

  def prepare_download(folder)
    FileUtils.mkdir_p "#{@default_download_folder}/#{folder}"
    @filePath = "#{@default_download_folder}/#{folder}/#{@name}.mp3"
    puts "downloading song #{@name}".blue

    can_download = true

    if File.exists?(@filePath)
      file = File.open(@filePath, "r")
      if file.size > 0
        can_download = false
      end 
      file.close
    end

    can_download
  end

  def download_uri(folder)
    self.prepare_download folder

    File.open(self.filePath, "w") do |output|
      open(self.link) do | input |
        output << input.read
      end
    end
  end

  def download_system(folder)
    if self.prepare_download(folder)
      puts "downloading #{self.link} to #{self.filePath}".yellow
      `wget #{self.link} -O "#{self.filePath}"`
      # system "aria2c -x 8 #{self.link} -o #{self.filePath}"
    else
      puts "file #{self.filePath} already downloaded, skip it".red
    end

    if self.finish_download?
      @album_delegate.downloaded_album_count += 1
    end
  end

  def finish_download?
    if File.exists?(self.filePath)
      file = File.open(self.filePath, "r")
      if file.size < 100
        false
      else
        true
      end
    else
      false    
    end  
  end

  def log
    File.open(self.log_file, "a") { |file| file.write "#{self.link}\n" }
  end

end

# b = BaiduSongDownloader.new(265543)
# b.parse

