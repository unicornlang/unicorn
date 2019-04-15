# Unicorn🦄

Unicorn is a programming language that trancompiles to object oriented C code that is idiomatic and readable. The `unicorn` command also offers a library agnostic helper macro for JSON and JSX, and can generate documentation that uses markdown.

Unicorn can be used totally side by side with normal C and abandoned easily (if more distraction than it's worth) leaving clean readable C. Linguistically, unicorn is a superset of C99 and does not hamper your ability to write C99 and is primarily oriented toward structure, inferences, and utility macros. This project is meant to augment one's experience with C.

```bash
unicorn .  #process all .u files in this directory and subdirectories
```

# Structure Methods
Methods can now be placed in structures to cognitively align your function names with code files. Note that the `*` is used to expose something to other modules in your application.

```go
import "stdio"

Foo*:
     msg string
     
(Foo) create*() Foo
     Foo{"hey"}
     
(Foo) blah(self)
     printf(self.msg)
     
main()
     f := Foo::create()
     f.blah()
```
is trancompiled into

```C
//foo.h

#ifndef FOO_H
#define FOO_H

#include "stdio.h"

struct Foo {
     char *msg;
}

struct Foo *Foo_create();

#endif FOO_H
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

# Structure Deletion
Structure deletion helps recursively free memory of structures
```go
import "stdio"

Foo:
     msg string
     count int

main()
     f := Foo{}
     delete f
```
is trancompiled into

```C
//foo.h

#ifndef FOO_H
#define FOO_H

#include "stdio.h"

struct Foo {
     char *msg;
}
#endif FOO_H
```

```C
//foo.c
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
