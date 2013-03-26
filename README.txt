cd /data/current/repertory
apt-get install git
1、下载相关源代码
git clone git://github.com/bigbluebutton/flexlib.git
git clone git://github.com/bigbluebutton/bigbluebutton-api-js.git
git clone git://github.com/bigbluebutton/FreeSWITCH.git
git clone git://github.com/bigbluebutton/red5.git
git clone git://github.com/bigbluebutton/as3corelib.git
git clone git://github.com/bigbluebutton/flexlib-bbb.git
git clone git://github.com/bigbluebutton/bbb-red5-test.git
git clone git://github.com/bigbluebutton/bigbluebutton.git

cd ../lib
#手动编译需要的工具包
apt-get install make build-essential libtool libtiff4-dev zlib1g-dev autoconf libssl-dev libyaml-dev bison checkinstall gcc libreadline5 libyaml-0-2 git-core yasm texi2html libopencore-amrnb-dev libopencore-amrwb-dev libsdl1.2-dev libtheora-dev libvorbis-dev libx11-dev libxfixes-dev libxvidcore-dev --yes
#ruby安装
wget http://ftp.ruby-lang.org/pub/ruby/1.9/ruby-1.9.2-p290.tar.gz
tar xvzf ruby-1.9.2-p290.tar.gz
cd ruby-1.9.2-p290
./configure --prefix=/usr\
            --program-suffix=1.9.2\
            --with-ruby-version=1.9.2\
            --disable-install-doc
make
checkinstall -D -y\
                  --fstrans=no\
                  --nodoc\
                  --pkgname='ruby1.9.2'\
                  --pkgversion='1.9.2-p290'\
                  --provides='ruby'\
                  --requires='libc6,libffi6,libgdbm3,libncurses5,libreadline5,openssl,libyaml-0-2,zlib1g'\
                  --maintainer=brendan.ribera@gmail.com
update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.2 500 \
                         --slave /usr/bin/ri ri /usr/bin/ri1.9.2 \
                         --slave /usr/bin/irb irb /usr/bin/irb1.9.2 \
                         --slave /usr/bin/erb erb /usr/bin/erb1.9.2 \
                         --slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.2
update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.2 500
#安装ffmpeg - process video files for playback
git clone http://git.chromium.org/webm/libvpx.git
  cd libvpx
  sudo ./configure
  sudo make
  sudo make install
wget http://ffmpeg.org/releases/ffmpeg-0.11.2.tar.gz
tar -xvzf ffmpeg-0.11.2.tar.gz
cd ffmpeg-0.11.2
./configure  --enable-version3 --enable-postproc  --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libtheora --enable-libvorbis  --enable-libvpx
make
checkinstall --pkgname=ffmpeg --pkgversion="5:$(./version.sh)" --backup=no --deldoc=yes --default

2、安装mysql
	2.1、安装
	apt-get install mysql-server
	2.2、配置
	mysql -u root -p
	create database bigbluebutton_dev;
	grant all on bigbluebutton_dev.* to 'bbb'@'localhost' identified by 'secret';
	flush privileges;
	quit

3、安装tomcat6
	3.1、安装
	apt-get install tomcat6
	3.2、配置（关闭安全设置）
	sed -i "s/#TOMCAT6_SECURITY=yes/TOMCAT6_SECURITY=no/" /etc/default/tomcat6

4、安装swftools（如果ubuntu版本不是10.04那么就要手动安装了）
	apt-get install swftools
	or
	#用于生成jpeg2swf
	wget http://www.ijg.org/files/jpegsrc.v9.tar.gz
	tar -xvf 
	cd jpeg-9
	./configure && make && make install
	#用于生成pdf2swf
	view http://www.kuaipan.cn/file/id_129778733270695937.htm download tar
	mkdir /usr/local/include/freetype2/freetype/internal
	tar -xvf freetype-2.4.6.tar.gz
	cd freetype-2.4.6
	./configure && make && make install
	通过apt-get install libgif-dev来安装ungif，使得可以生成gif2swf
	#开始安装主角，有个bug，make完之后修改swfs/Makefile，找到rm命令的所有行删除-o以及之后的内容。
	wget http://www.swftools.org/swftools-0.9.2.tar.gz
	tar -xvf swftools-0.9.2.tar.gz
	cd swftools-0.9.2
	./configure>/dev/null&&make>/dev/null&& make install>/dev/null

