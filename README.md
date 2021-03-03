<p align="center"><img width="80px" src="https://github.com/alessandrokonrad/Pi-Pool/blob/master/images/logo.svg"></img></p>

# Berry Pool

Berry is a Cardano Stakepool on Raspberry Pi. Check out my <a href="https://pipool.online">website</a> to see more about my stakepool. You can support me by just delegating to my pool. <br>
This repository is a guide to setup a stakepool on a Raspberry Pi by your own.

## Why this guide

Basically we have two different popular CPU architectures. Let's only consider 64-bit machines. Many of you know Intel and AMD. They primarily build their CPUs on a x86_64 architecture. Then there is ARM, which CPUs are built on the so called aarch64 architecture, and our Raspberry Pi has an aarch64 CPU. I don't want to dive any deeper in that, but the problem is, that the Cardano-Node setup is made for x86_64 machines and currently doesn't support aarch64 out of the box. The goal of this repository is to make it as easy as possible to run a Cardano-Node on Raspberry Pi.

## Prerequesites

- Raspberry Pi 4 4GB RAM or 8GB RAM (recommended)
- SSD (at least 20GB)
- microSD Card (needed to upgrade the bootloader)
- SATA USB 3.0 Adapter (<a href="https://jamesachambers.com/raspberry-pi-4-usb-boot-config-guide-for-ssd-flash-drives/">list of working adapters</a>)

## Getting started

### Note
<b>Cardano-Node version <code>1.25.1</code> has been released. This image comes with 1.23.0, so you should directly update the node after installing the image. 1.23.0 can't connect with the network anymore since December 2020.
   
Download 1.25.1 <a href="https://dl.dropbox.com/s/iukbylce8t8lc59/aarch64-unknown-linux-musl-cardano-node-9a7331cce5e8bc0ea9c6bfa1c28773f4c5a7000f.zip">here</a>

Scroll down to "Updating the Cardano-Node" if you don't know how to update the node version.

Changes needed:

Remove "ChainDB" from all metrics in Grafana, so that it can be displayed correctly again.
E.g.: cardano_node_ChainDB_metrics_epoch_int -> cardano_node_metrics_epoch_int

<a href="https://github.com/input-output-hk/cardano-node/releases/tag/1.25.1">Full Release Notes</a>
</b>
##

### Upgrading the Bootloader

If your Pi already boots from SSD (<b>recently shipped Pi 4 have USB Booting already flashed on</b>) you can skip this section.

1. Download <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a> and install it
2. Insert the microSD Card in a Card Reader and plug it in your PC
3. Open Pi Imager and click "Choose OS" -> Misc utility images -> Raspberry Pi 4 EEPROM boot recovery
4. Click on "Choose SD Card" and select the microSD Card
5. Click "Write" and wait until finished
6. Now remove the microSD Card from the PC and plug it into the Pi
7. Connect a monitor to the Pi and turn it on
8. If you screen shows a <b>green</b> color, the bootloader had been successfully updated!
9. Remove the microSD from the Pi

### Install the Image
1. Download the latest <a href="https://drive.google.com/u/0/uc?export=download&confirm=iXTs&id=1Gr0iCZHM8tALZ5g6qrZzLkfZPxA5K9NN">release</a>
2. Plug in the SSD in your PC
3. Open <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a> and scroll down to "Use custom", select the downloaded release
4. Click on "Choose SD Card" and select the SSD
5. Click "Write" and wait until finished
6. You can now connect the SSD with the Pi and turn it on.

### Running the Image
These are the login credentials:

Username:<code>ada</code> <br />
Password:<code>lovelace</code>

If you want to change the password, you can do this with <code>passwd</code>

### Running a Cardano-Node:

A sample node configuration folder is already preinstalled. To reproduce:

```
mkdir pi-node
cd pi-node
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-config.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-byron-genesis.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-shelley-genesis.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-topology.json

```


### Starting a Cardano-Node:
```
cd pi-node
cardano-node run \
   --topology mainnet-topology.json \
   --database-path db \
   --socket-path db/socket \
   --host-addr 0.0.0.0 \
   --port 3000 \
   --config mainnet-config.json
```

That's it. Your node is now starting to sync!

### Monitoring
If you want to monitor your node, you can do this with the command <code>startMonitor</code>.

You can access another instance of terminal by pressing <code>alt+F2-F12</code> buttons. <code>alt+F1</code> should take you back to the running node.

This will create a Grafana instance at port 5000. A custom dashboard is also already preinstalled. You can find it in the left panel under Dashboard -> Manage. You should find a Dashboard called "Raspberry Pi Node".

To connect to it find your ip addresss by typing: <code>ip a</code>

In your browser type your ip address and the port number: <code>XXX.XXX.X.X:5000</code>

Default Credentials are:<br />
Username: <code>admin</code><br />
Password: <code>admin</code>

The whole monitoring configuration you can find under <code>/opt/cardano/monitoring</code>

Use <code>stopMonitor</code> to stop the monitoring process.


### Updating the Cardano-Node

Currently there is no auto updater built in the Image. In order to update the version, this needs to be done manually.
To get the latest Cardano-Node version, join this <a href="https://t.me/joinchat/FeKTCBu-pn5OUZUz4joF2w">Telgram group</a> or check in the Getting started section under Note, if there is something new.

Download it and replace the new binaries with the current ones under <code>~/.local/bin</code> (cardano-node and cardano-cli)

Redownload the the config file: <br />
``` wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/mainnet-config.json ``` <br />
Change the following parameters in the config file:
```
  ...
  "TraceBlockFetchDecisions": true,
  ...
  "hasEKG": 12600,
  "hasPrometheus": [
    "127.0.0.1",
    12700
  ],
  ...
```


## Setup a Stake Pool

I can recommend <a href="https://cardano-community.github.io/guild-operators/#/">CNTools</a> (make sure the CNTools version is compatible with the Cardano-Node version).

The guide of <a href="https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node">CoinCashew</a> is also really helpful.

Otherwise I would follow the official guide of <a href="https://cardano-foundation-cardano.readthedocs-hosted.com/en/latest/getting-started/stake-pool-operators/index.html">cardano.org</a>

For JavaScript enthusiasts this could be helpful: <a href="https://github.com/Berry-Pool/cardanocli-js">cardanocli-js</a>

## Port forwarding

Go to your router settings. You can access them via your browser with the IP address of the router (e.g. 192.168.178.1 or if you have a FritzBox with fritz.box).
Then look for an option "Port Forwarding". Choose the IP address of your node(s) and open its/their port(s). Allow TCP. Then save it and that's it.
