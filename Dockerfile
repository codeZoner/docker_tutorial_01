################################################
# Change Node Version as necessary
# https://hub.docker.com/_/node/tags
################################################
FROM node:18.16.0

################################################
# Install GIT Package
################################################
RUN apt-get update && apt-get install git -y

################################################
# Create & set working directory
################################################
RUN apt-get clean autoclean
RUN apt-get autoremove --yes
RUN rm -rf /var/lib/{apt,dpkg,cache,log}/

################################################
# Using Bun as the package Manager
# !you can replace with any other package manager)
# !If changed then update the entry_point.sh script
################################################
RUN npm i -g bun

################################################
# Copying over the script that will be executed on
# starting the container
################################################
COPY ./entry_point.sh /entry_point.sh
RUN chmod +x /entry_point.sh
RUN chown node /entry_point.sh

################################################
# Copy repo to working directory
################################################
WORKDIR /app
COPY --chown=node:node webroot/ .
RUN chown node /app

################################################
# Copy ssh key to .ssh folder & set required
# file permissions & set user's group
################################################
RUN mkdir /home/node/.ssh
COPY .ssh/id_rsa /home/node/.ssh/id_rsa
COPY .ssh/id_rsa.pub /home/node/.ssh/id_rsa.pub

RUN chmod 600 /home/node/.ssh/id_rsa && chmod 600 /home/node/.ssh/id_rsa.pub
RUN ssh-keyscan gitlab.com >>/home/node/.ssh/known_hosts

RUN chown node -R /home/node
USER node

################################################
# Label Your Image
################################################
LABEL Name="My Next.js/NodeJs Server Image"
LABEL Version="1.0.0"

################################################
# Expose port(s) for external access
################################################
EXPOSE 8080

################################################
# Command to be executed when running a container
# from an image
################################################
CMD ["/entry_point.sh"]
