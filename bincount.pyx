cimport numpy as np
cimport cython
from cython.parallel cimport parallel, prange, threadid
from libc.stdlib cimport abort, malloc, free
from cython.operator import preincrement
cimport openmp


@cython.boundscheck(False)
cdef _bincount_single(const np.uint8_t[:] a):
    cdef unsigned long long i
    cdef unsigned long long l = len(a)
    cdef unsigned long long[256] ret
    for i in range(256):
        ret[i] = 0
    with nogil:
        for i in range(l):
            preincrement(ret[a[i]])
    return ret


@cython.boundscheck(False)
cdef _bincount(const np.uint8_t[:] a):

    cdef np.uint64_t i, l, tid, num_threads, chunksize
    cdef np.uint64_t* b

    num_threads = openmp.omp_get_num_procs()
    l = a.size
    chunksize = int(float(l) / float(num_threads) + .5)

    ret = [0] * 256

    with nogil, parallel(num_threads=num_threads):
        tid = threadid()
        b = <np.uint64_t*> malloc(256 * sizeof(np.uint64_t))
        if b is NULL:
            abort()
        for i in range(256):
            b[i] = 0
        for i in range(tid * chunksize, min((tid + 1) * chunksize, l)):
            preincrement(b[a[i]])
        with gil:
            for i in range(256):
                ret[i] += b[i]
        free(b)

    return ret


def bincount_single(a):
    return {n: i for n, i in enumerate(_bincount_single(a)) if i > 0}


def bincount(a):
    return {n: i for n, i in enumerate(_bincount(a)) if i > 0}
