# Fluentd Example Custom Docker Container

## Building

```
docker build -t MYID/fluentd-custom .
```

## Running

### Create your configuration file

#### Sample basic configuration file
```
cat << EOF >> /tmp/fluentd.conf
<source>
  @type forward
  port 24224
</source>
<match forward>
  <store>
    @type stdout
    @id stdout_output
    output_type json
  </store>
</match>
EOF
```

### Get your service account JSON file

```
ls -l /tmp/service.json
```

### Spin up your container

```
docker run --rm -p 24224:24224  \
  -e BASE64_SERVICE_ACCOUNT=`base64 /tmp/service.json|tr -d '\n'` \
  -e BASE64_FLUENTD_CONFIG=`base64 /tmp/fluentd.conf|tr -d '\n'` \
   MYID/fluentd-custom
```