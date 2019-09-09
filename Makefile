SHELL += -eu

BLUE	:= \033[0;34m
GREEN	:= \033[0;32m
RED   := \033[0;31m
NC    := \033[0m

login:
	$$(aws ecr get-login --no-include-email --region eu-west-1 $(profile))

build:
	aws cloudformation package --template-file master.yml --s3-bucket $(profile)-deploy-repo --s3-prefix production/ecs/master --output-template-file master.pack.yml --profile $(profile)

test: build
	@echo "${GREEN}✓ Testing stack before deploying...${NC}\n"
	aws cloudformation deploy --template-file master.pack.yml --stack-name MW-MGM --capabilities CAPABILITY_NAMED_IAM --no-execute-changeset --region eu-west-1 --profile $(profile)

deploy: build
	@echo "${GREEN}✓ Deploying stack ${NC}\n"
	aws cloudformation deploy --template-file master.pack.yml --stack-name MW-MGM --capabilities CAPABILITY_NAMED_IAM --region eu-west-1 --profile $(profile)

delete:
	aws cloudformation delete-stack --stack-name MW-MGM --region eu-west-1 --profile $(profile)

protection:
	aws cloudformation update-termination-protection --enable-termination-protection --stack-name MW-MGM --region eu-west-1 --profile $(profile)

include makefiles/*.mk

.DEFAULT_GOAL := help
.PHONY: deploy