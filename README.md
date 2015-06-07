# docker-publisherd

To publish a service, create a key within the consul kv directory `published`. The key should be the hostname, a colon, then the port. This is simply for humans and the key name is not used by this service.

Example:

    registry.cloudkeeper.io:10000

For the value, use JSON. Required fields are hostname, service, and port.

    {
        "hostname":"registry.cloudkeeper.io",
        "service":"cloudkeeper-registry",
        "port":"10000"
    }

## Allow/deny

If you want to allow or deny traffic, use allow and deny with hostname/ip address(es).

    {
        "hostname":"registry.cloudkeeper.io",
        "service":"cloudkeeper-registry",
        "port":"10000",
        "deny": "all",
        "allow":"172.17.42.1"
    }

## SSL

If you're using SSL, you should add the enablessl flag. Also you will need to add your certificates to the `publisherd-data` container, in the `/etc/nginx/certs/` directory. The name should be the hostname below plus the ext, so `registry.cloudkeeper.io.crt` and `registry.cloudkeeper.io.key`.

    {
        "hostname":"registry.cloudkeeper.io",
        "service":"cloudkeeper-registry",
        "port":"10000",
        "enablessl": "true"
    }
