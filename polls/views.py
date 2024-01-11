import os

from django.http import HttpResponse


def index(request):
    DATABASE_USER = os.getenv("DATABASE_USER")
    DATABASE_PASS = os.getenv("DATABASE_PASS")
    DATABASE_HOST = os.getenv("DATABASE_HOST")
    return HttpResponse(f"Hello, world. You're at the polls index. {DATABASE_USER} and {DATABASE_PASS} and {DATABASE_HOST}.")
