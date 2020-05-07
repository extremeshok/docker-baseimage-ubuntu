# docker-baseimage-ubuntu

https://hub.docker.com/r/extremeshok/baseimage-ubuntu

eXtremeSHOK optimized base Ubuntu LTS 20.04 

# Built with the latest versions of :
+ [Ubuntu linux](https://ubuntu.org/)
+ [S6 overlay](https://github.com/just-containers/s6-overlay)
+ [socklog overlay](https://github.com/just-containers/socklog-overlay)

# apt-install
a custom command to replace the aapt-get install (apt-get update && apt-get install) command, which will also retry failed installs/downloads

# Ubuntu linux LTS

# S6 overlay
A process supervisor (aka replaces supervisor.d and tini), chosen over tini (exec --init) as it can manage multiple processes.

# socklog overlay
A small syslog add-on for s6-overlay which replaces syslogd.

### NOTES:

#### latest versions:
The latest versions are automatically detected and used, so image is always the latest.
