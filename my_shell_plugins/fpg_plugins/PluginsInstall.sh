#!/bin/bash

function aptCheck()
{
    sudo apt-get install -y $1 2>&1 | grep -q "E:*dpkg" && sduo rm -rf /var/lib/dpkg/info && mkdir -p /var/lib/dpkg/info && apt-get install -y $1
}
echo "安装将花费一定时间，请耐心等待直到安装完成^_^"
if which apt-get >/dev/null; then
    sudo apt-get update
	plugins="gcc tree vim vim-gnome ctags xclip astyle python-setuptools python-dev git "
    ## xclip:建立终端和剪切板之间的通道;
  	for x in $plugins
	do 
	    aptCheck $x
    done
elif which yum >/dev/null; then
  	sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel	
elif which brew >/dev/null;then
    ##Add HomeBrew support on  Mac OS
    echo "You are using HomeBrew tool"
    brew install vim ctags git astyle
fi

## python 代码格式化工具
sudo easy_install -ZU autopep8 

sudo ln -s /usr/bin/ctags /usr/local/bin/ctags

mv -f ~/vim ~/vim_old
mv -f ~/.vim ~/.vim_old
mv -f ~/.vimrc ~/.vimrc_old
mv -f ~/.bashrc ~/.bashrc_old

mkdir -p ~/.vim/bundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

cp -rf ./codeComplete/ ~/.vim/codeComplete/
cp -rf ./doc/ ~/.vim/doc/
cp -rf ./dict/ ~/.vim/dict/
##fc-list 查看字体列表
cp -f ./fonts/VeraMono.ttf /usr/share/fonts/VeraMono.ttf
##颜色库
cp -f ./colors/solarized.vim /usr/share/vim/vimcurrent/colors/solarized.vim
cp -f ./configFile/vimrc ~/.vimrc
cp -f ./configFile/bashrc ~/.bashrc
source ~/.bashrc

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

vim ~/.vimrc -c "BundleInstall" -c "q" -c "q"
echo "安装完成"
