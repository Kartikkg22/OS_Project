#ifndef KALLOC_H
#define KALLOC_H


#include "spinlock.h"
struct kmem {
  struct spinlock lock;
  int use_lock;
  int refcount[PHYSTOP / PGSIZE];
  struct run *freelist;
};

extern struct kmem kmem;

extern int kref[PHYSTOP / PGSIZE];

#endif
