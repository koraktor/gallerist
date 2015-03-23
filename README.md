Gallerist
=========

[![Gem Version](https://badge.fury.io/rb/gallerist.svg)](http://badge.fury.io/rb/gallerist)
[![Dependency Status](https://gemnasium.com/koraktor/gallerist.svg)](https://gemnasium.com/koraktor/gallerist)

Gallerist is a web application to browse libraries of Apple Photos and iPhoto.
It is built on top of [Sinatra][sinatra].

## Requirements

 * One or more Photos or iPhoto libraries (`.photoslibrary` or `.photolibrary`
   directories)
 * Ruby 2.x

OS X 10.9 and above ship with Ruby 2.0. Ruby 1.9 probably works, but won’t be
supported.

## Installation

Gallerist can be simply installed as a Ruby gem.

```shell
$ gem install gallerist
```

*Note*: You might need to use `sudo` if you’re installing into your system
Ruby, e.g. when not using rbenv or RVM.

If you want to run the current development code please use Git to clone the
repository.

## Usage

```shell
$ bin/gallerist ~/Pictures/Photos\ Library.photoslibrary
```

After that the application is served on port 9292 by default. You can open it
by simply browsing to `http://localhost:9292`.

Further command-line arguments are available, see `gallerist --help` for more
information.

## Caveats

 * iPhoto libraries work to a certain degree as iPhoto’s events are not
   listed, only albums.
 * Gallerist works on a copy of the library databases, i.e. changes to the
   original library will not be reflected instantly. You will have to restart
   the web app first.

## Future plans

 * Support for internal categories like photo stream and videos
 * Support for moments and places
 * Performance improvements

 [brew]: http://brew.sh
 [sinatra]: http://www.sinatrarb.com
