# Unicorn🦄

Unicorn is a programming language that trancompiles to object oriented C code that is idiomatic and readable. The `unicorn` command also offers a library agnostic helper macro for JSON and JSX, data mutability and ownership checks, and can generate documentation that uses markdown.

`unicorn` isn't meant to be used as a compiler, but as a tool for accelerating writing and documenting C in manner that matches a common conceptual level of object oriented C and provide some useful checks along the way. It can be used totally side by side with normal C and abandoned easily (if more distraction than it's worth) leaving clean readable C. Linguistically, unicorn changes very little about C99 and is primarily oriented toward structure, inferences, checks, and shortcuts of the existing spec. This project is not meant to replace C, but to augment one's experience with C.

```console
unicorn foo.u -o foo.c
```

Example:
```rust
use "stdio"

struct Foo {
     str msg;
     
     pub Foo* create() {
        let mut f = new Foo;
        f.x = "Foo";
        return f;
     }
     
     void blah(ref self) {
        printf(self.f)
     }
}

int main(){
     let mut f = Foo::create();
     f.blah();
     delete f;
     return 0;
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
     struct Foo *f;
     f = malloc(sizeof(Foo));
     f.x = "Foo";
     return f;
}

void Foo_blah(struct Foo *self) {
     printf(self.f);
     return;
}

void Foo_delete(struct Foo *self) {
     free(f.msg);
     free(f);
}

int main() {
     struct Foo *f = Foo_create();
     f.blah();
     f.delete();
     return 0;
}
```

# Useful Macros

Unicorn provides macros for efficient structured data.

## JSON
```rust
//foo.u

use "stdio"
use "json"

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
```rust
//foo.u

use "stdio"
use "vnode"

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
     return VNode_h(Vnode{
          .type=VNODE_NODE, 
          .node=VNodeElement{
               .tag = "div"
               .props = NULL,
               .children = Vnode[]{ VNode{
                   .type=VNODE_TEXT, 
                   .text = "HelloWorld}
                   },NULL}
     }
}
```

# Mutability enforcement

```rust
//foo.u
int main(){
     let mut b = 1;
     b = 2; // works
     let a = 1;
     a = 2; // Error: a not mutable
}
```

# Ownership enforcement

```rust
void a(ref Foo *f){
     ...
}

void b(Foo *f){
     ...
}

//foo.u
int main(){
     let f = Foo::create();
     a(f);
     b(f);
     b(f); // Error: used variable after claimed ownership
}
```

# Exporting 

```rust
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

