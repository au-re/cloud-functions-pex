FROM gcr.io/google-appengine/nodejs

RUN apt-get -y update
RUN apt-get -y install python-setuptools

RUN easy_install pip
RUN pip install --upgrade pip wheel pex

COPY init.sh init.sh

CMD ["/bin/bash", "init.sh"]
