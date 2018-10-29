# hashcat-brain - A Docker container for running a hashcat brain server

## What is hashcat brain

A hashcat brain server will remember password candidates attempted against a set of hashes to prevent duplicate work either by attack modes that generate similar candidates or multiple team members. It is particularly suited for slow hashes or fast hashes with many salts due to the slowdowns it introduces in the cracking process.

hashcat brain was released with hashcat v5.0.0 and is described if a [forum post by atom](https://hashcat.net/forum/thread-7903.html).

## Getting the Docker image

You can grab the built docker image directly from [docker hub](https://hub.docker.com/r/singelet/hashcat-brain) with the command:
```
docker pull singelet/hashcat-brain:latest
```

Or you can build it yourself by cloning this repository then:
```
docker build . -t hashcat-brain
```

## Running it

```
docker run -p 6863 singelet/hashcat-brain:latest
```

When run, you should see output similar to the following, keep note of the password:
```
1540849345.433447 |   0.00s |   0 | Generated authentication password: 54aaf75c3b929dcf
```

To keep like simple, this repository has a simple wrapper for running hashcat while talking to the brain. Pass it the password as the first option, then normal hashcat options as the rest. For example:
```
./hashcat-brainwrapper.sh 54aaf75c3b929dcf -m6211 hashcat_ripemd160_aes.tc wordlist.txt
```

Notice the password sent to the client is the same as that given when the brain was run.

## Brain Wrapper Explained

The brain wrapper just grabs the host and port information from docker. You can do the same by running:
```
docker port <container id>
```
Then passing the info to hashcat like so:
```
hashcat --brain-client --brain-host <IP> --brain-port <port> --brain-password <password> <normal hashcat options>
```
