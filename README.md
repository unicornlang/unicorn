# Unicorn🦄

Unicorn is a programming language built to trancompile to object oriented C code that is idiomatic and readable.

```console
unicorn foo.u -o foo.c
```

Example:
```rust
use "stdio"

struct Foo {
     str msg;
     
     pub create() -> Foo {
        let mut f = new Foo;
        f.x = "Foo";
        return f;
     }
     
     blah(self) {
        printf(self.f)
     }
}

int main(){
     let mut f = Foo::create();
     f.blah();
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

int main() {
     struct Foo *f = Foo_create();
     f.blah();
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
