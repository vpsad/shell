#!/bin/bash
#
# Copyright (C) 2019 - 2021 PT <zbxhhzj@qq.com>
#
# QQ Group: 613980114
#
# URL: https://www.vpsad.cn/
#
#全局变量
panel_path=/www/server/panel
Green="\033[32m" && Red="\033[31m" && Blue="\033[34m" && Font="\033[0m"
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
#封装工具
package_btpanel(){
    clear
    python /www/server/panel/tools.py package
    back_home
}
#降级版本
degrade_btpanel(){
	read -p "请输入版本(例如：7.4.5):" val
	version=$val
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
    	echo "获取更新包失败，请稍后更新或联系作者，也可能官方没有这个包。"
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
	back_home
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
#官方宝塔安装
bt_official(){
	echo -e "
	1.CentOS系统
	2.Ubuntu/Deepin系统
	3.Debian系统
	4.Fedora系统
	0.返回首页
	"
	read -p "请选择系统(输入序号):" function
	if [[ "${function}" == "0" ]]; then
	    clear
		main
	 elif [[ "${function}" == "1" ]]; then
		yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh 8ee72501
		back_home
	 elif [[ "${function}" == "2" ]]; then
		wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh 8ee72501
		back_home
	 elif [[ "${function}" == "3" ]]; then
		wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh 8ee72501
		back_home
	 elif [[ "${function}" == "4" ]]; then
		wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh 8ee72501
		back_home
	 else
		clear
		exit 1
	fi
}
#宝塔官方挂载
bt_ofgz(){
	echo -e "
	1.CentOS系统
	2.Ubuntu系统
	3.Debian系统
	0.返回首页
	"
	read -p "请选择系统(输入序号):" function
	if [[ "${function}" == "0" ]]; then
	    clear
		main
	 elif [[ "${function}" == "1" ]]; then
		yum install wget -y && wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
	 elif [[ "${function}" == "2" ]]; then
		wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
	 elif [[ "${function}" == "3" ]]; then
		wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
	 else
		clear
		exit 1
	fi
	rm -rf /auto_disk.sh
    rm -rf auto_disk.sh
	back_home
}
#宝塔升级
updatabt(){
	wget -O update.sh http://download.bt.cn/install/update.sh && sh update.sh
	back_home
}
#宝塔魔改挂载
bt_mggz(){
	echo -e "
	1.CentOS系统
	2.Ubuntu系统
	3.Debian系统
	0.返回首页
	"
	read -p "请选择系统(输入序号):" function
	if [[ "${function}" == "0" ]]; then
	    clear
		main
	 elif [[ "${function}" == "1" ]]; then
		wget -O auto_disk.sh https://cdn.jsdelivr.net/gh/vpsad/shell/disk/auto_disk.sh && bash auto_disk.sh
	 elif [[ "${function}" == "2" ]]; then
		wget -O auto_disk.sh https://cdn.jsdelivr.net/gh/vpsad/shell/disk/auto_disk.sh && sudo bash auto_disk.sh
	 elif [[ "${function}" == "3" ]]; then
		yum install wget -y && wget -O auto_disk.sh https://cdn.jsdelivr.net/gh/vpsad/shell/disk/auto_disk.sh && bash auto_disk.sh
	 else
		clear
		exit 1
	fi
	rm -rf /auto_disk.sh
    rm -rf auto_disk.sh
	back_home
}
#BBR一键脚本
bbryj(){
    wget -N --no-check-certificate "https://cdn.jsdelivr.net/gh/vpsad/shell/server/tcpplus.sh" && chmod +x tcpplus.sh && ./tcpplus.sh
	back_home
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
	echo -e "        VPS博客Linux工具箱脚本 ${Red}[v1.0.3]${Font}
-- By ${Red}VPS博客${Font} | ${Green}www.vpsad.cn${Font} | ${Blue}QQ群：613980114${Font} --
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
${Green}1.${Font}Linux安装官方宝塔        ${Green}2.${Font}宝塔一键升级  
${Green}3.${Font}官方一键挂载数据盘工具(请在安装宝塔前挂载)
${Green}4.${Font}去除宝塔强制登录         ${Green}5.${Font}清理垃圾                         
${Green}6.${Font}修复环境[只支持c7]       ${Green}7.${Font}清理残留[清理修复面板] 
${Green}8.${Font}卸载面板[清空数据]       ${Green}9.${Font}封装工具[不懂不要执行]
${Green}10.${Font}停止服务[停止宝塔]      ${Green}11.${Font}挂载磁盘[自定义目录]    
${Green}qk.${Font}清空数据盘[重装前使用]  ${Green}kr.${Font}普通版转酷锐面板 
${Green}old.${Font}安装老版本宝塔[降级可能失败，请先备份数据!]
${Green}20.${Font}开启完全离线服务        ${Green}21.${Font}关闭完全离线服务
${Green}bbr.${Font}BBR一键脚本            ${Green}hc.${Font}回程路由可视化
${Green}nf.${Font}奈飞检测脚本
${Red}输入p+数字选页，目前共一页。${Font}
输入 ${Red}0${Font} 退出脚本 
ˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇˇ
\033[1;35m酷锐云 | 香港美国稳定回程GIA服务器 => yun.kuruiit.com\033[0m
广告赞助请加QQ群613980114联系群主
	"

	read -p "请输入需要输入的选项:" function
	case $function in
	1)  bt_official
    ;;
    2)  updatabt
    ;;
    3)  bt_ofgz
    ;;
    4)  mandatory_landing
    ;;
    5)  cleaning_garbage
    ;;
    6)  repair_environment
    ;;
    7)  cleaning_residue
    ;;
    8)  uninstall_btpanel
    ;;
    9)  package_btpanel
    ;;
	10) stop_btpanel
    ;;
    11) bt_mggz
    ;;
	20) open_offline
    ;;
	21) close_offline
    ;;
	old)degrade_btpanel
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
