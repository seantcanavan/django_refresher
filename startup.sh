#!/bin/bash
pip3 install --upgrade pip
pip3 install pipenv
pipenv install
pipenv run gunicorn mysite.wsgi --log-file -
