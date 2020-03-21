#!/bin/bash

X="/sys/kernel/debug/tracing"

declare -a arr=("kmem:mm_page_alloc_extfrag"
    "kmem:kfree"
    "kmem:kmalloc_node"
    "kmem:kmem_cache_alloc"
    "kmem:kmem_cache_alloc_node"
    "kmem:kmem_cache_free"
    "kmem:mm_page_pcpu_drain"
    "kmem:mm_page_alloc"
    "kmem:mm_page_alloc_zone_locked"
    "kmem:mm_page_free"
    "kmem:mm_page_free_batched"
)

echo "kmem:kmalloc" > "$X/set_event"
for i in "${arr[@]}"
do
   echo "$i" >> "$X/set_event"
done

echo > "$X/trace"

echo "nop" > "$X/current_tracer"
echo "1" > "$X/tracing_on"

ab -n 10000 -c 10 localhost/

echo "0" > "$X/tracing_on"
