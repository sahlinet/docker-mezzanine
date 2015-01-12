# Start from following image
FROM philipsahli/centos

# Create user
RUN useradd -m -d /home/mezzanine -s /bin/bash mezzanine 

# Nginx
RUN rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
RUN yum install -y nginx
ADD nginx.conf /etc/nginx/conf.d/site.conf
RUN rm /etc/nginx/conf.d/default.conf

# Add application
ADD testsite /testsite
ADD startup_app.sh /startup_app.sh
RUN chmod 755 /startup_app.sh

# Create virtualenv and install requirements
RUN yum install -y python-virtualenv postgresql-devel gcc
RUN yum install -y libxslt-devel libxml2-devel
RUN mkdir /home/mezzanine/.virtualenvs
RUN virtualenv --no-site-packages /home/mezzanine/.virtualenvs/myenv
RUN /home/mezzanine/.virtualenvs/myenv/bin/pip install -r /testsite/requirements.txt
RUN /home/mezzanine/.virtualenvs/myenv/bin/pip install gunicorn

# Startup
ADD start.conf /etc/supervisor/conf.d/start.conf

# Permissions
RUN chown -R mezzanine:mezzanine /home/mezzanine/
RUN chmod 755 /home/mezzanine/

RUN yum remove -y gcc
RUN yum clean all

EXPOSE 80
CMD ["/startup.sh"]
