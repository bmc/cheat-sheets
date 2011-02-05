title: Python Cheat Sheet

## Setuptools

Messages like this:

    /home/bmc/python/lib/python2.5/site-packages/zope.interface-3.4.1-py2.5-linux-i686.egg/zope/__init__.py:3:
    UserWarning: Module _mysql was already imported from
    /var/lib/python-support/python2.5/_mysql.so, but
    /var/lib/python-support/python2.5 is being added to sys.path

can happen when packages use setuptools. To suppress them, create a
`sitecustomize.py` file in your `site-packages` directory, containing:

    import warnings
    warnings.filterwarnings('ignore',
                            message=r'Module .*? is being added to sys\.path',
                            append=True)

