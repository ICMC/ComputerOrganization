// bia

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

// insert nodes at the doubly list ordered
void insert(int value, struct node *hash, int *sizeVector, int index){
    struct node*  newNode = createNode(value);
    struct node* aux = hash[index];

    if(hash[index] == NULL){ // if there is no node on the doubly list just insert it
      hash[index] = newNode;
    }

    else{
        while(aux->n < value){ // while node value is less then the value to be inserted
          aux = aux->next;
        }
        newNode->next = aux;
        newNode->prev = aux->prev;
        aux->prev = newNode;
    }
    sizeVector++;
}


void menu(int opcao){
  printf("1.Insertion \n");
  printf("2.Remove \n");
  printf("3.Search \n");
  printf("4.Exit")
  printf("What option: %d", &opcao);
}


int remove(int value, int **hash, int *sizeVector){
    int index = funcHash(value);
    struct node* aux =  hash[index];
    struct node* aux2;
    if(hash[index] == NULL){ // check if the doubly list is not empty
      return -1;
    }
    else{
      while(aux->n != value){ // while value on the node is different than value searched , go to the next node
        if(aux->next == NULL){ // if the next node is NULL , then there is not a node with the valued searched
          return -1;
        }
        else{
          aux= aux->next;
        }
      }
      aux2 = aux->prev;
      aux2->next = aux->next;
      if (aux->next != NULL){ // check if the pointer for the next node is NULL
        aux = aux->next;
        aux->prev = aux2;
      }
      sizeVector[index]--;
    }
}

// Implement binary search
int search(int value, int **hash ){
  int index = funcHash(value);
  return value; // value is on the Hash
  return -1; // value is not on the hash
}

void printHash(){

}

void main(){

  temp = left = right = NULL;
  struct node **hash=(struct node **)calloc(16,sizeof(struct node*));// vector of 16 pointers to node structures
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
