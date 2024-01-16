SHELL := /bin/bash

.PHONY: venv run clean deps tf_init tf_plan tf_apply tf_destroy

# Project variables
VENV_NAME?=venv
PYTHON3=${VENV_NAME}/bin/python3
PIP3=${VENV_NAME}/bin/pip3
TF_SECRETS_FILE_NAME=secrets.tfvars
TF_DIRECTORY_NAME=tf
stage ?= integration

# Default target executed when no arguments are given to make.
default: venv

venv:
	python3 -m venv $(VENV_NAME)
	source venv/bin/activate && pip3 install --upgrade pip && pip3 install pipenv && pipenv install

run:
	source venv/bin/activate && source .env && pipenv run python3 manage.py runserver

clean:
	rm -rf $(VENV_NAME)
	rm -f Pipfile.lock
	find . -type f -name '*.pyc' -delete
	find . -type f -name '*.pyo' -delete
	find . -type f -name '*~' -delete
	find . -type d -name '__pycache__' -delete

deploy:
	git checkout main && git pull --all --prune && git checkout django-integration && git reset --hard origin/main && git push -f && git checkout main

deps:
	sudo pacman -Syu --needed terraform
	terraform -chdir=tf/ init

migrations:
	source venv/bin/activate && source .env && pipenv run python3 manage.py makemigrations

migrate:
	source venv/bin/activate && source .env && pipenv run python3 manage.py migrate

.PHONY: test
test:
	source venv/bin/activate && pipenv run python3 manage.py test


# Function to determine the state file name
state_file = $(if $(filter $(stage),integration),terraform.tfstate,terraform.$(stage).tfstate)

tf_init:
	terraform -chdir=tf/ init -var-file=$(TF_SECRETS_FILE_NAME) -var "stage=$(stage)" -state=$(state_file)

tf_plan:
	terraform -chdir=tf/ plan -var-file=$(TF_SECRETS_FILE_NAME) -var "stage=$(stage)" -state=$(state_file)

tf_apply:
	terraform -chdir=tf/ apply -var-file=$(TF_SECRETS_FILE_NAME) -var "stage=$(stage)" -state=$(state_file)

tf_destroy:
	terraform -chdir=tf/ destroy -var-file=$(TF_SECRETS_FILE_NAME) -var "stage=$(stage)" -state=$(state_file)
