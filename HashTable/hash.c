
#define hashSize = 16

void menu(int opcao){
  printf("1.Insertion \n");
  printf("2.Remove \n");
  printf("3.Search \n");
  printf("4.Exit")
  printf("What option: %d", &opcao);
}

int funcHash(int value){
  return value%hashSize;
}

void insert(int value, ){

}

void remove(int value, ){

}

int search(int value, ){
  return value; // value is on the Hash
  return -1; // value is not on the hash
}

void printHash(){

}

void main(){

  int hash[16];
  int option, value;

  menu(option);

  while(option!=4){
    if(option == 1){
      printf("What value you wanna insert: %d", &value);
      insert(value);
    }
    else if(option == 2){
      printf("What value you wanna remove: %d", &value);
      remove(value);
    }
    else if(option == 3){
      prinf("What value you wanna search: %d", &value);
      search(value);
    }

    menu(option);
  }


}
