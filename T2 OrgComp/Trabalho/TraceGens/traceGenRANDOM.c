#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int main(){
	int repeat, i;
	int traceSize;
	srand(time(NULL));


	scanf("%d", &traceSize);
	for(i=0; i<traceSize; i++){
		printf("2 %x\n", rand()%2048);
	}

	return 0;
}
