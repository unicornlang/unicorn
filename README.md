# Unicorn🦄

Unicorn is a programming language that trancompiles to object oriented C code that is idiomatic and readable. Unicorn can be used side by side with C99.

```bash
unicorn .  #process all .u files in this directory and subdirectories
```

# Structure Methods

```nim
import "stdio"

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
is trancompiled into

```C
#include "stdio.h"

struct Foo {
     char *msg;
}

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

__attribute__((visibility("default"))) int main() {
     struct Foo *f = Foo_create();
     f.blah();
     return 0;
}
```

# Easy Exposure
Say you have a function in your module you'd like others to use

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

will transpile to:

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
is trancompiled into
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

Unicorn provides macros that defer to local programs. Assume you have a program on your system called `reversestr` that reverse a string given to it:

```console
echo "hello" | reversestr # olleh
```

Unicorn compiler can be instructed to use that for macro calls it encounters during compilation:

```
import "stdio"

main()
     printf(reverse!("hello"))
```

```
unicorn --m reverse:reversestr .
```

# Beautiful types
`str` transpires to `char *`

`byte` transpires to `char`

`bytes` transpires to `char *`

`bool` transpires to `_Bool`

# Packaging
By default a files package is it's file name. Unicorn files can also specify what package they belong to in the frst line. Other files in the same directory with the same package will be compiled into the same `<package-name>.h` and `<package-name>.c` files. This allows your logic to be segmented into multiple files.

```go  
//foo.u
package foo

foo*()
     ...
```

```go 
//bar.u
package foo

bar()
     ...
```
transcompiles to:
```C
// foo.h

#ifndef FOO_H
#define FOO_H

void foo();

#endif
```
```C
// foo.c
void foo(){
     ...
}

void bar(){
     ...
}
```


# Partial Structures
Structures can be split up across multiple files within the same package
```go
package bar

struct Bar {
     char *msg
     
     foo(self){
          ...
     }
}
```

```go
package bar

struct Bar {
     int count
     
     pub boo(self){
          ...
     }
}
```

is trancompiled into

```C
//foo.h

#ifndef BAR_H
#define BAR_H

struct Bar {
     char *msg;
     int count;
}

void Bar_boo();

#endif BAR_H
```

```C
//foo.c

void Bar_foo() {
     ...
}

void Bar_boo() {
     ...
}
```
