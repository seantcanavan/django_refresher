#!/bin/bash
pipenv run python3 manage.py collectstatic
pipenv run python3 manage.py test
pipenv run python3 manage.py makemigrations
pipenv run python3 manage.py migrate
gunicorn --workers 2 mysite.wsgi
