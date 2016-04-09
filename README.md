# ssl-expire-soon
Will your ssl certs expire soon?

## Usage

### Add list of sites to `domains.sh`
```
DOMAINS=(
  "google.com"
  "www.google.com"
)
```

### Run the script

```
./ssl-expire-soon.sh $days_till_expirary $script_path
```

`$days_till_expirary` - How many days till the certificate expires to warn you

`$script_path` - Path to the script to execute if the cert is out side the expirary window

#### Example
```
./ssl-expire-soon.sh 30 "echo hello_world"
```

Based on https://github.com/laurentr/bin/blob/master/sslCertCheck
