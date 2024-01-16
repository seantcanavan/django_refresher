#!/bin/bash
echo "run python3 manage.py collectstatic"
pipenv run python3 manage.py collectstatic
echo "pipenv run python3 manage.py test"
pipenv run python3 manage.py test
echo "pipenv run python3 manage.py makemigrations"
pipenv run python3 manage.py makemigrations
echo "pipenv run python3 manage.py migrate"
pipenv run python3 manage.py migrate
echo "pipenv run gunicorn --workers 2 mysite.wsgi"
pipenv run gunicorn --workers 2 mysite.wsgi
