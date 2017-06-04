#include <stdio.h>
#include <time.h>


int main(){
  int repeat, i;
  srand(time(NULL));

  for(i=0; i<207; i++){
    printf("2 %d\n", rand()%2048);
  }

  return 0;
}
