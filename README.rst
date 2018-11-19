bincount
========

No-copy parallelized bincount returning dict.

Motivation
----------

As of Nov 2018, ``np.bincount`` is unusable with large memmaps:

.. code-block::

   >>> import numpy as np
   >>> np.bincount(np.memmap('some-5gb-file.txt', mode='r'))
   Traceback (most recent call last):
     File "<stdin>", line 1, in <module>
   MemoryError

The most effective pure-python solution for ``wc -l`` is a bit slow:

.. code-block::

   In [6]: %%time
      ...: sum(1 for i in open('some-5gb-file.txt', mode='rb'))
      ...:
   CPU times: user 3.5 s, sys: 878 ms, total: 4.38 s
   Wall time: 4.38 s
   Out[6]: 58941384

It is 3x times slower than ``wc -l``:

.. code-block::

   In [1]: %%time
      ...: !wc -l some-5gb-file.txt
      ...:
   58941384 some-5gb-file.txt
   CPU times: user 1.48 ms, sys: 3.48 ms, total: 4.96 ms
   Wall time: 1.24 s

While it should be faster on modern multicore SMP systems:

.. code-block::

   In [1]: import numpy as np

   In [2]: from bincount import bincount

   In [3]: %%time
      ...: bincount(np.memmap('some-5gb-file.txt', mode='r'))[10]
      ...:
   CPU times: user 6.83 s, sys: 354 ms, total: 7.19 s
   Wall time: 705 ms
   Out[4]: 58941384

Install
-------

Prequirements: C-compiler with OpenMP support.

Install with pip:

.. code-block::

   pip install bincount

Usage
-----

There is a ``bincount`` (a parallel version) and a ``bincount_single`` (which don't
parallelize the calculation) functions, both returning the dict containing the
number of occurrences of each byte value in the passed bytes-like object:

.. code-block::

   >>> from bincount import bincount
   >>> bincount(open('a-tiny-file.txt', 'rb').read())
   {59: 2, 65: 5, 66: 1, 67: 3, 68: 2, 69: 3, 73: 4, 76: 7, 84: 3, 86: 1, 95: 4}
