#!/bin/bash
python3 mysite/manage.py collectstatic && gunicorn --workers 2 mysite.mysite.wsgi
