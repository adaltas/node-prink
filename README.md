[![Build Status](https://secure.travis-ci.org/adaltas/node-prink.png)](http://travis-ci.org/adaltas/node-prink)

Prink is a Node.js used to format filesize and file mode. Other convertions will
be made available on demand such as file permissions and dates.

## Usage

Install Prink with NPM: `npm install prink` and requires it inside your scripts:

```
prink = require 'prink'
```

All the convertions supported by Prink can format, parse and compare values.

## File Size

Additionnal properties may be chained such as "bit" and any unit from "kilobytes"
to "yottabytes", from "kilobits" to "yottabits", "KB" to "YB", "Kb" to "Yb".

To format a number, you may call directly `filesize` or `filesize.format`.

```
prink.filesize(12382232) === '11 MB'
prink.filesize.bit(12382232) === '94 Mb'
prink.filesize.to.kilobytes(12382232, 2) === '12092.02 KB'
prink.filesize.from.KB.to.MB(12832, 2) === '12.53 MB'
prink.filesize.to.Mb(12382232, 2) === '94.47 Mb'
```

To parse a string into a number, you may call `filesize.parse`.

```
prink.filesize.parse('120 KB') === 123820
prink.filesize.parse.to.megabytes('120 KB') === 0.1171875
prink.filesize.parse.bit('120 KB') === 990560
```

To compare a string or a number, you may call `filesize.compare`.

```
prink.filesize.compare('120 KB', 123820) === true
```

## Mode

```
prink.mode(420) === '644'
prink.mode(1023) === '1777'
prink.mode.parse('1777') === 1023
prink.mode.compare('0644', 420) === true
```
