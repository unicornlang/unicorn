# Unicorn🦄

Unicorn is a programming language that trancompiles to object oriented C code that is idiomatic and readable. The `unicorn` command also offers useful library agnostic helper macros, data mutability and ownership checks, and can generate documentation that uses markdown.

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

