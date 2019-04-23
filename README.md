Bitcoin Modules 
===============
Overview
--------
Bitcoin Modules is an experimental approach to adding out-of-band functionality on top of Bitcoin Core, that can be easily maintained / preserved across major releases. Simply put, an out-of-band feature is one that will most likely never be implemented into Bitcoin Core, but adds significant value. An example use case is that this can be used by altcoins to implement the features that the coin offers against the base implementation of Bitcoin Core, then **finally** apply rebranding as needed. This makes it easy (or at least easier) to keep current with the releases of Bitcoin Core as the added functionality is more isolated from the core code. There is of course also the added bonus, that it *should* lead to integrations / implementations that are cleaner and more up-to-date.

This project will be the base of future development of [Genesis Network](https://github.com/genesisofficial/genesis) in an effort to ensure the highest quality integration.

Getting Started
===============
1. Create a working directory
```sh
mkdir Source
```

2. Change directory to the newly created directory
```sh
cd Source
```

3. Clone a fresh copy of the Bitcoin Core repo, switch to a release branch and create a local staging branch
```sh
git clone https://github.com/bitcoin/bitcoin.git
cd bitcoin
git checkout tags/v0.17.1
git checkout -b "BitcoinModularStaging"
```

4. Clone a copy of this repo into a new `addons` directory under the `src` directory 
```sh
git clone XYZ -recursive
```

5. Create a symbolic link in the Bitcoin Core `src` directory
```sh
ln -s XYZ bitcoin/src/addons
```

6. Apply the base modules addon, that will be the base for other modules.
```
Add instructions here...
```

7. Follow the individual module instructions to integrate them

8. Apply branding


Directory Structure
-------------------
By default, a directory called `addons` is created underneath the `src` directory. Inside that directory are directories for features and in those are the base support files and artifacts for the addons and potentially different implementations.

Addon Structure
---------------
Each addon has to define exactly how they are to be merged into the base code to firstly provide support for a feature, then to provide an implementation. Addon packages must also be hyper focused and atomic as far as possible and define pre-requisites in a sensible way, which may include required parameters for the prerequisites.

To aid in making the addons atomic, all the addon specific constants and variables are in the addon's .h header file, so that they do not need to be added to the core code... specifically, keeping the chain params from getting cluttered as far as possible.

Addon Packaging and Implementation Notes
----------------------------------------
1. Always give credit where it is due - maintain existing copyright headers and add your own if you make significant changes.
2. Constant values have verbose names to avoid collisions and to clarify where they are specified and used.
3. Addons should not assume the availability of const values from other modules. If there are correlating values, create a value for each and use comments to define which values in which modules need to be synchronised. 

Basic Addon Guidelines
----------------------
### Always strive for high quality
Addons should provide the highest possible code quality and of course be as complete as possible. Add unit tests, regression tests, transaltions, solid help messages, documentation, release notes, high quality artwork etc. wherever possible. Always keep in mind: If an addon is going to be distinguishable from Bitcoin Core, let it be because of exceptional quality. 

### Always strive for minimal intrusion
Where possible, avoid adding functional addon/module code directly into the base Bitcoin Core code. If it is absolutely required that functional code be added to the base code, please respect the existing code: add new code to the end of the applicable existing code sections and clearly comment the additions. Please keep in mind that **if an addon is disabled, it must not break existing code!**

### Always base modules on stable releases of Bitcoin Core
All modules must be based on a stable release branch of Bitcoin Core. New modules should of course be based on the most recent stable release code and ideally provide support for the previous two point releases. As an example - at the time of writing this, the major release for Bitcoin Core will soon be v0.18.0, so modules should be developed against that, ideally with support for v0.17.1 and v0.16.3 which are the two previous point releases.

### Adhere to the Bitcoin Core coding styles
We want to create modules that fit **seamlessly** into Bitcoin Core and appear nearly indistiguishable from that code. To bring us closer to that goal, we must adhere to their coding style. The coding style guidelines for Bitcoin Core are defined in the [Devloper Notes](https://github.com/bitcoin/bitcoin/blob/master/doc/developer-notes.md). 

### Distil the module's features down to the smallest useful units
A module more often than not comprises of several distict functions (features) that are combined to support / implement a module as a whole. The rule of thumb should be that if a distinct function (feature) can exist on its own outside of the module, it should have its own addon, which is in turn required by the main module you are implementing. The reason for this is that we're trying to avoid different modules re-implementing any shared functional code (features). 

### Differentiate between support and implementation
Modules usually require different levels of integration, which can broadly be defined as adding support for a feature and then imlementing that feature. Put differently, you usually need to add support for a feature (the ability to do something) before you can add the implementation (how you wish to do something). Keeping these two concepts separate once again helps with making things more re-usable and extensible, as it may be desirable to have multiple implementation options for a single supported feature.

### Maintain the capabilities structure(s) (T.B.D.)
Different clients may have different capabilities enabled, which could cause chaos if clients merely assume that functionality is available at all it's peers. To alleviate this, please be sure to add a capability [here](https://to.be.done) which will announce a node's capabilities when it connects to other nodes. This will be a much more fine grained approach than relying on protocol versions.

Central Repository
------------------
There will need to be a central repo of available packages.

Available Addons
----------------
* Difficulty
  * Zawy

Addons ToDo
-----------
1. Subsidy
  * Random 
  * Big Block
2. Algorithm Support
  * Equihash
3. Storage
  * Tx Index
  * Address Index
4. Masternodes
  * Masternode Base
  * Maturity Based
5. Governance
6. Atomic Swaps
7. 

Addons Wishlist
---------------
1. Extensive Algorithm Support
  * Neoscrypt
  * Scrypt
  * X11
  * etc.
2. Snowflake, Snowball, Avalanche
  * Snow Patrol = Avalance + Masternodes
3. Quantum Proof Addresses
4. Smart Contracts
5. Assets
6. 3D Blockchain?
7. Masternodes
  * Premium Features
