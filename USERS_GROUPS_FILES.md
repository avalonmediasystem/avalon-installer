# Puppet Installation Details

## Users and Groups

The puppet installer creates the following users:

 User       | Purpose
------------|-------------------------------------------------------------------------------------------
 avalon     | Owns and runs the avalon web application
 matterhorn | Owns and runs the felix OSGi container, as well as the Opencast Matterhorn components
 red5       | Owns and runs the red5 application
 tomcat7    | Owns and runs the Tomcat servlet container, as well as the Fedora and Solr webapps

In addition, the installer creates one group, avalon, which has avalon, matterhorn, and red5 as members.

## File locations

 Component          | Location                    | Defined as
--------------------|-----------------------------|-------------------
 Avalon             | `/var/www/avalon/current`   | `RAILS_ROOT`
 Tomcat             | `/usr/local/tomcat`         | `CATALINA_HOME`
 Fedora             | `/usr/local/fedora`         | `FEDORA_HOME`
 Solr               | `/usr/local/solr`           | `SOLR_HOME`
 Red5               | `/usr/local/red5`           | `RED5_HOME`
 RTMP Streams       | `/var/avalon/rtmp_streams`  | -
 HLS Streams        | `/var/avalon/hls_streams`   | -
 Avalon Dropbox     | `/var/avalon/dropbox`       | -

### Notes

* The RTMP Streams directory is symlinked as `/usr/local/red5/webapps/avalon/streams`
* The HLS Streams directory is symlinked as `/var/www/avalon/public/streams`