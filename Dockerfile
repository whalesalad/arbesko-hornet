FROM whalesalad/ruby-base
MAINTAINER Michael Whalen <michael@whalesalad.com>

# Set some environment variables for rbenv
ENV RBENV_ROOT /usr/local/rbenv
ENV PATH $RBENV_ROOT/bin:/hornet/bin:$PATH

# cd into the /hornet dir
WORKDIR /hornet

# use the local git repo for the contents of /hornet in the container
ADD . /hornet

# Bootstrap rbenv
RUN /bin/bash -l -c eval $(rbenv init -)

# Install required gems
RUN /bin/bash -l -c bundle install

# Run rake to setup the required folders for image processing
RUN /bin/bash -l -c bundle exec rake

# Finally, assuming /images is mounted from the host, run the hornet executable
# This is done with /bin/bash -l -c to ensure that the rbenv environment is correct.
ENTRYPOINT ["hornet"]

CMD ["-d", "/images"]