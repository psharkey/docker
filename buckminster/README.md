# Buckminster

A headless [Buckminster, Component Assembly Project](http://www.eclipse.org/buckminster/) image. Based on the [Buckminster Headless Product](http://www.eclipse.org/buckminster/downloads.html) installation instructions.

## Usage

### Show Help

To show Buckminster help use the `--help` option:
```bash
$ docker run --rm -it psharkey/buckminster --help
Help text for buckminster:
This is the common launcher for commands.

A number of options can be set in common for all commands. Use '--' to end
parsing of options in case of ambiguity.

usage: buckminster
       [{ -? | --help }]
       [--displaystacktrace]
       [{ -L | --loglevel } <loglevel> ]
       [--notrapctrlc]
       [{ --scriptfile <filename> } | {<commandname> [<commandflags>]}] 

Try "buckminster listcommands" for a list of available commands.

 -?
--help
  Show this help text

--displaystacktrace
  Also prints the stack trace in case of an exception.

 -L <loglevel>
--loglevel <loglevel>
  Set log level to one of NONE, ERROR, WARNING, INFO, or DEBUG.

--notrapctrlc
  Turn off trapping of Ctrl-C (SIGINT). This may lessen the ability to cancel
  ongoing work in a predictable manner.

 -S <filename>
--scritpfile <filename>
  Read commands from a file. The following rules apply:
  - If the file contains $property or ${property} constructs, they will
    be expanded as follows:
    - If the property is prefixed with env: the remaining part will be expanded
      as an environment variable (requires Java 5 or later).
    - All other properties are expanded using the Java system properties.
  - If java 1.5 or newer is used, the file may contain $env or ${env} entries
    to denote environment variables.
  - Backslash is interpreted as escape character so Windows filenames must be
    escaped.
  - Strings within single quotes are passed verbatim to the executor.
  - Strings within double quotes are scanned for environment variable
    substitution.
$
```

## On DockerHub / GitHub
___
* DockerHub [psharkey/buckminster](https://hub.docker.com/r/psharkey/buckminster)
* GitHub [psharkey/docker/buckminster](https://github.com/psharkey/docker/tree/buckminster/buckminster)
