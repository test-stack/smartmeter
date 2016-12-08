# Author: Radim Daniel Pánek <rdpanek@gmail.com>
#
# make build  - build new image from Dockerfile


NAME=rdpanek/smartmeter
VERSION=1.3.1
PARAM=$(filter-out $@,$(MAKECMDGOALS))
SMARTMETER_PATH=/home/SmartMeter_1.3.0_linux/

default:
	@echo Please use \'make run Testplan.jmx\'

build:
	docker build --tag $(NAME):$(VERSION) .

run:
	docker run --rm --name smartmeter \
	-v `pwd`:$(SMARTMETER_PATH)tests/ \
	-v `pwd`:$(SMARTMETER_PATH)logs/ \
	-v `pwd`:$(SMARTMETER_PATH)results/ \
	-v `pwd`/custom/:$(SMARTMETER_PATH)custom/ \
	$(NAME):$(VERSION) $(PARAM)
