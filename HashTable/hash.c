
#define hashSize = 16

void menu(int opcao){
  printf("1.Insertion \n");
  printf("2.Remove \n");
  printf("3.Search \n");
  printf("4.Exit")
  printf("What option: %d", &opcao);
}
void sort(){

}
int funcHash(int value){
  return value%hashSize;
}

void insert(int value, int **hash, int *sizeVector){
    int index =  funcHash(value);
    if(hash[index][0] == NULL){ // if there is nothing on the array, allocate 1 space for it
      hash[index] = malloc(1*sizeof(int));
      hash[index][0] = value; // insert first value into the first position allocated
      sizeVector[index] = 1;
    }else if(hash[index]){ //if there are already values on the array, reallocate more memory
      hash[index]=realloc(hash[index], (sizeVector[index]+1)*sizeof(int));
      hash[index][sizeVecto[index]] = value;
      sort();
      sizeVector++;
    }

}

void remove(int value, int **hash){
    int index = funcHash(value);
}

int search(int value, int **hash ){
  int index = funcHash(value);
  return value; // value is on the Hash
  return -1; // value is not on the hash
}

void printHash(){

}

void main(){

  int *hash[16];// vector of 16 pointers
  int  *sizeVector; // vector that will keep track of the doubly linked lists size
  int option, value;
  sizeVector = (int*) calloc(16, sizeof(int));

  for(int i=0; i < 16 ; i++){
    hash[i] = malloc(1*sizeof(int));
  }

  menu(option);

  while(option!=4){
    if(option == 1){
      printf("What value you wanna insert: %d", &value);
      insert(value, hash);
    }
    else if(option == 2){
      printf("What value you wanna remove: %d", &value);
      remove(value, hash);
    }
    else if(option == 3){
      prinf("What value you wanna search: %d", &value);
      search(value, hash);
    }

    menu(option);
  }


}
