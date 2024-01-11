#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys


def main():
    """Run administrative tasks."""
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'mysite.settings')

    DATABASE_USER = os.getenv("DATABASE_USER")
    DATABASE_PASS = os.getenv("DATABASE_PASS")
    DATABASE_HOST = os.getenv("DATABASE_HOST")

    print("MANAGE.PY: printing database creds")
    print(DATABASE_USER, DATABASE_PASS, DATABASE_HOST)

    print("MANAGE.PY: printing all environment variables")
    # Iterating over all environment variables and their values
    for key, value in os.environ.items():
        print(f"{key}: {value}")

    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
    execute_from_command_line(sys.argv)


if __name__ == '__main__':
    main()