5、安装imagemagick
apt-get install imagemagick

6、安装nginx
	6.1、安装
	apt-get install nginx
	6.2、配置
	cat /tmp/bbb/nginx-bigbluebutton.conf  | sed "s/192.168.0.35/< YOUR-IP >/" > /etc/nginx/sites-available/bigbluebutton
	ln -s /etc/nginx/sites-available/bigbluebutton /etc/nginx/sites-enabled/bigbluebutton
	###############################################
	###nginx-bigbluebutton.conf对应于bigbluebutton源代码下的bigbluebutton-client
	###############################################

7、安装activemq
	7.1、安装依赖
	apt-get install jsvc
	7.2、activemq
	wget http://apache.sunsite.ualberta.ca//activemq/apache-activemq/5.4.3/apache-activemq-5.4.3-bin.tar.gz
	tar zxvf apache-activemq-5.4.3-bin.tar.gz
	mv apache-activemq-5.4.3 /usr/share/activemq
	chown -R root:root /usr/share/activemq
8、安装red5
	8.1、安装
	##wget http://bigbluebutton.org/downloads/0.70/red5-0.9.1.tar.gz
	##tar xvf red5-0.9.1.tar.gz
	###############
	##使用git clone下来的red5
	###############
	mv red5-0.9.1 /usr/share/red5
	8.2、建立red5用户
	adduser --system --home /usr/share/red5 --no-create-home --group --disabled-password --shell /bin/false red5
	8.3、权限设置
	chown -R root:root /usr/share/red5
	chown -R red5:adm /usr/share/red5/log
	chmod 755 /usr/share/red5/log
	chgrp red5 /usr/share/red5/webapps
	chmod 775 /usr/share/red5/webapps
9、下载bbb编译好的包
wget http://bigbluebutton.org/downloads/0.71a/init-scripts.tar.gz
wget http://bigbluebutton.org/downloads/0.71a/freeswitch-config.tar.gz

wget http://bigbluebutton.org/downloads/0.71a/red5-bigbluebutton.tar.gz
wget http://bigbluebutton.org/downloads/0.71a/red5-deskshare.tar.gz
wget http://bigbluebutton.org/downloads/0.71a/red5-sip.tar.gz
wget http://bigbluebutton.org/downloads/0.71a/red5-video.tar.gz

wget http://bigbluebutton.org/downloads/0.71a/www-bigbluebutton-default.tar.gz
wget http://bigbluebutton.org/downloads/0.71a/www-bigbluebutton.tar.gz

wget http://bigbluebutton.org/downloads/0.71a/bigbluebutton.war
wget http://bigbluebutton.org/downloads/0.71a/nginx-bigbluebutton.conf

wget http://bigbluebutton.org/downloads/0.71a/bbb-conf

10、设定开机启动脚本（Auto-start activeMQ, bbb-openoffice-headless, and red5）
cd /etc/init.d
tar xzvf /tmp/bbb/init-scripts.tar.gz
chmod +x /etc/init.d/activemq
chmod +x /etc/init.d/red5
chmod +x /etc/init.d/bbb-openoffice-headless
update-rc.d activemq defaults
update-rc.d red5 defaults
update-rc.d bbb-openoffice-headless defaults

