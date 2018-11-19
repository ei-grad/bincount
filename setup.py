from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize


ext_modules = [
    Extension(
        "bincount",
        ["bincount.pyx"],
        extra_compile_args=['-fopenmp'],
        extra_link_args=['-fopenmp'],
    )
]

setup(
    name='bincount',
    description='No-copy parallelized bincount returning dict',
    long_description=open('README.rst').read(),
    version='0.0.3',
    author='Andrew Grigorev',
    author_email='andrew@ei-grad.ru',
    url='https://github.com/ei-grad/bincount',
    ext_modules=cythonize(ext_modules, language_level=2),
)
