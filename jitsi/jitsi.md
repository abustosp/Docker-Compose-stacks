
Setup Guide
https://jitsi.github.io/handbook/docs...

## Steps:

1. download jitsi latest
#the version number may change, so be aware of that
`sudo wget https://github.com/jitsi/docker-jitsi-meet/releases/...`
`wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-5963.tar.gz`

2. extract file
#the version number may change, so be aware of that
`tar -zxvf stable-5963.tar.gz`

3. change directory
 the version number may change, so be aware of that
`cd docker-jitsi-meet-stable-5963`

4. copy example file to .env
`cp env.example .env`

5. edit .env file.

 because I'm going to use NGINX Proxy Manager, I do NOT use the LetsEncrypt section of this file.
 modify this file per your needs
	- `nano .env`
	- `vim .env`

6. enforce/generate strong passwords in the .env file
`./gen-passwords.sh`

7. create required config directories
`mkdir -p ~/.jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}`

8. deploy
`docker-compose up -d`

Once this is up and running, you can setup your domain and reverse proxy to point to the container, but make sure that you have the ability to enable Websockets support.