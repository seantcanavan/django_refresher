#!/bin/bash
python mysite/manage.py collectstatic && gunicorn --workers 2 myproject.wsgi
