SHELL := /bin/bash

# Project variables
VENV_NAME?=venv
PYTHON=${VENV_NAME}/bin/python
TF_SECRETS_BUCKET_NAME=seantcanavan-tf-secrets-bucket-integration
TF_SECRETS_FILE_NAME=secrets.tfvars
TF_DIRECTORY_NAME=tf

# Default target executed when no arguments are given to make.
default: venv

.PHONY: venv
venv:
	python3 -m venv $(VENV_NAME)
	source venv/bin/activate && pip3 install --upgrade pip && pip3 install pipenv && pipenv install

.PHONY: run
run:
	source venv/bin/activate && source .env && python3 manage.py runserver

.PHONY: clean
clean:
	rm -rf $(VENV_NAME)
	find . -type f -name '*.pyc' -delete
	find . -type f -name '*.pyo' -delete
	find . -type f -name '*~' -delete
	find . -type d -name '__pycache__' -delete

deps:
	sudo pacman -Syu --needed terraform
	terraform -chdir=tf/ init

.PHONY: test
test:
	$(PYTHON) manage.py test


tf_init:
	terraform -chdir=tf/ init -var-file=$(TF_SECRETS_FILE_NAME)

tf_up:
	aws s3 cp $(TF_DIRECTORY_NAME)/$(TF_SECRETS_FILE_NAME) s3://$(TF_SECRETS_BUCKET_NAME)/$(TF_SECRETS_FILE_NAME)     # Copy item.txt to the S3 bucket

# tf_down will download the terraform secrets file to your local disk. if your local is newer than the remote, it will prompt before overriding
tf_down:
	@echo "Getting last modified time from S3"
	@aws s3api head-object --bucket $(TF_SECRETS_BUCKET_NAME) --key $(TF_SECRETS_FILE_NAME) | grep LastModified > /tmp/s3_last_modified.txt
	@if [ -f $(TF_DIRECTORY_NAME)/$(TF_SECRETS_FILE_NAME) ]; then \
	    echo "Checking last modified time of local file"; \
	    stat -c %y $(TF_DIRECTORY_NAME)/$(TF_SECRETS_FILE_NAME) > /tmp/local_last_modified.txt; \
	    if [ `cat /tmp/s3_last_modified.txt` \< `cat /tmp/local_last_modified.txt` ]; then \
	        read -p "Remote file is older than local file. Continue to overwrite local file? [y/N] " response; \
	        if [ "$$response" = "y" ] || [ "$$response" = "Y" ]; then \
	            echo "Overwriting local file"; \
	            aws s3 cp s3://$(TF_SECRETS_BUCKET_NAME)/$(TF_SECRETS_FILE_NAME) $(TF_DIRECTORY_NAME)/$(TF_SECRETS_FILE_NAME); \
	        else \
	            echo "Not overwriting local file"; \
	        fi; \
	    else \
	        echo "Downloading from S3"; \
	        aws s3 cp s3://$(TF_SECRETS_BUCKET_NAME)/$(TF_SECRETS_FILE_NAME) $(TF_DIRECTORY_NAME)/$(TF_SECRETS_FILE_NAME); \
	    fi; \
	else \
	    echo "Local file does not exist. Downloading from S3."; \
	    aws s3 cp s3://$(TF_SECRETS_BUCKET_NAME)/$(TF_SECRETS_FILE_NAME) $(TF_DIRECTORY_NAME)/$(TF_SECRETS_FILE_NAME); \
	fi




tf_plan:
	terraform -chdir=tf/ plan -var-file=$(TF_SECRETS_FILE_NAME)

tf_apply:
	terraform -chdir=tf/ apply -var-file=$(TF_SECRETS_FILE_NAME)

tf_destroy:
	terraform -chdir=tf/ destroy -var-file=$(TF_SECRETS_FILE_NAME)
