box-scipy-base
==============

A wercker box for numpy, scipy and pandas.

By using the same script as [step-virtualenv](https://github.com/wercker/step-virtualenv), this box pre-installs numpy, scipy and pandas in virtualenv.
If you want to pre-install any other python packages, just fork this box and configure pip statements.


License
=======

The MIT License (MIT)


Changelog
=========

0.1.3
-----

* enabled virtualenv in box building process
* pre-installed numpy==1.8.1, scipy==0.14.0 and pandas==0.14.1
