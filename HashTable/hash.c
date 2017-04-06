// bia
#include <stdio.h>
#include <stdlib.h>


// Implement doubly linked list
//
struct node{
  struct node *prev;
  int n;
  struct node *next;
};

int hashFunc(int value){
  int hashSize = 16;
  return value%hashSize;
}

struct node* createNode(int value){
  struct node* newNode;
  newNode = (struct node*)malloc(1*sizeof(struct node*));
  newNode->prev = NULL;
  newNode->next = NULL;
  newNode->n = value;
  return newNode;
}

// insert nodes at the doubly ordered list
void insert(int value, struct node **hash, int *sizeVector, int index){
    struct node*  newNode = createNode(value);
    struct node* aux = hash[index];

    if(hash[index] == NULL){ // if there is no node on the doubly list just insert it
      hash[index] = newNode;
      printf("value %d was inserted. \n", value);
    }

    else{
        while(aux->n < value){ // while node value is less then the value to be inserted
          aux = aux->next;
        }
        newNode->next = aux;
        newNode->prev = aux->prev;
        aux->prev = newNode;
        printf("value %d was inserted. \n", value);
    }
    sizeVector++;
}


void menu(int *opcao){
  printf("\n1.Insertion \n");
  printf("2.Remove \n");
  printf("3.Search \n");
  printf("4.Exit\n");
  printf("What option: ");
  scanf("%d", opcao);
}


int removeKey(int value, struct node **hash, int *sizeVector, int index){
    struct node* aux =  hash[index];
    struct node* aux2;
    if(hash[index] == NULL){ // check if the doubly list is empty
      printf("value %d does not exists in the hash. \n", value);
      return -1;
    }
    else{
      while(aux->n != value){ // while value on the node is different than value searched , go to the next node
        if(aux->next == NULL){ // if the next node is NULL , then there is not a node with the valued searched
          printf("value %d does not exists on the hash. \n", value);
          return -1;
        }
        else{
          aux= aux->next;
        }
        // when it finds the node with the value searched
        if(aux->prev == NULL && (aux->next != NULL)){ // checks if the node to be removed is the first on the list
            aux2 = aux->next;
            aux2->prev = aux->prev;
            hash[index] = aux2;

        }else{ // if its not the first element then just remove it
          aux2 = aux->prev;
          aux2->next = aux->next;
          printf("value %d was removed.\n", value);
        }
      }

      sizeVector[index]--;
      return value;
    }
}

// binary search...
int search(int value, struct node **hash, int index ){
  struct node* aux =  hash[index];
  while(aux->n != value){
      if(aux->next == NULL){
          return -1; // value is not on the hash
      }
      aux = aux->next;
  }
  return value; // value is on the Hash
}

void printHash(){

}

void main(){

  struct node **hash=(struct node **)calloc(16,sizeof(struct node**));// vector of 16 pointers to node structures
  int  *sizeVector; // vector that will keep track of the doubly linked lists size
  int option, value, index, result;
  sizeVector = (int*) calloc(16, sizeof(int));

  menu(&option);

  while(option!=4){
    if(option == 1){
      printf("What value you wanna insert: ");
      scanf("%d", &value);
      index = hashFunc(value);
      insert(value, hash, sizeVector, index);
    }
    else if(option == 2){
      printf("What value you wanna remove: ");
      scanf("%d", &value);
      index = hashFunc(value);
      result = removeKey(value, hash, sizeVector, index);
      if(result != -1){
        printf("Value %d was removed", result);
      }
    }
    else if(option == 3){
      printf("What value you wanna search: ");
      scanf("%d", &value);
      index = hashFunc(value);
      result = search(value, hash, index);
      if(result == -1){
        printf("Value was not found :( \n");
      }else{
          printf("Value %d was found \n", result);
      }

    }

    menu(&option);
  }


}
