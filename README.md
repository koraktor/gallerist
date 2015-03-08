Gallerist
=========

Gallerist is a web application to browse libraries of Apple’s Photos app. It is
built on top of [Sinatra][sinatra].

## Requirements

 * One or more Photos libraries (`.photoslibrary` directories)
 * Ruby 2.x with Bundler
 
OS X 10.9 and above ship with Ruby 2.0. You will only have to install Bundler
(`gem install bundler`) to get started.

## Installation

Currently, there’s no sophisticated installation implemented (or required). A
simple clone of the repository and installation of all dependencies is
sufficient:

```shell
$ git clone https://github.com/koraktor/gallerist
$ cd gallerist
$ bundle install
```

## Usage

```shell
$ bin/gallerist ~/Pictures/Photos\ Library.photoslibrary
```

## Caveats

 * iPhoto libraries work to a certain degree. But especially the full versions
   of the photos do not work, yet. Additionally, iPhoto’s events are not
   listed, only albums.
 * Gallerist works on a copy of the library databases, i.e. changes to the
   original library will not be reflected instantly. You will have to restart
   the web app first.

## Future plans

 * Support for internal categories like photo stream and videos
 * Support for moments, faces and places
 * Performance improvements
 * Easier installation, e.g. through [Homebrew][brew]

 [brew]: http://brew.sh
 [sinatra]: http://www.sinatrarb.com
