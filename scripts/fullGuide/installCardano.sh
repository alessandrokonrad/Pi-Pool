#!/bin/bash
set -e

echo "Cloning Cardano repository"
echo
git clone https://github.com/input-output-hk/cardano-node.git ~/cardano-node
cd ~/cardano-node
echo -e "package cardano-crypto-praos\n  flags: -external-libsodium-vrf" > cabal.project.local
git fetch --all --tags
echo "Checking out version 1.19.1"
git checkout tags/1.19.1
echo "Building node, this takes a while..."
cabal build all
cp -p ~/cardano-node/dist-newstyle/build/aarch64-linux/ghc-8.6.5/cardano-node-1.19.1/x/cardano-node/build/cardano-node/cardano-node ~/.local/bin/
cp -p ~/cardano-node/dist-newstyle/build/aarch64-linux/ghc-8.6.5/cardano-cli-1.19.1/x/cardano-cli/build/cardano-cli/cardano-cli ~/.local/bin/
cd
echo "Done!"
