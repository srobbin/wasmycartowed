# Was My Car Towed?

This repository serves as an introduction to programming with the [City of Chicago's data portal](http://data.cityofchicago.org/). It uses [Windy](https://github.com/Chicago/windy), a Ruby library that provides a simple interface to querying [Socrata](http://www.socrata.com/) datasets, and [Sinatra](http://www.sinatrarb.com/) an easy-to-follow framework for creating websites.

## Development

Assuming that you having [Ruby](http://www.ruby-lang.org/), [Bundler](http://gembundler.com/), and [Git](http://git-scm.com/) installed:

    # Clone the repository to your computer
    git clone git@github.com:srobbin/wasmycartowed.git
    cd wasmycartowed

    # Install the dependencies
    bundle install

    # Register for an app token at https://data.cityofchicago.org/
    # then add it to to the config file
    cp config.yml.example config.yml

    # Start the development web server
    # The web page will be viewable at http://127.0.0.1:8080
    unicorn