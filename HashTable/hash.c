

#include <stdio.h>
#include <stdlib.h>
#define hashSize = 16

// Implement doubly linked list
//
struct node{
  struct node *prev;
  int n;
  struct node *next;
};

int hashFunc(int value){
  return value%hashSize;
}

struct *node createNode(int value){
  struct node * newNode;
  newNode = (struct *node)malloc(1*sizeof(struct *node));
  newNode->prev = NULL;
  newNode->next = NULL;
  newNode->n = value;
  return newNode;
}

void insertBegining(int value, struct node *hash; int *sizeVector, int index){
    struct node* newNode = createNode(value);
    // insert begining
    if(hash[index][0] == NULL){
      hash[index][0] = newNode;

    }
    else{
      hash[index][0] -> prev = newNode;
      newNode-> next = hash[index][0];
      hash[index][0] = newNode;
    }
    sizeVector[index]++;
}

// insert any middle
void insertMiddle(int value, struct node *hash, int *sizeVector, int index){
    struct node*  newNode = createNode(value);
    
}


else if(value > hash[index][0] ->n && value < hash[index][sizeVector[index] - 1] -> n){

}
// insert end
else if(value >=  hash[index][sizeVector[index] - 1]-> n ){

}
void menu(int opcao){
  printf("1.Insertion \n");
  printf("2.Remove \n");
  printf("3.Search \n");
  printf("4.Exit")
  printf("What option: %d", &opcao);
}
void sort(){

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

  temp = left = right = NULL;
  struct node *hash[16];// vector of 16 pointers to node structures
  int  *sizeVector; // vector that will keep track of the doubly linked lists size
  int option, value;
  sizeVector = (int*) calloc(16, sizeof(int));

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
