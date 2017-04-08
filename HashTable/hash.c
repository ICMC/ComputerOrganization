#include <stdio.h>
#include <stdlib.h>
//created by pawpepe

struct node{
  struct node *prev;
  int n;
  struct node *next;
};

// Hash Function
int hashFunc(int value){
  int hashSize = 16;
  int result = value%hashSize;
  printf("mod of value and hashSize = %d \n", result);
  return value%hashSize;
}

//Create a new node
struct node* createNode(int value){
  struct node* newNode;
  newNode = (struct node*)malloc(1*sizeof(struct node*));
  newNode->prev = NULL;
  newNode->next = NULL;
  newNode->n = value;
  return newNode;
}

// Search the node on the doubly linked list with the valued specified
int search(int value, struct node **hash, int index ){
  struct node* aux =  hash[index];
  if(aux == NULL){
    return -1;
  }
  while(aux->n != value){
      if(aux->next == NULL){
          return -1; // value is not on the hash
      }
      aux = aux->next;
  }
  return value; // value is on the Hash
}

// Insert nodes at the doubly ordered list
void insert(int value, struct node **hash, int *sizeVector, int index){
    struct node*  newNode = createNode(value);
    struct node* aux = hash[index];
    struct node *aux2;

    int exist = search(value, hash, index); // checks if the key is already on the hash

    if(exist == -1){ // if key is not on the hash then it will insert it
      if(hash[index] == NULL){ // if there is no node on the doubly list just insert it
        hash[index] = newNode;
      }
      else{
          while((aux->n < value)){ // while node value is less then the value to be inserted
            if(aux->next != NULL){
              aux = aux->next;
            }else{
              break;
            }

          }
          if(aux->prev == NULL && (aux->next !=NULL)){    // if the node is being inserted in the begining of the list
            hash[index] = newNode;
            newNode->next = aux;
            aux->prev = newNode;
          }
          else if(aux->next == NULL){ // if the node is the last one on the list
            newNode->next = NULL;
            newNode->prev = aux;
            aux->next = newNode;
          }
          else{     // if the node is being inserted in the middle of the list
            aux2 = aux->prev;
            aux2->next = newNode;
            newNode->next = aux;
            newNode->prev = aux->prev;
            aux->prev = newNode;
          }
      }
      sizeVector++;
    }else{
      printf("Key already exists on the Hash! \n");
    }

}

//Prints the menu and gets the value for the option chosen
void menu(int *opcao){
  printf("\n1.Insertion \n");
  printf("2.Remove \n");
  printf("3.Search \n");
  printf("4.Print Hash\n");
  printf("5.Exit\n");
  printf("What option: ");
  scanf("%d", opcao);
}

// remove node with the valued specified
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
      }
      // When there is only one node on the list
      if(aux->next == NULL && aux->prev == NULL){
          hash[index] = NULL;
      }
      // when the node is the first on the list
      else if(aux->prev == NULL && (aux->next != NULL)){ // checks if the node to be removed is the first on the list
            aux2 = aux->next;
            aux2->prev = NULL;
            hash[index] = aux->next;
      }
      // when the node to be removed is the last on the list
      else if(aux->next == NULL){
            aux2 = aux->prev;
            aux2-> next = NULL;
      }
      // if the node is in the middle of the list
      else{
          aux2 = aux->prev;
          aux2->next= aux->next;
          aux2 = aux->next;
          aux2->prev = aux->prev;
          printf("value %d was removed.\n", value);
        }
      }
      sizeVector[index]--;
      return value;
}

//Prints all elements of the Hash table
void printHash(struct node **hash){
    struct node * aux;
    int i;
    for(i =0; i < 16; i++){
      aux =  hash[i];
      printf("hash[%d] = ", i);
      if(aux == NULL){
        printf("NULL \n");
      }
      while(aux!=NULL){
        printf("%d ", aux->n);
        aux = aux->next;
      }
      printf("\n");
    }
}

void main(){

  struct node **hash=(struct node **)malloc(16*sizeof(struct node**));// vector of 16 pointers to node structures
  int  *sizeVector; // vector that will keep track of the doubly linked lists size
  int option, value, index, result;
  sizeVector = (int*) calloc(16, sizeof(int));

  menu(&option);

  while(option!=5){
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
    else if(option==4){
      printHash(hash);
    }
    menu(&option);
  }
}
