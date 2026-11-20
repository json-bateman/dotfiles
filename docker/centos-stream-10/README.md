The point of this Dockerfile is to build a fresh CentOS 10 stream container that can be SSH'd into.
That way it can easily be tested against something like an ansible script for a first time setup. 

Run these commands to build the Dockerfile and run it exposing your SSH_PUBKEY to the container's startup script, make sure you have a id_ed25519.pub key in your `.ssh/` folder.

`docker build -t cs10-sshd .`

```
docker run -d -p 2222:22 \
  -e SSH_PUBKEY="$(cat ~/.ssh/id_ed25519.pub)" \
  cs10-sshd
```

Note: You can't pass an environment variable like this in the Dockerfile with COPY because 
COPY needs access to whatever is in the same directory as your Dockerfile. Which is why you need to
set the environment variable with -e when you run it. Then the startup script picks it up in your
environment and places it in the authorized_keys file, which lets you SSH in.

