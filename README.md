Hornet is a simple image-processing utility for the Arbesko.com website.

The overall architecture consists of the following:

- a directory that contains high-resolution & transparent PNG images.
- hornet running in a daemon fashion which will listen to the aforementioned directory, process the images that are added, and output various sizes/types to the `/public` directory to be served.
- nginx running on a dedicated domain (images.arbesko.se) which serves the `/public` directory of this application.

Note: This is a very early/alpha release. It's running in production but has not been fine-tuned or optimized for performance or reliability.

### Docker

The Arbesko web platform consists of a handful of services, all running in different environments. The web application is PHP, the file server is Python, and this application, hornet, is written in Ruby.

To avoid library conflicts and reduce the complexity of deployment and operations management, Hornet was designed with the presumption that it would run inside an isolated linux container (powered by docker)

### Quickstart

Assuming you have `docker` installed and running, the following commands will Hornet running pretty quickly. This is a real-world example, so it will need to be modified to your particular use-case.

    cd /var/www
    
    git clone git@github.com:whalesalad/arbesko-hornet.git hornet && cd hornet
    
The command that actually runs the docker container is below:

    sudo docker run -v `pwd`:/hornet -v /home/arbesko/web-images:/images -w /hornet -d whalesalad/ruby-base /bin/bash -l -c "bundle install && rake && bundle exec bin/hornet --force -d /images"

Let's break this down piece-by-piece, we start with the baseline command for running a docker container.

    sudo docker run

The next bit will mount the current directory (indicated by `pwd`) as the `/hornet` directory *inside of the container*. This is required so that we have the application code inside of the image. Code *could* be packaged with the container, but i'm currently enjoy this flexibility. 

    -v `pwd`:/hornet

Then we also want to mount the directory of images that needs to be processed. This lives in the host filesystem and is modified by Arbesko employees via SFTP:

    -v /home/arbesko/web-images:/images

Then we'd like to change the working directory to our application:

    -w /hornet

Next comes the slug of the image that we're going to be use to spin-up the Docker container, in this case my personal `whalesalad/ruby-base` image which contains Ruby 2.0.0-p247 and a handful of image processing libraries like imagemagick, libpng, etc...

    whalesalad/ruby-base

Finally, we're able to pass the desired command that will run inside of this container. This runs bash with a login shell (to load our rbenv ENV dependencies), and `-c` lets us pass a command to run

    /bin/bash -l -c 

The command that we are currently using is below:

    "bundle install && rake && bundle exec bin/hornet --force -d /images"

This will run bundle install to get the latest gems, rake to run the default setup task in the `Rakefile` (bootstraps some needed work directories) and finally runs the `hornet` binary via bundle exec so that all the gems are available. 

### bin/hornet

The hornet binary (located in `bin/hornet`) accepts two arguments:

- `-d DIRECTORY` – which sets the directory of images to watch/process
- `--force` – will start the hive and will force the re-processing of all the images contained. Useful for the first time you run the tool. 
