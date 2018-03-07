# BlockChain-Coin

This is the repository of the BlockChain-Coin app for iOS.

## Generating Keys

// TODO

## Deriving Addresses from Keys

// TODO

## Addresses in depth

The `Address` model contains all the necessary methods to manipulate a BLOC address.

Addresses are encoded in `Base58` in order to ensure human-readable strings for the following reasons:

* Avoid characters that look the same in some fonts (like 0O or Il)
* Using non-alphanumeric characters could be refused an an account number
* Emails usually don't linkebreak if there's no punctuation
* Double-clicking will most likely select the whole address if it only contains alphanumeric characters

In the decoded address (70 bytes), we can find the following informations:

* The `Address Prefix`, represented by the first 2 bytes. All BLOC addresses start with `0x234b` (or `b1`).
* The `Spend Public Key` represented by the next 32 bytes.
* The `View Public Key` represented by the next 32 bytes.
* The `Checksum` in `Base16` represented by the last 4 bytes.

To verify the checksum, take the first 66 bytes, and perform a 256-bit [keccak](https://keccak.team/index.html) (SHA3) hash. Take the first 4 bytes of the hash as a result. If the result is equal to the last 4 bytes of the decoded address, the address is valid.

// TODO: Check if the following two TODOs apply to Bytecoin, might be Monero-only
// TODO: Understand how integrated Payment ID can be embedded in the address
// TODO: Understand how private view key can be embedded in the address

In order to avoid useless dependencies and complex code, `Base58.cpp` from the core BlockChain-Coin has been reimplemented in Swift (see `Base58.swift`).

In order to perform the keccak-256 hash, the app makes use of the [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift) library.

## Transactions overview

### Unlinkable payments

With Bitcoin, when an address is published, it becomes an unambiguous identifier for incoming payments, thus making it impossible for transactions to be anonymous. Bytecoin allows to publish a single address and still receive unlinkable payments.o

The destination of each output is a `Public Key`, derived from the recipient's address and some randomly generated data on the sender part. This way, address reuse is non-existant by design and no observer can determine if any transactions were sent to a specific address or even link two addresses together.

First, the sender performs a [Diffie-Hellman](https://www.youtube.com/watch?v=NmM9HA2MQGI) exchange to get a shared secret from his data and half of the recipient's address. Then, he computes a one-time destination key, using the shared secret and the second half of the address. The receiver will also perform a Diffie-Hellman exchange to recover the corresponding secret key.

Because two different keys are required from the recipient, a standard Cryptonote address is nearly twice as large as a Bitcoin wallet address.

A standard transaction sequence goes as follows:

1. Alice wants to send a payment to Bob, who has published his standard address. She unpacks the address and gets Bob's public key `(A, B)`
2. Alice generates a random `r`, and computes a one-time public key `P`
3. Alice uses `P` as a destination key for the output and also packs values `R = rG` (as a part of the Diffie-Hellman exchange) somewhere in the transaction.
4. Alice sends the transaction
5. Bob checks every passing transaction with his private key `(a,b)` and computes `P'`. If Alice transaction for Bob as the recipient was among them, then `aR = arG = rA` and `P' = P`.
6. Bob can recover the corresponde one-time private key and he can spend this output at any time by signing a transaction with it.

### One-time ring signatures

Ordinary types of cryptographic signatures permit to trace transactions to their respsective senders and receivers. This is why we need to use a different signature type than thos used in electronic cash systems.

The idea behind the protocol is fairly simple: a user produces a signature which can be checked by a set of public keys rather than a unique public key. The identity of the signer is indistinguishable from the other users whose public keys are in the set until the owner produces a second signture using the same keypair.

1. `GEN`: The signer picks a random secret key `x`, and computes the corresponding public key `P = xG`. He also computes another public key `I` which is called the `Key Image`.
2. `SIG`: The signer generates a one-time ring signature with a non-interactive zero-knowledge proof. He selects a random subset `S'` of `n` other users public keys, hiw own keypair `(x, P)` and key image `I`. `s` is the secret index in `S` (so his public key is `Ps`). After a series of transformations (see whitepaper), he outputs a signature `σ`. 
3. `VER`: The verifier checks the signature `σ` and set the `S`, applies the inverse transformation and validates the signature (`true` / `false`).
4. `LNK`: The verifier checks if `I` has been used in past signatures.

Thus:

* Nobody can recover the public key from the key image and identify the signer
* The signer cannot make two signatures with different key images and the same one-time public key

### Overview of a standard transaction

By combining unlinkable public keys and untraceable ring signature, Bob achieves a new level of privacy compared to Bitcoin. He only needs to store his private key `(a, b)` and publish `(A, B)` to receive and send anonymous transactions.

When signing a transaction, Bob specifies `n` foreign ouputs with the same amount as his output, mixing all of them without the participation of other users. With `n = 1`, the probability that he has spent the output is 50%. With `n = 99`, it's 1%. The size of the signature increases linearly as `O(n+1)`, so the improved anonymity costs to Bob extra transaction fees. With `n = 0`, his ring signature has only one element and this will instantly reveal him as a spender.

## Sending Transactions

The `TransactionWorker` allows you to create a transaction hash for sending BLOC from an address to one or more other addresses.

In the iOS client, private keys never leave the device. This means that all operations required to generate the transaction hash are performed locally (see `TransactionDiskStore` implementation).

Once the transaction hash is generated on the device, it will be sent to the node JSON-RPC interface as a raw transaction.

When sending BLOCs, you need the following parameters:

(All the amounts below must be specified based on the minimum possible BLOC value (for exemple, `1 BLOC` = `100000000`))

* `destinations`: an array of `TransactionDestinationModel`, where each element represent a valid address and an amount (`> 0`)
* `mixin`: the anonymity level, or more precisely the number of transactions yours is indistinguishable from (from `0` to `infinity`)
* `paymentId`: a identifier sometimes provided by an exchange or a merchant to differentiate your transaction from others coming from the same wallet (see [About Payment ID](#about-payment-id))
* `fee`: the transaction fee, which must be `>= 10000` or `0.0001 BLOC`
* `keyPair`: the public and private Spend Keys for the wallet used to send BLOCs from

### About Payment ID

Payment IDs are needed when sending to an exchange or to a merchant. It allows it to confirm the transaction is yours, because it probably gets a lot of incoming transactions on the same address and they won't be able to differentiate otherwise without a payment ID.

Payment IDs might sometimes be directly integrated into the address. This improves user convenience and also mitigates the risk that a user forgets to include payment ID when sending his BLOCs to an exchange.

Usually, the exchange or the merchant will provide you the Payment ID.

You don't need to include a Payment ID when sending to another person.

We need Payment IDs because, unlike Bitcoin, we cannot generate multiple addresses in a wallet. Therefore, it wouldn't be convenient for an exchange or a merchant to make a new wallet for every new user.

### About Dust

// TODO

```
One possible attack against the original CryptoNote or ring-coin protocol [2,16] is
blockchain analysis based on the amounts sent in a given transaction. For example,
if an adversary knows that coins have been sent at a certain time, then they may
be able to narrow down the possibilities of the sender by looking for transactions
containing coins. This is somewhat negated by the use of the one-time keys used
in [16] since the sender can include a number of change addresses in a transaction,
thus obfuscating the amount which has been sent with a type of “knapsack mixing.”
However this technique has the downside that it can create a large amount of
“dust” transactions on the blockchain, i.e. transactions of small amounts that take
up proportionately more space than their importance. Additionally, the receiver of
the coins may have to “sweep” all this dust when they want to send it, possibly
allowing for a smart adversary to keep track of which keys go together in some
manner. Furthermore, it is easy to establish an upper and lower bound on the
amounts sent.
```

### Signing a transaction

// TODO

#### Extra field

The extra field can contains different types of data:

* `paymentId`: See [About Payment ID](#about-payment-id), `Tag` = `0x00`

Note that one field cannot be bigger that 255 bytes.

In order to construct the extra data bytes, perform the following step for each field you want to add:

1. Append the tag associated with the field at the beginning of the field data (for exemple `paymentId` has a tag value of `0x00`)
2. Append `0x02` at the end of your result bytes array, marking the beginning of a new field
3. Append the length of the data from step 1 at the end of the bytes obtained from step 2
4. Append the data from step 1 after the bytes obtained from step 3

Repeat the process for each field.

Example:

I want to add `paymentId` data (`[ 0xA1, 0xF2, 0xC3 ]`) to an empty extra field. The resulting bytes array will be:

```
[ 0x02, 0x03, 0x00, 0xA1, 0xF2, 0xC3 ]
```

## External resources

The following resources can be used to further comprehend the BlockChain-Coin feature implementations:

* [Cryptonote Whitepaper](https://cryptonote.org/whitepaper.pdf)
* [Cryptonote Address Generator](https://xmr.llcoins.net/addressgen.html)
* [Cryptonote Address Tests](https://xmr.llcoins.net/addresstests.html)
* [Cryptonote Check Transaction](https://xmr.llcoins.net/checktx.html)
* [Cryptonight Hash Checker](https://xmr.llcoins.net/slowhash.html)
* [ByteCoin Wiki](https://wiki.bytecoin.org/wiki/Main_Page)
* [Monero Daemon RPC Developer Guide](https://getmonero.org/resources/developer-guides/daemon-rpc.html)
* [Monero: Ring Signatures](https://www.youtube.com/watch?v=zHN_B_H_fCs)
* [A Note on Chain Reactions in Traceability in CryptoNote 2.0](https://lab.getmonero.org/pubs/MRL-0001.pdf)
* [Monero is Not That Mysterious](https://lab.getmonero.org/pubs/MRL-0003.pdf)

## Commit style

This repository enforces:

* The [GitHub Flow](https://guides.github.com/introduction/flow/)
* [Semantic versioning](http://semver.org)
* A [CHANGELOG](http://keepachangelog.com/en/1.0.0/)
* A strict and visual style for commits using emojis. While this ease the reading of the commit log, it also forces you to make smaller commits and categorize them appropriately.

### Emojis

Following is a full list of all the emojis that must be append to the commit message:

#### Branching & Releasing

* 🔀 Merge (feature → develop, PR approved, …)
* ↪️ Mergeback before PR (develop → feature, …)
* ⏪ Revert
* ❇️ Initial commit
* 📆 Version bump
* 📦 Work on Continuous Integration, package releasing

#### Work

* 📣 New feature/user story complete
* 🚧 Work in progress
* 🐛 Bugfix
* 🔥 Critical bugfix, hotfix
* 👍 Generic improvement
* 🌐 Localization
* 💬 Wording
* ✏️ Fixing a typo (code, URL, …)
* 🖼 UI-related (storyboard, images…)
* 🔧 App settings (environments, test accounts, …)
* ☁️ Webservices")

#### Testing, Mocking

* 📐 Unit tests, UI tests
* 👻 Mocks, stubs, templates")

#### Dependencies

* 🔗 Adding dependencies
* 🗑 Removing dependencies
* ⬆️ Upgrading dependencies
* ⬇️ Downgrading dependencies


#### iOS topics

* 🔍 Tracking/Analytics work
* 📥 Push Notifications work
* 🛂 Code signing, certificates

#### Extras

* 🚨 Fixing warnings
* ✂️ Refactoring (code-wise)
* ⚡️ Speed, performance improvements
* 🚚 Moving files, cleaning project
* 🗑 Removing files
* ⚙️ Changing project settings, build scripts, …
* 📚 Documentation, PAW project, …
* 💎 Changes to Sketch file
* 🦅 Swift-specific work (conversion, syntax upgrade)
* ☕️ Java-specific work
* 🅾️ Objective-C specific work

#### Forbidden, ugly things

* ☢️ Trying stuff, not quite ready
* ⛔️ Commit that does not compile
* 💤 Developer needs sleep or caffeine
