#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-09 15:30:18 +0000 (Mon, 09 Feb 2015)
#
#  vim:ts=2:sw=2:et
#
NAME=serf
AUTHOR=gambol99

.PHONY: build

build:
	docker build -t ${AUTHOR}/${NAME} .
