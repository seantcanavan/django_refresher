#!/bin/bash
pipenv run gunicorn mysite.wsgi --log-file -