11、安装freeswitch
	11.1、安装
	##apt-get install python-software-properties
	##add-apt-repository ppa:freeswitch-drivers/freeswitch-nightly-drivers 
	##apt-get update
	##apt-get install freeswitch freeswitch-lang-en
	###############
	####使用git clone下来的版本，通过编译安装
	###############
	./bootstrap.sh
	./configure
	make
	make install
	11.2、配置
	cd /opt/freeswitch/
	tar xzvf /tmp/bbb/freeswitch-config.tar.gz
	chown -R freeswitch:daemon conf
	chmod -R 755 conf
	sed -i 's/FREESWITCH_ENABLED=\"false\"/FREESWITCH_ENABLED=\"true\"/g' /etc/default/freeswitch
12、安装openoffice
	12.1、安装
	apt-get install openoffice.org
	12.2、配置
	service bbb-openoffice-headless start
13、安装bbb-web
	13.1、安装
	cp bigbluebutton.war /var/lib/tomcat6/webapps/bigbluebutton.war
	13.2、配置
	vi /var/lib/tomcat6/webapps/bigbluebutton/WEB-INF/classes/bigbluebutton.properties
	swfToolsDir to the directory where pdf2swf is located
    imageMagickDir to the directory where convert is located
    ghostScriptExec to point to the gs executable
    change bigbluebutton.web.serverURL=http://<YOUR IP>
    set beans.dynamicConferenceService.securitySalt to be equal to the guid we just generated (i.e. beans.dynamicConferenceService.securitySalt=< YOUR-GUID >) 

14、确认PDF2SWF, CONVERT and GS applications是否存在

15、建立脚本文件
Create /etc/bigbluebutton/nopdfmark.ps with the following content:
%!
/pdfmark {cleartomark} bind def

16、建立上传目录
mkdir /var/bigbluebutton
chown -R tomcat6:adm /var/bigbluebutton
chmod -R 777 /var/bigbluebutton

17、重启tomcat6
service tomcat6 restart

18、安装bbb-apps
cd /usr/share/red5/webapps
tar xzvf /tmp/bbb/red5-bigbluebutton.tar.gz

19、Install bbb-deskshare-app
cd /usr/share/red5/webapps
tar xzvf /tmp/bbb/red5-deskshare.tar.gz

20、Install bbb-video-app
cd /usr/share/red5/webapps
tar xzvf /tmp/bbb/red5-video.tar.gz

21、Install bbb-voice-app
	21.1、安装
	cd /usr/share/red5/webapps
	tar xzvf /tmp/bbb/red5-sip.tar.gz
	21.2、配置
	vi /usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties
	Edit the line that says sip.server.host=192.168.0.35 and replace the IP with < Your-IP >. 
22、Install default web pages
cd /var/www
tar xzvf /tmp/bbb/www-bigbluebutton-default.tar.gz

23、Install bbb-client
	23.1、安装
	cd /var/www
	tar xzvf /tmp/bbb/www-bigbluebutton.tar.gz
	23.2、配置
	Now we need to create bbb_api_conf.jsp, which will hold our GUID and the !BigBlueButtonURL. Be sure to replace < YOUR-GUID > and < YOUR-IP > with the GUID we generated earlier and your IP, respectively.
	echo "<%!
	// This is the security salt that must match the value set in the BigBlueButton server
	String salt = \"<YOUR-GUID>\";

	// This is the URL for the BigBlueButton server
	String BigBlueButtonURL = \"http://<YOUR-IP>/bigbluebutton/\";
	%>" > /var/lib/tomcat6/webapps/bigbluebutton/demo/bbb_api_conf.jsp
	23.3、配置2
	vi /var/www/bigbluebutton/client/conf/config.xml
    Change the uri to your IP address 
24、安装bbb-conf
cp /tmp/bbb/bbb-conf /usr/local/bin
sudo chmod a+x /usr/local/bin/bbb-conf 

25、# create directory for log files
mkdir /var/log/bigbluebutton

26、# create an empty log file
touch /var/log/bigbluebutton/bbb-web.log
chown tomcat6:tomcat6 /var/log/bigbluebutton/bbb-web.log

27、清理日志、启动服务
sudo bbb-conf --clean
sudo bbb-conf --check

