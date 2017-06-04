#include <stdio.h>
#include <time.h>


int main(){
  int j, i;
  srand(time(NULL));

  for(i=0; i<207; i++){
    printf("2 %d\n", j);
    j++;
    if((rand()%100) <= 3) j = rand()%j+1;
  }

  return 0;
}
