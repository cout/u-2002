u-2002
======

An irc bot written using Cinch

This bot differs from other Cinch-based bots in a few specific ways:

* I've tried to unit test as much of the code as possible.  Cinch doesn't lend itself to unit testing as much as I would like, but it's easy enough.
* There's a command interface which reads from stdin and processes commands typed on the console.
* There's a reload plugin which causes all plugins to be reloaded when the /reload command is issued.
