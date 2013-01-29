require_relative "baidu_generic"
require 'fileutils'

class BaiduSongDownloader < BaiduGeneric
  attr_accessor :id, :link, :filePath, :name

  def initialize(id)
    @id = id  
    @url = "http://music.baidu.com/song/#{id}/download"
    super()
  end
  
  def parse
    self.onResponse(open(@url, :proxy => self.proxy, "Cookie" => @cookie))
  end

  def onResponse(response)
      doc =  Nokogiri::HTML(response)
      high_res = doc.css(".high-rate")[0]
      json = JSON.parse(high_res["data-data"])
      @link = "http" + json["link"].split("http")[1]

      @name = doc.css(".song-link-hook")[0]["title"]
      puts "Got mp3 link: " + @link
  end

  def request
    request = Typhoeus::Request.new(@url, :proxy => self.proxy, :headers => {'Cookie' => @cookie})
    
    request.on_complete do |response|   
      self.onResponse(response.body)
    end

    request
  end

  def prepare_download(folder)
    FileUtils.mkdir_p folder
    @filePath = "#{folder}/#{@name}.mp3"
    puts "downloading song #{@name}"

    can_download = true

    if File.exists?(@filePath)
      file = File.open(@filePath, "r")
      if file.size > 0
        can_download = false
      end 
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
      p "wget #{self.link} -O #{self.filePath}"
      `wget #{self.link} -O #{self.filePath}`
    else
      p "file #{self.filePath} already downloaded"
    end
  end

  def log
    File.open(self.log_file, "a") { |file| file.write "#{self.link}\n" }
  end

end

# b = BaiduSongDownloader.new(265543)

# b.parse
# b.log
# b.download_system("2377")
