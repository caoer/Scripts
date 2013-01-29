require_relative "baidu_generic"
require_relative "baidu_song_downloader"

class BaiduAlbumDownloader < BaiduGeneric
  attr_accessor :url, :doc, :songs, :id, :author

  def initialize(url)
    @url = url
    @id = @url.split("/")[-1]
    @songs = []
    super()
  end

  def parse
    f = open(@url)
    @doc = Nokogiri::HTML(f)
    song_list = @doc.css(".song-list ul li")

    if song_list.length > 0
      item = JSON.parse song_list[0]["data-songitem"]
      @author = item["songItem"]["author"]
      self.log
    end

    song_list.each do |song|
      item = JSON.parse song["data-songitem"]
      sid = item["songItem"]["sid"]
      song_downloader = BaiduSongDownloader.new sid
      @songs << song_downloader
      begin
        song_downloader.parse
        song_downloader.log
      rescue Exception => e
        puts "Unabled to download song #{sid}"
      end
    end
  end

  def hydra
    f = open(@url)
    @doc = Nokogiri::HTML(f)
    song_list = @doc.css(".song-list ul li")
    song_list.each do |song|
      item = JSON.parse song["data-songitem"]
      sid = item["songItem"]["sid"]
      song_downloader = BaiduSongDownloader.new sid
      @songs << song_downloader
      begin
        @hydra.queue(song_downloader.request)
      rescue Exception => e
        puts "Unabled to download song #{sid}"
      end
    end

    @hydra.run
  end

  def download_songs
    @songs.each do |song|
      song.download_system @author
    end
  end

  def log
    File.open(self.log_file, "a") { |file| file.write "------#{self.author}------\n" }
  end

end


# album = BaiduAlbumDownloader.new "http://music.baidu.com/album/689097"
# album = BaiduAlbumDownloader.new "http://music.baidu.com/artist/1077"
album = BaiduAlbumDownloader.new "http://music.baidu.com/artist/1117"
# album = BaiduAlbumDownloader.new "http://music.baidu.com/album/13058750"

# album.hydra
album.parse
album.download_songs

if ARGV[0].nil?
  puts "You need to login to baidu to set cookie in baidu_generic.rb"
  puts "If you are not in mainland china, you need to run unblock-youku"
  puts "install nodejs first, then run 'node server.js'"
  puts "log file is in download_index.txt, this script can detect songs alreday downloaded so it won't download again"
  puts "if wget failed, its probably because session expired, run this script again will solve the problem"
  puts "-----------------------------------------"
  puts "example: ruby baidu_album_downloader.rb http://music.baidu.com/artist/1117 \n"
  puts "example: ruby baidu_album_downloader.rb http://music.baidu.com/album/689097 \n"
  puts "-----------------------------------------"
end

