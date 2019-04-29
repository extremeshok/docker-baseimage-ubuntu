# docker-baseimage-ubuntu
eXtremeSHOK optimized base Ubuntu 18.04

# Built with the latest versions of :
+ [Ubuntu linux](https://ubuntu.org/)
+ [S6 overlay](https://github.com/just-containers/s6-overlay)
+ [socklog overlay](https://github.com/just-containers/socklog-overlay)

# Ubuntu linux LTS

# S6 overlay
A process supervisor (aka replaces supervisor.d and tini), chosen over tini (exec --init) as it can manage multiple processes.

# socklog overlay
A small syslog add-on for s6-overlay which replaces syslogd.

### NOTES:

#### latest versions:
The latest versions are automatically detected and used, so image is always the latest.
