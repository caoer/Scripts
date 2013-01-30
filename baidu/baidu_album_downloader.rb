require_relative "baidu_generic"
require_relative "baidu_song_downloader"

class BaiduAlbumDownloader < BaiduGeneric
  attr_accessor :url, :doc, :songs, :id, :author, :xcode, :downloaded_album_count

  def initialize(url)
    @url = url
    @id = @url.split("/")[-1]
    @songs = []
    @retry_count = 0
    @max_retry_count = 10
    @downloaded_album_count = 0

    super()
  end

  def parse
    if File.exists?(self.cache_file @url)
      puts "using cache".red.on_blue
      f = self.read_from_cache(self.cache_file(@url))
    else
      f = open(@url)
      self.save_to_cache(f.read, self.cache_file(@url))
      f = self.read_from_cache(self.cache_file(@url))
    end

    @doc = Nokogiri::HTML(f)
    song_list = @doc.css(".song-list ul li")

    if song_list.length > 0
      item = JSON.parse song_list[0]["data-songitem"]
      @author = item["songItem"]["author"]
      self.log
    end
    
    # update xcode
    song_list.each do |song|
      song_xcode = BaiduSongDownloader.new(JSON.parse(song["data-songitem"])["songItem"]["sid"])
      begin
        @xcode = song_xcode.get_xcode
        break
      rescue Exception => e
        next
      end
    end

    song_list.each do |song|
      item = JSON.parse song["data-songitem"]
      sid = item["songItem"]["sid"]
      song_downloader = BaiduSongDownloader.new sid
      song_downloader.xcode = @xcode
      song_downloader.album_delegate = self

      @songs << song_downloader
      begin
        song_downloader.parse
        song_downloader.log
      rescue Exception => e
        puts "Unabled to download song #{sid}".red
        # plus downloaded_album_count to avoid download this song
        @downloaded_album_count += 1
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
        puts "Unabled to download song #{sid}".red
      end
    end

    @hydra.run
  end

  def download_songs
    while @downloaded_album_count < songs.length && @retry_count < @max_retry_count
      @retry_count += 1
      puts "trying to download in #{@retry_count} time".green
      @songs.each do |song|
        song.download_system @author
      end
    end

    if @retry_count == @max_retry_count
      puts "Reach Max Rety Count".red.on_yellow
    end

  end

  def log
    File.open(self.log_file, "a") { |file| file.write "------#{self.author}------\n" }
  end
end

# album = BaiduAlbumDownloader.new "http://music.baidu.com/album/13058750"

# album.hydra
# album.parse
# album.download_songs

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
else
  album = BaiduAlbumDownloader.new ARGV[0]
  album.parse
  album.download_songs
end

# album = BaiduAlbumDownloader.new "http://music.baidu.com/album/689097"
# album = BaiduAlbumDownloader.new "http://music.baidu.com/artist/1077"
# album = BaiduAlbumDownloader.new "http://music.baidu.com/artist/1117"


