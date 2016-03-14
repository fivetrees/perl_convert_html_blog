#!/usr/bin/perl

#author: zhengsenlin
#date: 2016-03-13
#desc: 女儿的博客

use 5.010;
use strict;
use warnings;
use autodie;

#确定目录所在位置
my $basedir = "/var/www/html/20140523.com";
my $pictures_dir = "$basedir/Pictures";
my $bin_dir = "$basedir/bin";
my $html_dir = "$basedir/html";

#切换到图片目录，统计出多少个目录
chdir $pictures_dir;
my @dirs = <*>;
say for @dirs;


open my $index_html, '>', "$html_dir/index.html";
#将html头文件写到index.html
say $index_html <<HTMLCONTENT;
<!DOCTYPE html>
<html>
<head>
	<title>女儿的博客</title>
	<meta http-equiv="content-type" content="text/html"; charset="utf8" />
</head>
<body>
HTMLCONTENT


for my $dir (@dirs) {
	#创建各个图片目录的各自html文件
	open my $single_html, '>', "$html_dir/$dir.html";
	
	#切换到各个图片目录
	chdir "$pictures_dir/$dir";

	#将内容写到单一的html文件
	say $single_html <<HTMLCONTENT;
<!DOCTYPE html>
<html>
<head>
	<title>$dir</title>
	<meta http-equiv="content-type" content="text/html"; charset="utf8" />
</head>
<body>
HTMLCONTENT

	#判断是否存在readme.txt 存在的话读取Readme.txt的内容到单一的html文件
	if( -e "$pictures_dir/$dir/Readme.txt") {
		open my $readme, '<', "$pictures_dir/$dir/Readme.txt";
		while(<$readme>) {
			say $single_html "$_";
		}
		close $readme;
	}

	#判断图片是否存在，存在的话进行写入图片html
	my @images = <*.jpg *.png *.jepg *.gif>;
	if(@images) {
		for my $image (@images) {
	say $single_html <<HTMLCONTENT;
<br>
<br>
<br>
<br>
<br>
<img src="http://20140523.com/Pictures/$dir/$image" style="max-width:100%;" />
HTMLCONTENT

		}
	}

	#判断是否有视频文件，有的话将视频文件信息写入到html里面
	my @vides = <*.mp4 *.avi>;
	if(@vides) {
		for my $video (@vides) {
	say $single_html <<HTMLCONTENT;
<br>
<br>
<br>
<br>
<br>
<video src="http://20140523.com/Pictures/$dir/$video" controls="controls"></video>
HTMLCONTENT
		}
	}

	#判断是否有MP3文件，有的话将MP3文件信息写入到html里面
	my @mp3s = <*.mp3>;
	if(@mp3s) {
		for my $mp3 (@mp3s) {
	say $single_html <<HTMLCONTENT;
<br>
<br>
<br>
<br>
<br>
<embed src="http://20140523.com/Pictures/$dir/$mp3" />
HTMLCONTENT
		}
	}

	#写入结尾html
	say $single_html <<HTMLCONTENT;
</body>
</html>
HTMLCONTENT

	close $single_html;



	#将各个目录的目录名写到index.html
	say $index_html <<HTMLCONTENT;
<br>
<a href="http://20140523.com/html/$dir.html">$dir</a>
<br>
HTMLCONTENT

	#say $index_html "$dir.html";
}

say $index_html <<HTMLCONTENT;
</body>
</html>
HTMLCONTENT
close $index_html;


