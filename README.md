# cputest - a simple multi-core CPU benchmark tool for integer calculation

It is a simple program that just do the Fibonacci sequence calculation which is usually used to bench mark CPU integer handling performance.

## Installation

`cputest-linux` is pre-compiled binary for some Linux like centos/ubuntu. If it fails to run, you can compile via `make` to create you own `cputest`. It requires gcc and pthread library.

`_cputest.pl` is a Perl script, that just requires Perl environment and HiRes module.

- On Windows, I suggest use git-bash which contains Perl runtime.
- On Linux like CentOS/Ubuntu, usually it contains basic Perl runtime. If not:

		sudo yum install perl perl-Time-HiRes

- On OpenWRT:

		opkg install perl perlbase-threads perlbase-time

## Usage

### cputest

by default, 1 thread, 10 seconds:

	./cputest
	OR
	./cputest 1
	OR
	./cputest 1 10

Result example: (`score` is the final result)

	score=276.626984, total=2769, time=10.009870s

2 threads:

	./cputest 2

### cputest.pl

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
其原理是循环求n=1000的斐波那契数列值，每算1000次计1分，跑分值为1秒内的分值。
这是典型的整数运行性能测试。

本测试工具只做最简单的衡量。
如果要综合评分，推荐使用sysbench，或自行编译的[coremark](https://github.com/eembc/coremark.git).

## 安装

cputest-linux是预编译的binary程序，可直接运行在centos/ubuntu等Linux平台。如果无法运行，则需要自行执行`make`编译，生成cputest程序。
当然这需要有编译环境(gcc, pthread库)。

如果不方便编译，也可以用Perl程序cputest.pl测试，一般Linux都会自带。
它须运行在Perl5环境上（运行环境差异大则无比较意义）。它支持多核，但未对超线程优化，比如4核8线程的CPU，测试4线程时性能约为2线程时的2倍，单线程时的4倍，而使用8线程时测试的性能则可能与4线程时的性能差不多（略高或略低）。

直接将`_cputest.pl`拷贝到服务器上执行即可。一般linux服务器上应该可以直接运行。
如果有报错，可以安装一下perl及HiRes模块。

	git clone git@github.com:skyshore2001/cputest.git
	cd cputest
	./_cputest.pl

运行环境安装：

Windows电脑建议直接使用git自带的git-bash，右键打开git-bash在命令行里面执行即可（里面默认有Perl）。

centos 7/8参考:

	sudo yum install perl perl-Time-HiRes

openwrt 21.02参考:

	opkg install perl perlbase-threads perlbase-time

Linux下，如果没有执行权限，可用chmod加一下：

	chmod a+x _cputest.pl

## 用法示例

### cputest

默认是单线程测试，运行10秒，结果为跑分：

	./cputest
	OR
	./cputest 1
	OR
	./cputest 1 10

cputest也可以是预编译的cputest-linux等。
结果示例：(`score`是最终跑分)

	score=276.626984, total=2769, time=10.009870s

测试2线程、4线程：

	./cputest 2
	./cputest 4

### cputest.pl

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

	cputest
	1: 250
	2: 496
	4: 488

	cputest.pl
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
操作系统为Windows 10。cputest.pl使用git软件自带的git-bash来做的测试。cputest使用Win10上的Linux子系统(wsl中的ubuntu)来测试。

不插电源时(cpu 1.5G-3G左右)

	cputest
	1: 273
	2: 545
	4: 1071
	6: 1706
	12: 3087

	cputest.pl
	1: 7-17s
	2: 9s

插电源时(cpu 3.8G)

	cputest
	1: 437
	2: 864
	4: 1691
	6: 2496
	12: 4647

	cputest.pl
	1: 6.5s
	2: 3.3s
	4: 1.7s
	6: 1.4s
	12: 0.9s

