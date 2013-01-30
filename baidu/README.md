# Baidu 320kbps MP3 Downloader

* You need to login to baidu to set cookie in baidu_generic.rb
* If you are not in mainland china, you need to run unblock-youku
  * install nodejs first, then run 'node server.js'
* Log file is in download_index.txt, this script can detect songs alreday downloaded so it won't download again
* Songs are downloaded into songs folder

# Setup
## 1. Install Required Gems.
      `bundle install`
## 2. Start Unblock-Youku First
*If you are not in mainland china, you need to run unblock-youku*

1. Install Nodejs

      `brew install nodejs`

2. Start modified Unblock-Youku proxy server, in baidu folder

      `node server.js`

Then you are good to downloading baidu mp3s

# Download Mp3 Example: 

      ruby baidu_album_downloader.rb http://music.baidu.com/artist/1117 
      ruby baidu_album_downloader.rb http://music.baidu.com/album/689097 



# TODO: 

* sometimes downloading is being intterupt. need to add ability to recover from it. Like add a temperaty folder. After downloaded, it copy file to dest location