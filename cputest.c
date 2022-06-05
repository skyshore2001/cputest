#include <time.h>
#include <sys/time.h>
#include <stdio.h>
#include <pthread.h>
#include <unistd.h>

#define MAX_THR 1000
typedef void *(*ThrFn) (void *);

volatile int quitFlag = 0;

void calc()
{
	int i, a=1, b=2, c;
	for (i=0; i<1000; ++i) {
		c=a+b;
		a=b;
		b=c;
	}
}

void calc1()
{
	for (int j=0; j<1000; ++j) {
		calc();
	}
}

void doTask(int *subTotal)
{
	while (1) {
		calc1();
		++ (*subTotal);
		if (quitFlag)
			break;
	}
	//pthread_exit((void*)0);
}

int main(int argc, char *argv[])
{
	int total = 0;

	int thrCnt = 1;
	int testTime = 10; // seconds

	if (argc > 1) {
		sscanf(argv[1], "%d", &thrCnt);
		if (thrCnt < 1 || thrCnt > MAX_THR) {
			printf("bad thread count. scope: 1-%d\n", MAX_THR);
		}
	}
	if (argc > 2) {
		sscanf(argv[2], "%d", &testTime);
	}
	printf("threads=%d, time=%ds\n", thrCnt, testTime);

	struct timeval t1, t;
	gettimeofday(&t1, NULL);
	pthread_t thr[MAX_THR] = {0};
	int subTotal[MAX_THR] = {0};
	for (int i=0; i<thrCnt; ++i) {
		int rv = pthread_create(thr+i, NULL, (ThrFn)doTask, subTotal+i);
		if (rv != 0) {
			printf("fail to create thread\n");
			return 1;
		}
	}
	sleep(testTime);
	quitFlag = 1;
	for (int i=0; i<thrCnt; ++i) {
		pthread_join(thr[i], NULL);
		if (thrCnt > 1)
			printf("  thread %d: %d\n", i, subTotal[i]);
		total += subTotal[i];
	}
	gettimeofday(&t, NULL);
	float tm = (t.tv_sec - t1.tv_sec) + (t.tv_usec-t1.tv_usec)/1000000.0;
	float score = total / tm;
	printf("score=%f, total=%d, time=%fs\n", score, total, tm);
	return 0;
}
