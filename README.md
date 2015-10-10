# Vorpal - Log

[![Build Status](https://travis-ci.org/AljoschaMeyer/vorpal-log.svg)](https://travis-ci.org/AljoschaMeyer/vorpal-log)

A [Vorpal.js](https://github.com/dthree/vorpal) extension adding simple logging methods.

### Installation

```bash
npm install vorpal-log
npm install vorpal
```

### Getting Started

```js
const vorpal = (require('vorpal'))();
const vorpalLog = require('vorpal-log');

vorpal.use(vorpalLog)
  .delimiter('vorpal-log demo $')
  .show();

const logger = vorpal.logger;

vorpal.command('log')
  .action(function(args, cb) {
  logger.debug('Log command called without arguments.');
  logger.log('Foo, bar, baz!');
  logger.confirm('You successfully ran the log command.');
  logger.info('It logs stuff.');
  logger.warn('Careful with that axe, Eugene!');
  logger.error('Something went wrong...');
  logger.fatal('If this was a real program, it would probably shut down now.');
  cb();
});

logger.info('This is a demo program for the vorpal-log extension.');
logger.info('Run log to produce some output.');
logger.info('Run loglevel <level> to change the level, e.g. \'loglevel warn\'');
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

`logger.printMsg(msg)` will always print the message wihout caring about the loglevel or formatting.

Set the loglevel:

`logger.setFilter(level)`

E.g. `logger.setFilter('warn')` will only print messages via logger.warn, logger.error and logger.fatal.

#### Options

The following options passed by `vorpal.use(vorpalLogger, options)` are used:

- `markdown`: if true, the default formatters will format the message as markdown, using [marked-terminal](https://github.com/mikaelbr/marked-terminal).

#### Commands

Vorpal-log adds the following (hidden) command, which simply delegates to `logger.setFilter`. As a user can enable debug logging with it, you might want to [remove](https://github.com/dthree/vorpal#commandremove) it for production.

```
Usage: loglevel [options] <level>


set the log level

Options:

  --help  output usage information
```

### Customizing

##### logger.addFormatter(name, level, format)
Creates a `logger[name]` function, which will log the result of `format(msg)` with loglevel `level`. Use this to add custom formatters.

See `customFormatter` [here](https://github.com/AljoschaMeyer/vorpal-log/tree/master/examples) for a working, insightful and useful example.

##### logger.setFilter(filter)
Takes either a custom filter function, a string, or a number.

When logging something, the formatter is passed to the function set by `logger.setFilter`. Logging only happens if this function returns true.

If `logger.setFilter` is passed a function, this function is the new filter function.

If passed a number, the new filter function will only log, if `formatter.level` is greater than or equal to that number.

If passed a string, the new filter function will only log if `formatter.level` is greater than or equal to `formatters[filter].level`.
