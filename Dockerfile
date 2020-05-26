# Well commented docker file to generate a Unirender CDN image
# Before use, you should have cloned the github files into a directory called "forking-cdn" on the target machine
# Make sure your server is large enough. GKE N1 will run (1 virtual CPU and 3.75 GB of memory)
# start with a debian linux operating system
From debian
# copy the code
COPY /unirender-cdn /home/cdn
# enter the forking-cdn folder
WORKDIR /home/cdn
# update the system 
# -y will say yes to all install confirmations -q idk
RUN apt-get update -yq \
# install curl so we can install other stuff with curl
&& apt-get install curl gnupg -yq \
# install build essentials to fix "make" module error
&& apt-get install build-essential -yq \
# download nodejs version 10
&& curl -sL https://deb.nodesource.com/setup_10.x  | bash \
# install nodejs + npm 
&& apt-get install nodejs -yq \
# install node-gym
&& npm install -g node-gyp -yp \
# this wasnt included in the package.json so I'll thow it in here
&& npm install @fly/edge --save -yq\
# install yarn
&& npm install -g yarn -yq \
# We are now done with the specific installations. 
# Install all the  things mentioned in the included package.json file. Force to reinstall stuff already installed.
# I tried doing this with yarn but it failed for some reason ¯\_(ツ)_/¯
&& npm install --force
# Start the application with "yarn start"
CMD [ "yarn", "start" ]
# The application server the website on port 3000 so lets expose that port
EXPOSE 3000
