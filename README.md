# cputest - a simple multi-core CPU benchmark tool for integer calculation

It is a simple Perl program that just do the Fibonacci sequence calculation which is usually used to bench mark CPU integer handling performance.

## Installation

It just require Perl environment and HiRes module.

- On Windows, I suggest use git-bash which contains Perl runtime.
- On Linux like CentOS/Ubuntu, usually it contains basic Perl runtime. If not:

		sudo yum install perl perl-Time-HiRes

- On OpenWRT:

		opkg install perl perlbase-threads perlbase-time

## Usage

Single thread (test single CPU core). Do calculation 80000 times by default. Output the total time in seconds.

	./_cputest.pl
	(Result example: 8s)

Dual thread:

	./_cputest.pl 2
	(Result example: 4s)

4-thread test:

	./_cputest.pl 4
	(Result example for 4-core CPU: 2s)
	(Result example for 2-core CPU: 4.1s)

4-thread test, but standard calculations * 2, for powerful CPU:

	./_cputest.pl 4 2
	(Result example for 4-core CPU: 4s)

1-thread test, but standard calculations * 0.1, for sick CPU:

	./_cputest.pl 1 0.1

# CPU整数运算性能测试工具

测试CPU整数运算性能及多线程能力。
其原理是做n=1000的斐波那契数列值，这是典型的整数运行性能测试。
默认为计算80000次，可指定线程和倍率。

这是我用了好些年的测试工具，简单好用，分享给大家。

2022/5/13 选择今天开源这个测试软件，也是因为在某平台上的测试数据显示了一些问题。
为避免被认为是我的测试工具有问题，我直接放出源码。

## 安装

这是个perl程序，直接将`_cputest.pl`拷贝到服务器上执行即可。一般linux服务器上应该可以直接运行。
如果有报错，可以安装一下perl及HiRes模块。

运行环境安装：

Windows电脑可以下降安装Windows版本的Perl，或者很多开发者都安装过git，可以直接打开git-bash，在里面的仿Linux环境中运行（里面默认有Perl）。

centos 7/8参考:

	sudo yum install perl perl-Time-HiRes

openwrt 21.02参考:

	opkg install perl perlbase-threads perlbase-time

Linux下，如果没有执行权限，可用chmod加一下：

	chmod a+x _cputest.pl

## 用法示例

测试单线程计算时间，即CPU单核性能，计算量默认为80000次，单位是秒。

	./_cputest.pl
	（结果示例：8秒）

测试双线程计算时间，如果是2核或更多核的CPU，其时间差不多应该是单线程的一半；
如果是单核CPU，其时间应与单线程测试时间接近，一般会略高些，应该线程切换有额外代价：

	./_cputest.pl 2
	（结果示例：4秒）

测试4线程计算时间，如果是4核以上CPU，其时间差不多应该是单核的1/4：

	./_cputest.pl 4
	（结果示例：2秒）

如果是台性能特别强的牛机，测试时间会很短，可以给它增加计算量，第3参数为倍率，设置为2就是增加1倍计算量：

	./_cputest.pl 4 2
	（结果示例：4秒，则换算成标准计算量，应该是除以2即2秒）

如果是台性能特别弱的菜机，比如测试路由器的CPU，可以减少计算量，比如设置倍率为0.1就是按1/10的工作量：

	./_cputest.pl 1 0.1
	（结果示例：4秒，则换算成标准计算量，应该是除以0.1即40秒）

## 测试数据参考

分享部分测试数据，大家可以直接比较单核和多核性能。

### 阿里云主机

阿里云主机(2核8G) Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz (2021/12/23)
操作系统为CentOS7:

	1: 8.8s
	2: 4.6s
	4: 4.5s

### 苹果macbook

苹果macbook 13 pro (苹果m1 cpu) 2022/1
操作系统为MacOS:

	1: 4.8s
	8: 0.6s

苹果m1的整数运算性能确实强悍。

### 入门级路由器

入门级路由器(1核128M)  MediaTek MT7620 SoC (580MHz) / MediaTek MT7620A ver:2 eco:6
操作系统为OpenWRT:

	1: 280s
	2: 280s

### 联想小新笔记本（AMD锐龙)

联想小新笔记本AMD版本，AMD Ryzen 5 4600U (6核12线程)
操作系统为Windows 10。使用git软件自带的git-bash来做的测试。

不插电源时(cpu 1.5G-3G左右)

	1: 7-17s
	2: 9s

插电源时(cpu 3.8G)

	1: 6.5s
	2: 3.3s
	4: 1.7s
	6: 1.4s
	12: 0.9s

