## Cross-building
Make sure you have the Haskell platform installed (<code>sudo apt install haskell-platform</code>) or at least have Cabal installed<br>
We will build Cabal 3.0 in this tutorial, but you can choose any version you need.
```
wget http://hackage.haskell.org/package/cabal-install-3.0.0.0/cabal-install-3.0.0.0.tar.gz
tar -xf cabal-install-3.0.0.0.tar.gz
cd cabal-install-3.0.0.0
cabal update
cabal install --installdir=~/.local/bin
```
This could take some time. Now check with <code>cabal --version</code> your version.
