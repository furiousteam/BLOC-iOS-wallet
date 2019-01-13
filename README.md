# BLOC-iOS-wallet

This is the repository of the BLOC app for iOS.

The **master** branch is the actual version of the app present in the [App Store](https://itunes.apple.com/us/app/bloc-wallet-by-furiousteam-ltd/id1437924269?mt=8&ign-mpt=uo%3D2)

The **mining** branch including the original built-in miner for iOS that was not accepted by Apple and has to be taken out of the app. You can still build this app on your iOS device yourself. 

## Supported Features

### WALLET

- Create a new wallet
- Import a wallet (using a private key)
- Import a wallet (using a QR code)
- Backup a wallet
- Restore a wallet
- Delete a wallet
- View balance and transactions
- The restore option works from :
- iPhone to iPhone
- iPhone to Desktop wallet

### SEND

- Pay and get paid with BLOC QR code
- Enter the amount to send
- Enter the receipient’s address
- Select your wallet to use to process this transaction
- Send BLOC

### TRANSACTIONS

- View a complete history of your BLOC transactions

### NEWS

- Stay connected with the BLOC community

### MINING (Not present in the App Store)

- Mining from your iOS device

## Building the app

In order to build the app, make sure you have [Cocoapods](https://cocoapods.org) installed, and run:

```
pod install --repo-update
```

This is will generate a `BlockChain-Coin.xcworkspace` file that must by used instead of the `BlockChain-Coin.xcproject`

## Application architecture

### The VIP architecture

The app follows an architecture called **VIP** (View Interactor Presenter) and is lightweight take on [VIPER](https://www.objc.io/issues/13-architecture/viper/) and follows [Clean Code](https://cleancoders.com/) principles. Using this architecture, the flow of data is unidirectonial and every component is fully testable, thanks to protocols.

Every screen in the app in the app is called a `Scene`. Every scene should be an independant entity, meaning that it should not have a direct dependency with other scenes.

There are 6 components to every scene:

* The `View Controller`: the main point of entry for a scene. It is responsible for setting up its subviews and links between the other components. Is responsability is keeped to a strict minimum. Therefore, it should never suffer from the "Massive View Controller" issue.
* The `Models`: where all the data objects used by the other components are defined.
* The `Views`: all the specific subviews used by the scene. Some views might be common to multiple scenes. In this case, they should be stored in a Common folder.
* The `Interactor`: used everytime data has to be fetched or computed. The Interactor receives a Request and sends back a Response to the Presenter. Usually, the Response is the raw data.
* The `Presenter`: receives Response objects from the Interactor, and formats it for the View Controller as a View Model. The View Controller should be able to take the View Model and simply display the data without performing any more formatting.
* The `Router`: responsible for displaying other screens from the View Controller. This is the main reason why View Controllers do not have dependency on each other.

### Folders hierarchy

In order to keep things organized, the project enforces a strict folder hierarchy. The hierarchy in Xcode and in the Finder must remain exactly the same.

```
Project Name
    | AppDelegate.swift
    | Scenes
        | MyScene
            | Views
                | Subview.swift
            | MySceneModels.swift
            | MySceneVC.swift
            | MySceneRouter.swift
            | MySceneInteractor.swift
            | MyScenePresenter.swift
    | Models
        | MyModel.swift
    | Services
        | API
            | Responses
                | MyResponse.swift
            MyAPI.swift
        | Mock
            MyMock.swift
    | Workers
        | MyWorker.swift
    | Common
    | Extensions
    | Assets
        | Fonts
        | Assets.xcassets
        | LaunchScreen.storyboard
    | Supporting Files
        | Configurations
            | MyConfiguration.xcconfig
        | Localizable.strings
        | Localizable.stringsdict
        | InfoPlist.strings
        | Info.plist
        | R.generated.swift
```

### No Storyboards or XIBs

Because Storyboards and XIBs tend to slow down Xcode, make it crash and, after all these years, still not suited for team development (unsovable merges), the app should not use any `Storyboard` or `XIB` (except for `LaunchScreen.storyboard`).

Instead, all the layouts are done in code with the help of [SnapKit](https://github.com/SnapKit/SnapKit).

### Accessing ressources

Accessing ressources like images and localized strings must be done in type-safe way, through [R.swift](https://github.com/mac-cain13/R.swift). Once setup, all the added ressources are automatically converted in the `R.generated.swift` file and accessible via its API.

### Images

When possible, images should be added as PDFs to handle future resolutions and in black and white in order to take advantage of `tintColor`.

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
