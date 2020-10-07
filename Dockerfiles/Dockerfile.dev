FROM python:3.8.5-alpine

RUN apk add git
RUN pip install --upgrade pip
RUN pip install pytest
RUN pip install pytest-sugar
RUN pip install pytest-xdist
RUN pip install tavern
RUN pip install --upgrade git+https://github.com/yaml/pyyaml.git@override-anchor
WORKDIR /data
ENTRYPOINT ["tavern-ci"]

