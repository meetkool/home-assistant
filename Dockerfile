# Todo:
#   * Renovate music-assistant

# https://hub.docker.com/r/homeassistant/home-assistant/tags
FROM homeassistant/home-assistant:2023.4.4

# renovate: datasource=repology depName=alpine_3_16/gcc
ENV GCC_VERSION="11.2.1_git20220219-r2"
# renovate: datasource=repology depName=alpine_3_16/musl-dev
ENV MUSL_DEV_VERSION="1.2.3-r2"
# renovate: datasource=repology depName=alpine_3_16/zlib-dev
ENV ZLIB_DEV_VERSION="1.2.12-r3"
# renovate: datasource=repology depName=alpine_3_16/jpeg-dev
ENV JPEG_DEV_VERSION="9d-r1"

WORKDIR /tmp
# https://github.com/music-assistant/hass-music-assistant/releases/
ADD https://github.com/music-assistant/hass-music-assistant/releases/download/v2022.11.0/mass.zip /tmp
COPY poetry.lock pyproject.toml ./
RUN mkdir -p /tmp/custom_components/mass \
  && unzip /tmp/mass.zip -d /tmp/custom_components/mass \
  && ls -al /tmp/custom_components/mass \
  && apk add --no-cache --virtual .build-deps \
       gcc=$GCC_VERSION \
       g++=$GCC_VERSION \
       musl-dev=$MUSL_DEV_VERSION \
       zlib-dev=$ZLIB_DEV_VERSION \
       jpeg-dev=$JPEG_DEV_VERSION \
  # https://pypi.org/project/poetry/
  && pip install --no-cache-dir poetry==1.4.0 \
  && poetry config virtualenvs.create false \
  && poetry install \
  && apk del .build-deps gcc g++ musl-dev zlib-dev jpeg-dev
