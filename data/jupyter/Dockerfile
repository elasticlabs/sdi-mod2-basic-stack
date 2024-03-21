#FROM jupyter/minimal-notebook

FROM ubuntu:jammy
LABEL maintainer="Just van den Broecke <justb4@gmail.com>"

# ARGS
ARG TZ="Etc/UTC"
ARG LANG="en_US.UTF-8"
ARG ADD_DEB_PACKAGES=""
ARG ADD_PIP_PACKAGES=""

# ENV settings
ENV TZ=${TZ} \
	LANG=${LANG} \
	DEBIAN_FRONTEND="noninteractive" \
	DEB_BUILD_DEPS="gpg-agent software-properties-common build-essential apt-utils python3-dev libproj-dev" \
	DEB_PACKAGES="locales locales-all proj-bin python3-shapely python3-pyproj python3-setuptools python3-pip python3-gdal python3-fiona python3-rasterio ${ADD_DEB_PACKAGES}" \
	PROJ_DIR="/usr"

# FROM quay.io/jupyter/base-notebook
# RUN pip install --no-cache-dir matplotlib scikit-learn

COPY ./requirements.txt /jupyter/requirements.txt
#RUN pip install --no-cache-dir -r /tmp/requirements.txt

RUN \
    # Install dependencies
    apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y --fix-missing --no-install-recommends ${DEB_BUILD_DEPS}  \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable && apt-get update -y \
    && apt-get --no-install-recommends install -y ${DEB_PACKAGES} \
    && update-locale LANG=${LANG} \
    && echo "For ${TZ} date=$(date)" && echo "Locale=$(locale)" \
	&& pip3 install -r /jupyter/requirements.txt \
	&& if [ ${ADD_PIP_PACKAGES} != "" ] ; then pip3 install ${ADD_PIP_PACKAGES}; fi \
	&& apt-get remove --purge ${DEB_BUILD_DEPS} -y \
	&& apt autoremove -y  \
	&& rm -rf /var/lib/apt/lists/* 
	# Patch for now until https://github.com/jupyter-widgets/ipyleaflet/issues/865 solved in version
	# && sed -i /usr/local/lib/python3.10/dist-packages/ipyleaflet/basemaps.py -e 's/com\/\/tiles/com\/tiles/g'

COPY ./entrypoint.sh /jupyter/start.sh

WORKDIR /jupyter/content/notebooks
ENTRYPOINT ["/jupyter/start.sh"]