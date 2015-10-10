# Vorpal - Log

[![Build Status](https://travis-ci.org/AljoschaMeyer/vorpal-log.svg)](https://travis-ci.org/AljoschaMeyer/vorpal-log)

A [Vorpal.js](https://github.com/dthree/vorpal) extension adding simple logging methods.

### Installation

```bash
npm install vorpal-log
npm install vorpal
```

### Getting Started

TODO add example usage
```js
const vorpal = require('vorpal')();
const vorpalLogger = require('vorpal-less');

vorpal
  .delimiter('log-example~$')
  .use(vorpalLogger)
  .show();


```

TODO paste actual output once implemented
```bash
$ node log-example.js
log-example~$ test
```

### Default Functionality

Vorpal-log comes with the following predefined methods for logging:

- `logger.debug(msg)` (loglevel 10)
- `logger.log(msg)` (loglevel 20)
- `logger.info(msg)` (loglevel 20)
- `logger.confirm(msg)` (loglevel 20)
- `logger.warn(msg)` (loglevel 30)
- `logger.error(msg)` (loglevel 40)
- `logger.fatal(msg)` (loglevel 50)

Set the loglevel:

`logger.setFilter(level)`

E.g. `logger.setFilter('warn')` will only print messages via logger.warn, logger.error and logger.fatal.

### Customizing

##### logger.addFormatter(name, level, format)
Creates a `logger[name]` function, which will log the result of `format(msg)` with loglevel `level`. Use this to add custom formatters.

##### logger.setFilter(filter)
Takes either a custom filter function, a string, or a number.

When logging something, the formatter is passed to the function set by `logger.setFilter`. Logging only happens if this function returns true.

If `logger.setFilter` is passed a function, this function is the new filter function.

If passed a number, the new filter function will only log, if `formatter.level` is greater than or equal to that number.

If passed a string, the new filter function will only log if `formatter.level` is greater than or equal to `formatters[filter].level`.
