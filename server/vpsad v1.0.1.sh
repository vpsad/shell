#!/bin/bash
#全局变量
panel_path=/www/server/panel
#清理垃圾
cleaning_garbage(){
    rm -f /www/server/panel/*.pyc
    rm -f /www/server/panel/class/*.pyc
    python /www/server/panel/tools.py clear
    cat /dev/null > /var/log/boot.log
    cat /dev/null > /var/log/btmp
    cat /dev/null > /var/log/cron
    cat /dev/null > /var/log/dmesg
    cat /dev/null > /var/log/firewalld
    cat /dev/null > /var/log/grubby
    cat /dev/null > /var/log/lastlog
    cat /dev/null > /var/log/mail.info
    cat /dev/null > /var/log/maillog
    cat /dev/null > /var/log/messages
    cat /dev/null > /var/log/secure
    cat /dev/null > /var/log/spooler
    cat /dev/null > /var/log/syslog
    cat /dev/null > /var/log/tallylog
    cat /dev/null > /var/log/wpa_supplicant.log
    cat /dev/null > /var/log/wtmp
    cat /dev/null > /var/log/yum.log
    history -c
    back_home
}
#去除强制登陆
mandatory_landing(){
    rm -f /www/server/panel/data/bind.pl
    back_home
}
#修复环境
repair_environment(){
    yum -y install pcre pcre-devel
    yum -y install openssl openssl-devel
    yum -y install gcc-c++ autoconf automake
    yum install -y zlib-devel
    yum -y install libxml2 libxml2-dev
    yum -y install libxslt-devel
    yum -y install gd-devel
    yum -y install perl-devel perl-ExtUtils-Embed
    yum -y install GeoIP GeoIP-devel GeoIP-data
    yum install -y libxml2-devel
    yum install -y bzip2 bzip2-devel
    yum install -y libpng libpng-devel
    yum install -y libjpeg-deve
    yum install -y freetype freetype-devel
    yum install -y libmcrypt-devel
    yum install libcurl-devel libffi-devel zlib-devel bzip2-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel -y
    back_home
}
#清理残留
cleaning_residue(){
    sed -i 's/[0-9\.]\+[ ]\+www.bt.cn//g' /etc/hosts
    chattr -i /www/server/panel/class/panelAuth.py
    chattr -i /www/server/panel/class/panelPlugin.py
    chattr -i /etc/init.d/bt
    rm -f /etc/init.d/bt
    wget -O /etc/init.d/bt http://download.bt.cn/install/src/bt6.init -T 10
    chmod +x /etc/init.d/bt
    chattr -i /www/server/panel/data/plugin.json
    rm -f /www/server/panel/data/plugin.json
    wget -O /www/server/panel/data/plugin.json http://bt.cn/api/panel/get_soft_list_test -T 10
    chattr -i /www/server/panel/install/check.sh
    rm -f /www/server/panel/install/check.sh
    wget -O /www/server/panel/install/check.sh http://download.bt.cn/install/check.sh -T 10
    chattr -i /www/server/panel/install/public.sh
    rm -f /www/server/panel/install/public.sh
    wget -O /www/server/panel/install/public.sh http://download.bt.cn/install/public.sh -T 10
    rm -rf /www/server/panel/plugin/shoki_cdn
    rm -f /www/server/panel/data/home_host.pl
    rm -rf /www/server/panel/adminer
    rm -rf /www/server/adminer
    rm -rf /www/server/phpmyadmin/pma
    rm -f /www/server/panel/*.pyc
    rm -f /www/server/panel/class/*.pyc
    rm -f /dev/shm/session.db
    curl http://download.bt.cn/install/update_panel.sh|bash
    back_home
}
#停止服务
stop_btpanel(){
    /etc/init.d/bt stop
    /etc/init.d/nginx stop
    /etc/init.d/httpd stop
    /etc/init.d/mysqld stop
    /etc/init.d/pure-ftpd stop
    /etc/init.d/php-fpm-52 stop
    /etc/init.d/php-fpm-53 stop
    /etc/init.d/php-fpm-54 stop
    /etc/init.d/php-fpm-55 stop
    /etc/init.d/php-fpm-56 stop
    /etc/init.d/php-fpm-70 stop
    /etc/init.d/php-fpm-71 stop
    /etc/init.d/php-fpm-72 stop
    /etc/init.d/php-fpm-73 stop
    /etc/init.d/php-fpm-74 stop
    /etc/init.d/redis stop
    /etc/init.d/memcached stop
}
#卸载面板
uninstall_btpanel(){
    stop_btpanel
    chkconfig --del bt
    rm -f /etc/init.d/bt
    rm -rf /www
    rm -rf /tmp/*.sh
    rm -rf /tmp/*.sock
}
#酷锐面板
cp /www/server/panel/config/config.json /root/config.json
idc='8ee72501'
IDC_CODE=$idc
python_bin=/www/server/panel/pyenv/bin/python
Setup_Count(){
	curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/SetupCount?type=Linux\&o=$idc > /dev/null 2>&1
	if [ "$idc" != "" ];then
		echo $idc > /www/server/panel/data/o.pl
		cd /www/server/panel
		$python_bin tools.py o
		python tools.py o
	fi
	echo /www > /var/bt_setupPath.conf
}
Setup_Count ${IDC_CODE}
cp /root/config.json /www/server/panel/config/config.json 
rm -f /root/config.json
#宝塔磁盘挂载
mount_disk(){
	echo -e "注意：本工具会将数据盘挂载到www目录。5秒后跳转到挂载脚本。"
    sleep 5s
	wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
	rm -rf /auto_disk.sh
    rm -rf auto_disk.sh
    back_home
}
#封装工具
package_btpanel(){
    clear
    python /www/server/panel/tools.py package
    back_home
}
#降级版本
degrade_btpanel(){
    if [ ! -d /www/server/panel/BTPanel ];then
    	echo "============================================="
    	echo "错误, 5.x不可以使用此命令升级!"
    	echo "5.9平滑升级到6.0的命令：curl http://download.bt.cn/install/update_to_6.sh|bash"
    	exit 0;
    fi
    setup_path=/www
    download=http://download.bt.cn/
    wget -T 5 -O panel.zip $download/install/update/LinuxPanel-${version}.zip
    if [ $dsize -lt 10240 ];then
    	echo "获取更新包失败，请稍后更新或联系作者"
	    exit;
    fi
    unzip -o panel.zip -d $setup_path/server/ > /dev/null
    rm -f panel.zip
    rm -f /www/server/panel/*.pyc
    rm -f /www/server/panel/class/*.pyc
    sleep 1 && service bt restart > /dev/null 2>&1 &
    echo "====================================="
    echo "你已降级为${version}版";
    back_home
}

#开启完全离线服务
open_offline(){
    rm -f $panel_path/data/home_host.pl
    echo 'True' >$panel_path/data/not_network.pl
    echo '[ "127.0.0.1" ]' >$panel_path/config/hosts.json
    sed -i 's/[0-9\.]\+[ ]\+www.bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+download.bt.cn//g' /etc/hosts
    echo '192.168.88.127 www.bt.cn' >>/etc/hosts
    echo '192.168.88.127 bt.cn' >>/etc/hosts
    echo '192.168.88.127 download.bt.cn' >>/etc/hosts
    back_home
}
#关闭完全离线服务
close_offline(){
    rm -f $panel_path/data/home_host.pl
    rm -f $panel_path/data/not_network.pl
    wget -O $panel_path/config/hosts.json https://down.gacjie.cn/BTPanel/Api/hosts.json
    sed -i 's/[0-9\.]\+[ ]\+www.bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+download.bt.cn//g' /etc/hosts
    back_home
}
#格式化数据盘
format_disk(){
    stop_btpanel
    umount /dev/vdb
    mkfs.ext4 /dev/vdb
}

#返回首页
back_home(){
	read -p "请输入0返回首页:" function
	if [[ "${function}" == "0" ]]; then
	    clear
		main
	else
		clear
		exit 1
	fi
	
}
#centos宝塔安装
centosbt(){
    yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh 8ee72501
    back_home
}
#ubantu宝塔安装
ubantubt(){
    wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh 8ee72501
    back_home
}
#debian宝塔安装
debianbt(){
    wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh 8ee72501
    back_home
}
#fedora宝塔安装
fedorabt(){
    wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh 8ee72501
    back_home
}
#宝塔升级
updatabt(){
	wget -O update.sh http://download.bt.cn/install/update.sh && sh update.sh
	back_home
}
#centos宝塔官方挂载
centosgz(){
    yum install wget -y && wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
    back_home
}
#ubantu宝塔官方挂载
ubantugz(){
    wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
    back_home
}
#debian宝塔官方挂载
debiangz(){
    wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
    back_home
}
#debian宝塔魔改挂载
debianmggz(){
    wget -O auto_disk.sh https://cdn.jsdelivr.net/gh/vpsad/shell/disk/auto_disk.sh && bash auto_disk.sh
    back_home
}
#ubuntu宝塔魔改挂载
ubantumggz(){
    wget -O auto_disk.sh https://cdn.jsdelivr.net/gh/vpsad/shell/disk/auto_disk.sh && sudo bash auto_disk.sh
    back_home
}
#centos宝塔魔改挂载
centosmggz(){
    yum install wget -y && wget -O auto_disk.sh https://cdn.jsdelivr.net/gh/vpsad/shell/disk/auto_disk.sh && bash auto_disk.sh
    back_home
}
#BBR一键脚本
bbryj(){
    wget -N --no-check-certificate "https://cdn.jsdelivr.net/gh/vpsad/shell/server/tcpplus.sh" && chmod +x tcpplus.sh && ./tcpplus.sh
}
#回程路由可视化
kshhc(){
    curl https://cdn.jsdelivr.net/gh/vpsad/shell/server/line_test.sh|bash
	back_home
}
#奈飞检测脚本
nfipjc(){
    wget -O nf https://cdn.jsdelivr.net/gh/vpsad/shell/server/nf && chmod +x nf && clear && ./nf
	back_home
}

# 退出脚本
delete(){
    clear
    echo -e "感谢使用VPS博客Linux工具箱"
    rm -rf /vpsad.sh
    rm -rf vpsad.sh
}
main(){
    clear
	echo -e "
|===================================================|
|  VPS博客：            \033[1;35mhttps://www.vpsad.cn\033[0m        |
|  脚本版本：           \033[1;32mvpsad_LinuxToolsV1.0.1\033[0m      |
|  \033[1;31mQQ交流群：           613980114\033[0m                   |
|  问题反馈：           去博客或QQ群找\033[1;34m帅哥\033[0m博主      |
|--------------------[官方宝塔]---------------------|
|(1)CentOS系统安装官方宝塔                          |
|(2)Ubuntu/Deepin系统安装官方宝塔                   |
|(3)Debian系统安装官方宝塔                          |
|(4)Fedora系统安装官方宝塔                          |
|(5)宝塔一键升级                                    |
|(6)Centos官方挂载工具(请在安装宝塔前挂载)          |
|(7)Ubuntu官方挂载工具(请在安装宝塔前挂载)          |
|(8)Debian官方挂载工具(请在安装宝塔前挂载)          |
|--------------------[实用工具]---------------------|
|(9)去除宝塔强制登录       |
|(10)清理垃圾[清理系统以及面板产生的缓存垃圾]       |
|(11)登陆限制[去除宝塔linux面板强制登陆的限制]      |
|(12)修复环境[安装升级宝塔lnmp的环境只支持centos7]  |
|(13)清理残留[清理官方和破解版的文件残留并修复面板] |
|(14)卸载面板[本功能会清空所有数据卸载网站环境]     |
|(15)封装工具[高级功能不懂的不要执行以免数据丢失]   |
|(14)停止服务[停止面板LNMP,Redis,Memcached服务]     |
|(17)Centos挂载磁盘[VPS博客魔改，支持自定义目录]    |
|(18)Ubuntu挂载磁盘[VPS博客魔改，支持自定义目录]    |
|(19)Debian挂载磁盘[VPS博客魔改，支持自定义目录]    |
|(qk)清空数据盘[解决重装系统不清空数据盘,重装前使用]|
|(kr)普通版转酷锐面板[酷锐云宝塔联合定制版]         |
|--------------------[降级版本]---------------------|
|(a)7.4.5 (b)7.4.3 (c)7.4.2 (d)7.4.0 (e)7.3.0       |
|注意:由于7.4.2有安全漏洞仅用于学习生产环境禁止使用 |
|手动升级包下载地址：https://www.vpsad.cn/1.html    |
|--------------------[离线宝塔]---------------------|
|(20)开启完全离线服务     (21)关闭完全离线服务      |
|注意:离线功能会完全断开与宝塔的通讯部分功能无法使用|
|因此请在部署完网站后开启离线，如需安装插件关闭即可.|
|--------------------[其他功能]---------------------|
|(bbr)BBR一键脚本       (hc)回程路由可视化          |
|(nf)奈飞检测脚本       (0)退出脚本                 |
|--------------------[广告赞助]---------------------|
|酷锐云=>香港美国稳定回程GIA服务器=> yun.kuruiit.com|
|赞助我们：https://www.vpsad.cn/money               |
|===================================================|
	"
	read -p "请输入需要输入的选项:" function
	case $function in
	1)  centosbt
    ;;
    2)  ubantubt
    ;;
    3)  debianbt
    ;;
    4)  fedorabt
    ;;
    5)  updatabt
    ;;
    6)  centosgz
    ;;
    7)  ubantugz
    ;;
    8)  debiangz
    ;;
    9)  package_btpanel
    ;;
	10) cleaning_garbage
    ;;
    11) mandatory_landing
    ;;
    12) repair_environment
    ;;
    13) cleaning_residue
    ;;
    14) uninstall_btpanel
    ;;
    15) package_btpanel
    ;;
    16) stop_btpanel
    ;;
    17) centosmggz
    ;;
	18) ubantumggz
    ;;
	19) debianmggz
    ;;
	20) open_offline
    ;;
	21) close_offline
    ;;
	a) version=7.4.5
       degrade_btpanel
    ;;
	b) version=7.4.3
       degrade_btpanel
    ;;
	c) version=7.4.2
       degrade_btpanel
    ;;
	d) version=7.4.0
       degrade_btpanel
    ;;
	e) version=7.3.0
       degrade_btpanel
    ;;
	qk) format_disk
	;;
	kr) Setup_Count
	;;
	bbr) bbryj
	;;
	hc) kshhc
	;;
	nf) nfipjc
	;;
	*)  delete
    ;;

    esac
}

main
