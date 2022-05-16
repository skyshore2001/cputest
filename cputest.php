<?php
/*
run 1s:
	php cputest.php
run 2s:
	php cputest.php 2
*/

function calc() {
    $a = 1;
    $b = 2;
    for ($i=0; $i<1000; ++$i) {
        $c = $a + $b;
        $a = $b;
        $b = $c;
    }
}

function calc1() {
	for ($i=0; $i<1000; ++$i) {
		calc();
	}
}

$tv = intval(@$argv[1]) ?: 1;
echo("time={$tv}s\n");
$t0 = microtime(true);
$n = 0;
while (true) {
    calc1();
	++ $n;
	$t = microtime(true) - $t0;
	if ($t > $tv)
		break;
}
$score = $n / $t;
echo("score=$score, total=$n, time={$t}s\n");

