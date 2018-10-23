#include <stdio.h>

typedef int ctx_t;
ctx_t count = 0;

ctx_t ctx_create(void)
{
    count = count + 1;
    return count;
}
