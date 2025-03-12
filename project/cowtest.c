#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
  char *ptr;
  
  if(fork() == 0) {
    // Child Process
    ptr = sbrk(0);  // Get current break
    *ptr = 'X';      // Write to memory (should trigger COW)
    printf(1, "COW Test: Child wrote to memory successfully\n");
    exit();
  } else {
    wait();
    printf(1, "COW Test: Parent and Child finished execution\n");
  }

  exit();
}

