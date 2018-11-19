from distutils.core import setup
from distutils.extension import Extension
from os import getenv


USE_CYTHON = getenv('USE_CYTHON') == '1'

ext_modules = [
    Extension(
        "bincount",
        ["bincount" + ('.pyx' if USE_CYTHON else '.c')],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-fopenmp'],
    )
]

if USE_CYTHON:
    from Cython.Build import cythonize
    ext_modules = cythonize(ext_modules, language_level=2)


setup(
    name='bincount',
    description='No-copy parallelized bincount returning dict',
    long_description=open('README.rst').read(),
    version='0.0.5',
    author='Andrew Grigorev',
    author_email='andrew@ei-grad.ru',
    url='https://github.com/ei-grad/bincount',
    ext_modules=ext_modules,
)
