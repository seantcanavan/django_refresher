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
venv: $(VENV_NAME)/bin/activate

$(VENV_NAME)/bin/activate: requirements.txt
	test -d $(VENV_NAME) || python3 -m venv $(VENV_NAME)
	${PYTHON} -m pip install -r requirements.txt
	touch $(VENV_NAME)/bin/activate

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
	$(PYTHON) ./mysite/manage.py test



tf_init:
	terraform -chdir=tf/ init -var-file=$(TF_SECRETS_FILE_NAME)

tf_up:
	aws s3 cp $(TF_DIRECTORY_NAME)/$(TF_SECRETS_FILE_NAME) s3://$(TF_SECRETS_BUCKET_NAME)/$(TF_SECRETS_FILE_NAME)     # Copy item.txt to the S3 bucket

# tf_down will download the terraform secrets file to your local disk. if your local is newer than the remote, it will prompt before overriding
tf_down:
	# Get the last modified time of the item in the S3 bucket
	@aws s3api head-object --bucket my-test-rsync-versioned-bucket --key item.txt | grep LastModified > /tmp/s3_last_modified.txt
	# Get the last modified time of the local item
	@stat -c %y item.txt > /tmp/local_last_modified.txt
	# Compare and prompt if needed
	@if [ `cat /tmp/s3_last_modified.txt` \< `cat /tmp/local_last_modified.txt` ]; then \
	    read -p "Remote file is older than local file. Continue to overwrite local file? [y/N] " response; \
	    if [ "$$response" = "y" ] || [ "$$response" = "Y" ]; then \
	        aws s3 cp s3://my-test-rsync-versioned-bucket/item.txt item.txt; \
	    fi; \
	else \
	    aws s3 cp s3://my-test-rsync-versioned-bucket/item.txt item.txt; \
	fi

tf_plan:
	terraform -chdir=tf/ plan -var-file=$(TF_SECRETS_FILE_NAME)

tf_apply:
	terraform -chdir=tf/ apply -var-file=$(TF_SECRETS_FILE_NAME)

tf_destroy:
	terraform -chdir=tf/ destroy -var-file=$(TF_SECRETS_FILE_NAME)
