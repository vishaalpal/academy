COMPOSE_PATH = docker/docker-compose.yml
COMPOSE_ENV = docker-compose -f ${COMPOSE_PATH}
COMPOSE_RUN = ${COMPOSE_ENV} run --rm
TF_VARS=terraform.tfvars
TF_PLAN=terraform.tfplan
export DB_NAME?=DA_Serverless

##+MAKEFILE HELPER
##+
##+GENERAL COMMANDS
help: 				##+ Show Available commands.
	@fgrep -h "##+" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##+//'

##+
##+COMPOSE CMD
up:			##+ Builds the compose containers.
	${COMPOSE_ENV} up -d
down:   ##+ Downs the compose containers.
	${COMPOSE_ENV} down
build:			##+ Builds the compose containers.
	${COMPOSE_ENV} build

##+
##+ c06-serverless01
##+

init: ##+ Run terraform init.
	$(COMPOSE_RUN) terraform init
.PHONY: init

plan: init ##+ Run terraform plan.
	$(COMPOSE_RUN) terraform plan -var-file=$(TF_VARS) -out=$(TF_PLAN)
.PHONY: plan

deploy: put_ssm plan ##+ Run terraform apply.
	$(COMPOSE_RUN) terraform apply $(TF_PLAN)
.PHONY: apply

destroy: ##+ Run terraform destroy
	$(COMPOSE_RUN) terraform destroy -var-file=$(TF_VARS)
.PHONY: destroy

destroy_specific:
	$(COMPOSE_RUN) terraform destroy -target aws_iam_role.iam_for_lambda -var-file=$(TF_VARS)

put_ssm: ##+ Push SSM paramter
	$(COMPOSE_RUN) aws make _put_ssm
.PHONY: put_ssm

get_ssm: ##+ get SSM paramter
	$(COMPOSE_RUN) aws make _get_ssm
.PHONY: get_ssm

_put_ssm: ##+ Run push parameter script.
	bash scripts/ssm-put-parameter.sh
.PHONY: _put_ssm

_get_ssm: ##+ Run get parameter script.
	bash scripts/ssm-get-parameter.sh
.PHONY: _get_ssm