# Unicorn🦄

Unicorn is a language built to trancompile to object oriented C code that is idiomatic and readable.

Example:
```rust
use "stdio"

struct Foo {
     str msg;
     
     pub create() -> Foo {
        let f = new Foo;
        f.x = "Foo";
        return f;
     }
     
     blah(self) {
        printf(self.f)
     }
}

int main(){
     let f = Foo::create();
     f.blah();
     return 0;
}
```
is trancompiled into

```C
//foo.h
#IFNDEF FOO_H
#DEFINE FOO_H

#include "stdio.h"

struct Foo {
  char *msg;
}

struct Foo *Foo_create();

#ENDIF FOO_H
```

```C
//foo.c
struct Foo *Foo_create() {
  struct Foo *f;
  f = malloc(sizeof(Foo));
  f.x = "Foo";
  return f;
}

void Foo_blah(struct Foo *self) {
  printf(self.f);
  return;
}

int main() {
     struct Foo *f = Foo_create();
     f.blah();
     return 0;
}
```
