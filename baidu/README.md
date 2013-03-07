## Baidu MP3 Downloader

A simple script to download high quality songs from music.baidu.com. Here are some prerequisites

* You need to login to music.baidu.com, in order to grab your cookie information. Please copy and paste all your cookies into baidu_generic.rb. Or simply ignore this, use mine.
* `download_index.txt` is the log file. The script can detect songs that are downloaded before in case of duplication.
* Downloaded songs are placed in `/songs` folder

### Setup
#### 1. `bundle install` to get proper environment
#### 2. If you are not in mainland China, you need a proxy.
1. Install Node.js if you don't have them at hand

      `brew install nodejs`

2. Start modified Unblock-Youku proxy server, in `Script/baidu` folder

      `node server.js`

#### 3. Start a new terminal tab, and download.
      
      ruby baidu_album_downloader.rb http://music.baidu.com/artist/1117 # For an artist
      ruby baidu_album_downloader.rb http://music.baidu.com/album/689097 # For an album
      


### Requirements 

1. Ruby: >= 1.9.3
2. Node.js
