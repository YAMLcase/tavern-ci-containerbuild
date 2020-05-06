FROM python:3.7-alpine

RUN apk add git
RUN pip install --upgrade pip
RUN pip install pytest
RUN pip install pytest-sugar
RUN pip install pytest-xdist
RUN pip install tavern
WORKDIR /data
# ENTRYPOINT ["tavern-ci"]

