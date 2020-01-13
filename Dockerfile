# based on centos 8
FROM centos:8

# maintainer
MAINTAINER Tesao

# define env
ENV APPDIR /proj

# install packages
RUN yum -y upgrade
RUN yum -y install wget zip unzip nginx emacs
RUN yum -y install php php-common php-json php-xml php-pdo git

# add user
RUN useradd _www

# install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# install symfony
RUN wget https://get.symfony.com/cli/installer -O - | bash
RUN export PATH="$HOME/.symfony/bin:$PATH"
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

# open port
EXPOSE 8000

# git initialization for example
RUN git config --global user.email "example@example.work"
RUN git config --global user.name "Examlple name"

# make project folder
RUN symfony new proj --version=4.4

# define proj directory as a work directory
WORKDIR $APPDIR

# copy files
COPY light_saml_symfony_bridge.yaml $APPDIR/config/packages/light_saml_symfony_bridge.yaml
COPY framework.yaml $APPDIR/config/packages/framework.yaml
COPY services.yaml $APPDIR/config/services.yaml

# require lightsaml
RUN composer require lightsaml/sp-bundle
COPY metadata.xml $APPDIR/vendor/lightsaml/lightsaml/web/sp/metadata.xml

# require make-bundle
RUN composer require symfony/maker-bundle --dev

RUN mkdir $APPDIR/src/Security
COPY UserCreator.php $APPDIR/src/Security/UserCreator.php

# require symfony/twig-bundle
RUN composer require symfony/twig-bundle
