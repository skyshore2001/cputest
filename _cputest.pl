#!/usr/bin/perl

=pod
测试CPU整数运算性能及多线程能力. 默认为计算80000次，可指定线程和倍率：

示例：
	# 1核
	_cputest

	# 2核
	_cputest 2

	# 4核, 2倍数据，结果应除以2，适用于牛机
	_cputest 4 2

	# 1核, 0.1倍数据，结果应乘以10，适用于菜机
	_cputest 1 0.1

运行环境安装：

centos 8:
	sudo yum install perl perl-Time-HiRes
openwrt 21.02:
	opkg install perl perlbase-threads perlbase-time

测试数据：

2022/1
macbook 13 pro (苹果m1 cpu)
1: 4.8s
8: 0.6s

wrt1/wrt2路由器(1核128M)  MediaTek MT7620 SoC (580MHz) / MediaTek MT7620A ver:2 eco:6
1: 280s (主流云服务器性能的 1/30)
2: 280s

阿里云主机(2核8G) Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz (2021/12/23) oliveche.com
1: 8.8s
2: 4.6s
4: 4.5s

笔记本 AMD Ryzen 5 4600U (6核12线程)  lj-m
不插电源(cpu 1.5G-3G左右)
1: 7-17s
2: 9s
插电源(cpu 3.8G)
1: 6.5s
2: 3.3s
4: 1.7s
6: 1.4s
12: 0.9s

台式电脑 intel core i5-4460 CPU @ 3.2GHz (2核4线程) liangjian-pc
1: 8s
2: 4.2s
4: 2.6s
8: 2.5s

core i7-4790 (3.6G, 4 core 8 threads): server-pc

1: 6.3s
2: 3.4s
4: 2.3s
8: 1.8s

笔记本电脑 core i5-4200U (1.6-2.6G) (双核4线程) lj-m
1 threads: 14s
2 threads: 8.1s
4 threads: 7.3s
8 threads: 7.0s
16 threads: 7.0s

在core i5-2540M (2.6G) CPU上(双核4线程):
1 threads: 21.5s
2 threads: 11.9s
4 threads: 7.2s
8 threads: 6.8s
16 threads: 6.7s

在core i7-2600 (3.4G) CPU上(4核8线程):
1: 12.6s
2: 6.8s
4: 3.8s
8: 2.8s
16: 2.9s

在 Xeon E7-4870 (2.4G) 80core:
1: 24.2
2: 13.0
4: 6.5
8: 3.3
16: 1.7
32: 0.9
64: 0.8

=cut

use strict;
use warnings;
use threads;
use Time::HiRes qw/time/;

my $t0 = time;

my $thr_cnt = $ARGV[0] || 1;
my $radio = $ARGV[1] || 1;
printf "thread=$thr_cnt, cnt=$radio\n";

sub calc # ($n)
{
	my ($a, $b) = (1,2);
	my $c;
	for (1..$_[0]) {
		$c = $a+$b;
		$a = $b;
		$b = $c;
	}
}
sub calc1 # ($repeat)
{
	for (1.. $_[0]) {
		calc(1000);
	}
}

my $total = 80000 * $radio;
my $n = int($total/$thr_cnt);
my @thrs;
for (1..$thr_cnt) {
	my $x;
	if ($_ == $thr_cnt) {
		$x = $total;
	}
	else {
		$x = $n;
		$total -= $n;
	}
	push @thrs, threads->create(\&calc1, $x);
}

for (@thrs) {
	$_->join();
}
printf "%.3fs\n", time-$t0;

