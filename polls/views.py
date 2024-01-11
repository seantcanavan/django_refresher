import os

from django.http import HttpResponse


def index(request):
    DATABASE_USER = os.getenv("DATABASE_USER")
    DATABASE_PASS = os.getenv("DATABASE_PASS")
    DATABASE_HOST = os.getenv("DATABASE_HOST")
    return HttpResponse(f"Hello, world. You're at the polls index. {DATABASE_USER} and {DATABASE_PASS} and {DATABASE_HOST}.")


def detail(request, question_id):
    return HttpResponse("You're looking at question %s." % question_id)


def results(request, question_id):
    response = "You're looking at the results of question %s."
    return HttpResponse(response % question_id)


def vote(request, question_id):
    return HttpResponse("You're voting on question %s." % question_id)
