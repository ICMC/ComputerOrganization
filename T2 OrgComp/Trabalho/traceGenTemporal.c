#include <stdio.h>
#include <time.h>


int main(){
  int repeat, i, aux;
  srand(time(NULL));

  aux = rand()%2048;
  repeat = aux;

  for(i=0; i<207; i++){
    aux = rand()%2048;
    if(!(i%4)) printf("2 %d\n", repeat);
    else printf("2 %d\n", aux);
    if(!(i%20)) repeat = aux;
  }

  return 0;
}
