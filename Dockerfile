FROM python:3.4-slim

RUN mkdir /celery && groupadd celery && useradd --create-home --home-dir /home/celery --base-dir /celery -g celery celery
WORKDIR /celery

RUN pip install redis

ENV CELERY_VERSION 3.1.18

RUN pip install celery=="$CELERY_VERSION"

# --link some-rabbit:rabbit "just works"
RUN { \
	echo 'import os'; \
	echo "BROKER_URL = os.environ.get('CELERY_BROKER_URL', 'amqp://guest@rabbit')"; \
} > celeryconfig.py

ENV CELERY_CONFIG_MODULE celeryconfig

USER celery
CMD celery worker --config=${CELERY_CONFIG_MODULE}
