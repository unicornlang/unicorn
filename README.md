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

__attribute__((visibility("default"))) int main() {
     struct Foo *f = Foo_create();
     f.blah();
     f.__refCount -= 1;
     if(f.__refCount == 0){
          delete f;
     }
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
Foo:
     msg string
     count int

main()
     f := Foo{}
     delete f
```
is trancompiles to
```C
struct Foo {
     char *msg;
}

void Foo_delete(struct Foo *self) {
     free(self.msg);
     free(self);
}

int main() {
     struct Foo *f = malloc(sizeof(Foo));
     f.delete();
     ...
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
