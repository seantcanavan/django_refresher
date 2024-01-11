#!/bin/bash
python3 manage.py migrate && python3 manage.py collectstatic && gunicorn --workers 2 mysite.wsgi
