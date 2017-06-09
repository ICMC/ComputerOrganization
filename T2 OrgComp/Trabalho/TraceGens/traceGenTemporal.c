#include <stdio.h>
#include <stdlib.h>
#include <time.h>


int main(){
  int repeat, i, aux;
  int traceSize;
  srand(time(NULL));

  aux = rand()%2048;
  repeat = aux;

  scanf("%d", &traceSize);
  for(i=0; i<traceSize; i++){
    aux = rand()%2048;
    if(!(i%4)) printf("2 %x\n", repeat);
    else printf("2 %x\n", aux);
    if(!(i%20)) repeat = aux;
  }

  return 0;
}
