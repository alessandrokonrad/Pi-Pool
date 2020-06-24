<p align="center"><img width="80px" src="https://github.com/alessandrokonrad/Pi-Pool/blob/master/images/logo.svg"></img></p>

# Pi Pool

Pi Pool is a Cardano Stakepool on Raspberry Pi. Check out my <a href="http://pi-pool.web.app">website</a> to see more about my stakepool. You can support me by just delegating to my pool. I'm definitely around at mainnet release of Shelley with a stakepool!<br>
This repository is a guide to setup a stakepool on a Raspberry Pi by your own.

## Why this guide
Basically we have two different popular CPU architectures. Let's only consider 64-bit machines. Many of you know Intel and AMD. They primarily build their CPUs on a x86_64 architecure. Then there is ARM, which CPUs are built on the so called aarch64 architecure, and our Raspberry Pi has an aarch64 CPU. I don't want to dive any deeper in that, but the problem is, that the Cardano-Node setup is made for x86_64 machines and currently doesn't support aarch64 out of the box. The goal of this repository is to make it as easy as possible to run a Cardano-Node on Raspberry Pi.

## Prerequesites

* Raspberry Pi 4 with 4 GB or 8 GB (recommended) RAM
* Ubuntu 20.04 LTS <b>64-bit</b> (Very easy to install with <a href="https://www.raspberrypi.org/downloads/">Pi Imager</a>)

## Getting started

This guide is currently for the Haskell Testnet (HTN)

#### 1. First of all let's update and upgrade our Ubuntu:
```
sudo apt-get update
sudo apt-get upgrade
```
You might reboot your Pi afterwards.

#### 2. Install necessary dependencies:
```
sudo apt-get install build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 llvm neofetch -y

``` 
#### 3. Get the Haskell platform:
```
sudo apt-get install -y haskell-platform
```
Now you should have GHC 8.6.5 and Cabal 2.4. You can check that with <code>ghc --version</code> and <code>cabal --version</code>.
GHC 8.6.5 is perfectly fine, but we need a higher Cabal version (3.0).<br>

#### 4. Get Cabal 3.0 and remove Cabal 2.4:
```
wget https://github.com/alessandrokonrad/Pi-Pool/raw/master/aarch64/cabal3.0/cabal
chmod +x cabal
mkdir -p ~/.local/bin
mv cabal ~/.local/bin
sudo rm /usr/bin/cabal
```
You can also build your own Cabal binary for aarch64. Look <a href="/Crossbuilding.md">here</a>.

#### 5. Add the new Cabal to PATH:

Open the .bashrc file in your home directory and add at the bottom:
```
export PATH="~/.local/bin:$PATH"
```
To make the the new PATH active you can either reboot the Pi or type <code>source .bashrc</code> from your home directory. Then run:
```
cabal update
```
<br>

Now we are ready to build the Cardano-Node!

#### 6. Clone the cardano-node repository from GitHub and build it (this takes a while):
```
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --tags
git checkout tags/1.13.0
cabal build all
cabal install cardano-cli cardano-node --installdir=$HOME/.local/bin --overwrite-policy=always
```
Finally we have our node. If everything worked fine, you should be able to type <code>cardano-cli</code> and <code>cardano-node</code>.

#### 7. Running a node:

We need first of all some configuration files:
```
mkdir pi-node
cd pi-node
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet.json
wget https://hydra.iohk.io/job/Cardano/cardano-node/cardano-deployment/latest-finished/download/1/shelley_testnet.json

```
You can change "ViewMode" from "SimpleView to "LiveView" in ff-config.json to get a fancy node monitoring.<br>
Now start the node:
```
cardano-node run \
   --topology shelley_testnet-topology.json \
   --database-path db \
   --socket-path db/socket \
   --host-addr 127.0.0.1 \
   --port 3001 \
   --config shelley_testnet-config.json
```

That's it. Your node is now starting to sync!


## Setup a stakepool
Coming soon!


## Cross-building
If you want to build your own Cabal binary for aarch64 or a different version of Cabal, follow <a href="/Crossbuilding.md">this</a> guide.


## Port forwarding
Coming soon!
