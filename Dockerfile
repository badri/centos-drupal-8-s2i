FROM centos:centos7

LABEL maintainer="Lakshmi Narasimhan <lakshmi@lakshminp.com>"

ENV NGINX_VERSION=1.6.3 \
    HOME=/opt/app-root/src

LABEL io.k8s.description="Base image for Drupal 8" \
      io.k8s.display-name="OpenShift Drupal 8" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder, Nginx, php-fpm, php-7.1, Drupal 8"

RUN yum install -y epel-release && \
    yum install -y --setopt=tsflags=nodocs nginx && \
    yum clean all

RUN sed -i 's/80/8080/' /etc/nginx/nginx.conf
RUN sed -i 's/user nginx;//' /etc/nginx/nginx.conf

COPY ./s2i/bin/ /usr/libexec/s2i

COPY ./files/nginx.conf /etc/nginx/
COPY ./files/drupal /etc/nginx/conf.d/

RUN chown -R 1001:1001 /usr/share/nginx
RUN chown -R 1001:1001 /var/log/nginx
RUN chown -R 1001:1001 /var/lib/nginx
RUN touch /run/nginx.pid
RUN chown -R 1001:1001 /run/nginx.pid
RUN chown -R 1001:1001 /etc/nginx
RUN mkdir -p ${HOME} \
    && chown -R 1001:1001 ${HOME}

WORKDIR ${HOME}

USER 1001

EXPOSE 8080

CMD ["/usr/libexec/s2i/usage"]
