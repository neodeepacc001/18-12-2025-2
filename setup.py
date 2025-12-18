#!/usr/bin/env python
"""Setup script for browser-use binder environment."""

from setuptools import setup, find_packages

setup(
    name="browser-use-binder",
    version="0.1.0",
    description="Browser Use environment for MyBinder",
    author="Your Name",
    packages=find_packages(),
    install_requires=[
        line.strip() for line in open('requirements.txt').readlines()
        if line.strip() and not line.startswith('#')
    ],
    python_requires='>=3.10',
)
