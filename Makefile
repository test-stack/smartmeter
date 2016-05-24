# Author: Radim Daniel Pánek <rdpanek@gmail.com>
#
# make build  - build new image from Dockerfile


NAME=rdpanek/smartmeter
VERSION=1.1.0.5
PARAM=$(filter-out $@,$(MAKECMDGOALS))
SMARTMETER_PATH=/srv/var/SmartMeter_1.1.0L_Light/sm-linux-light-full-1.1.0/


default:
	@echo Please use \'make build\'

build:
	docker build --rm -t $(NAME):$(VERSION) .

run:
	docker run --rm --name smartmeter \
	-v `pwd`:$(SMARTMETER_PATH)tests/ \
	-v `pwd`:$(SMARTMETER_PATH)logs/ \
	-v `pwd`:$(SMARTMETER_PATH)results/ \
	-v `pwd`/custom/:$(SMARTMETER_PATH)custom/ \
	$(NAME):$(VERSION) $(PARAM)
