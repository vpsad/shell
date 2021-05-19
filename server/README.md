# 这里存放和服务器测试相关的脚本
line_test.sh 是回程线路一键脚本，直接显示具体线路，如CN2 GIA、CN2 GT等，非常直观。

`curl https://cdn.jsdelivr.net/gh/vpsad/shell/server/line_test.sh|bash`

BBR安装代码：

`wget -N --no-check-certificate "https://cdn.jsdelivr.net/gh/vpsad/shell/server/tcpplus.sh" && chmod +x tcpplus.sh && ./tcpplus.sh`

一键检测Netflix的IP解锁范围及对应地区的脚本：
```
wget -O nf https://cdn.jsdelivr.net/gh/vpsad/shell/server/nf && chmod +x nf && clear && ./nf
#简洁检测
./nf -help
#脚本命令详解
```
