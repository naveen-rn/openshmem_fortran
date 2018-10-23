#include <stdio.h>
#include <stdlib.h>

typedef void *ctx_t;
int count = 0;

void ctx_create(ctx_t *ctx)
{
    ctx = malloc(sizeof(int));

    count = count + 1;
    *((int*)ctx) = count;

    return;
}

void ctx_update(ctx_t *ctx)
{
    count = count + 1;
    *((int*)ctx) = count;

    return;
}

void ctx_free(ctx_t *ctx)
{
    printf("%d\n",*((int*)ctx));
    free(ctx);
    return;
}
