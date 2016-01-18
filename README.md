# all-in-one-hackazon

Run a docker container include hackazon, apache, and mysql

This work is based on https://github.com/jbfink/docker-wordpress, but includes https://github.com/rapid7/hackazon instead of wordpress.

For more information on multiple processes inside of the same Docker container, see
http://tech.paulcz.net/2014/12/multi-process-docker-images-done-right/


# Instructions

To build the container:
docker build --rm -t mutzel/all-in-one-hackazon .

then run via: 
docker run --name hackazon -d -p 80:80  mutzel/all-in-one-hackazon

Login into hackazon at https:// (( your host here... )) :80 and begin configuring...

See https://hub.docker.com/r/mutzel/all-in-one-hackazon/

The latest tag is a snapshot of the container after the configuration steps have been completed.  In that snapshot, the passwords are as listed here: https://hub.docker.com/r/mutzel/all-in-one-hackazon/