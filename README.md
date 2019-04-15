# Unicorn🦄

Unicorn is a programming language that trancompiles to object oriented C code that is idiomatic and readable. The `unicorn` command also offers a library agnostic helper macro for JSON and JSX, and can generate documentation that uses markdown.

Unicorn can be used totally side by side with normal C and abandoned easily (if more distraction than it's worth) leaving clean readable C. Linguistically, unicorn is a superset of C99 and does not hamper your ability to write C99 and is primarily oriented toward structure, inferences, and utility macros. This project is meant to augment one's experience with C.

```bash
unicorn .  #process all .u files in this directory and subdirectories
```

# Structure Methods
Methods can now be placed in structures to cognitively align your function names with code files.

```go
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


# Structure Deletion
Structure deletion helps recursively free memory of structures
```go
package foo
import "stdio"

struct Foo {
     char *msg;
     int count;
     ...
}

int main(){
     let f = Foo::create();
     delete f;
     ...
}
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
     ...
}

void Foo_delete(struct Foo *self) {
     free(f.msg);
     free(f);
}

int main() {
     struct Foo *f = Foo_create();
     f.delete();
     ...
}
```

# Useful Macros

Unicorn provides macros for efficient structured data.

## JSON
```go
package foo

import "stdio"
import "json"

int main(){
     let name = "John";
     let data = json!({
          foo:1,
          bar:"abc",
          name:name
     });
     printf(data.get("name").as_str());
     return 0;
}
```

trancompiles to

```C
//foo.h

#ifndef FOO_H
#define FOO_H

#include "stdio.h"
#include "json.h"

#endif FOO_H
```

```C
//foo.c

#include "foo.h"

int main(){
     struct JSON *data;
     char *name;
     name = "John";
     data = JSON_new();
     data.set_number("foo",1);
     data.set_string("bar","abc");
     data.set_string("name",name);
     printf(data.get("name").as_str());
     return 0;
}
```
## JSX
```go
package foo

import "stdio"
import "vnode"

VNode * component(){
     return html!(<div>Hello World<div>)
}
```

trancompiles to

```C
//foo.h

#ifndef FOO_H
#define FOO_H

#include "stdio.h"
#include "vnode.h"

#endif FOO_H
```

```C
//foo.c

#include "foo.h"

VNode * component(){
     struct VNode *v0;
     struct VNode **v0_children;
     struct VNode *v1;
     v1 = malloc(sizeof(VNode));
     v1.type = VNODE_TEXT;
     v1.text = "Hello World!";
     v0_children = malloc(sizeof(VNode*)*2);
     v0_children[0] = v1;
     v0_children[1] = NULL;
     v0 = malloc(sizeof(VNode);
     v0.type = VNODE_NODE;
     v0.props = NULL;
     v0.children = v0_children;
     return v0;
}
```

# Let 
To the best of unicorn's ability we'll try to find the implied type
```go 
int main(){
     let f = Foo::create();
     ...
}
```

# Exporting 
Easily export functions to users of your library.
```go
package foo

export void foo(bytes data){
     ...
}
```

```C
//foo.c

__attribute__((visibility("default"))) void foo(char *data){
     ...
}
```

# Initialization 
Easily specify a package initializer that runs before main is called
```go
package foo

char *secret;

init {
     secret = "open sesame"
}
```

```C
//foo.c

char *secret;

__attribute__ ((constructor)) void __foo_package_init(){
     secret = "open sesame";
}
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
