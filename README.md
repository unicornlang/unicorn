# Unicorn🦄

Unicorn is a programming language that trancompiles to Rust. It's primarily meant to target a subset of Rust that is efficient and useful for web assembly in ways the Rust is not by default.

```bash
unicorn .  #transpile all .u files in this directory and subdirectories
```
* easy OOP
* automatic reference counting
* type inference
* powerful macros

# Structure Methods

```nim
import <stdio>
import "thing"

Foo:
     msg string
     
(Foo) create() Foo
     Foo{"hey"}
     
(Foo) blah(self)
     printf(self.msg)
     
main()
     f := Foo::create()
     f.blah()
```

trancompiles to

```C
#include <stdio.h>
#include "thing.h"

struct Foo {
     int __refCount;
     char *msg;
}

struct Foo *Foo_create() {
     struct Foo *f;
     f = malloc(sizeof(Foo));
     f.__refCount = 1;
     f.msg = "Foo";
     return f;
}

void Foo_blah(struct Foo *self) {
     printf(self.msg);
     return;
}

void Foo_delete(struct Foo *self) {
     self.__refCount -= 1;
     if(self.__refCount == 0){
          free(self.msg);
          free(self);
     }
}

__attribute__((visibility("default"))) int main() {
     struct Foo *f = Foo_create();
     f.blah();
     f.__refCount -= 1;
     Foo_delete(f);
     return 0;
}
```

# Easy Exposure
Unicorn uses the `*` symbol to expose functions and structs in your module you'd like other modules to have access to

```nim
# useful.u
Thing*:
     msg string
     
(Thing) my_useful_function*() Thing{
     Thing{"foo"}
}
```

```nim
# main.u
import "useful_thing"

main()
     f := Thing::my_useful_function()
     ...
```

transpiles to

```C
//useful.h

#ifndef USEFUL_H
#define USEFUL_H

struct Thing {
     int __refCount;
     char *msg;
}

struct Thing* Thing_my_useful_function();

#endif USEFUL_H
```
```C
//useful.c
#include "useful.h"

struct Thing* Thing_my_useful_function(){
     struct Thing *t = malloc(sizeof(Thing));
     t.__refCount = 1;
     t.msg = "blah";
     return t;
}
```
```C
//main.c
#include "useful.h"

int main(){
     struct Thing *f = Thing_my_useful_function();
     ...
}
```

# Structure Deletion
Structure deletion helps recursively free memory of structures
```go

Bar:
     msg string

Foo:
     b Bar

main() {
     f := Foo{Bar{"hey"}}
}
```
is trancompiles to
```C
struct Bar {
     char *msg;
}

void Bar_delete(struct Bar *self) {
     self.__refCount -= 1;
     if(self.__refCount == 0){
          free(self);
     }
}


struct Foo {
     Bar *b;
}

void Foo_delete(struct Foo *self) {
     self.__refCount -= 1;
     if(self.__refCount == 0){
          Bar_delete(self.b)
          free(self);
     }
}

int main() {
     struct Foo *f = malloc(sizeof(Foo));
     struct Bar *_x0 = malloc(sizeof(Bar));
     _x0.msg = "foo";
     f.b = _x0;
     Foo_delete(f);
}
```

# Powerful Macros

Unicorn provides macros that defer to local programs. Assume you have a program on your system called `reversestr` that reverses a string given to it:

```console
echo "\"hello\"" | reversestr # \"olleh\"
```

`unicorn` can be instructed to use that program for macro calls it encounters during compilation:

```nim
import "stdio"

main()
     printf(reverse!("hello"))
```

```
unicorn --m reverse:reversestr .
```

```C
#include "stdio.h"

int main() {
     printf("olleh");
}
```

# Beautiful types
`str` transpiles to `char *`

`u8` transpiles to `char`

`[u8]` transpiles to `char *`

`bool` transpiles to `_Bool`

`i32` transpiles to `int`

`f32` transpiles to `float`

# Basic Operations

`* + \ % += -= << >> (int) (float)` work as they do in C
