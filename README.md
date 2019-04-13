# Unicorn🦄

Unicorn is a programming language that trancompiles to object oriented C code that is idiomatic and readable. The `unicorn` command also offers a library agnostic helper macro for JSON and JSX, data mutability and ownership checks, and can generate documentation that uses markdown.

Unicorn can be used totally side by side with normal C and abandoned easily (if more distraction than it's worth) leaving clean readable C. Linguistically, unicorn is a superset of C99 and does not hamper your ability to write C99 and is primarily oriented toward structure, inferences, checks, and shortcuts of the existing spec. This project is meant to augment one's experience with C.

```console
unicorn .  #procdess all .u files in this directory and subdirectories
```

Example:
```rust
package foo
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
package foo

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
package foo

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

# Mutability enforcement

```rust
package foo

int main(){
     let mut b = 1;
     b = 2; // works
     let a = 1;
     a = 2; // Error: a not mutable
}
```

# Ownership enforcement

```rust
package foo

void a(ref Foo *f){
     ...
}

void b(Foo *f){
     ...
}

int main(){
     let f = Foo::create();
     a(f);
     b(f);
     b(f); // Error: used variable after claimed ownership
}
```

# Exporting 

```rust
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

