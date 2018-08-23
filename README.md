# CupertinoJWT

![GitHub release](https://img.shields.io/github/release/ethanhuang13/CupertinoJWT.svg)
![GitHub top language](https://img.shields.io/github/languages/top/ethanhuang13/CupertinoJWT.svg)
![](https://img.shields.io/badge/Platforms-iOS%2010.0%2B%20%7C%20macOS%2010.12%2B%20%7C%20%20tvOS%2010.0%2B%20%7C%20watchOS%203.0%2B-lightgrey.svg)
[![License](https://img.shields.io/github/license/ethanhuang13/CupertinoJWT.svg)](https://github.com/ethanhuang13/knil/blob/master/LICENSE)
[![Twitter](https://img.shields.io/badge/Twitter-%40ethanhuang13-blue.svg)](https://twitter.com/ethanhuang13)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/ethanhuang13)

Convert Apple's .p8 file to JWT, without third-party dependencies.

## Features

| | Features |
| --- | --- |
| 😇 | Open source iOS project written in Swift 4 |
| ✅ | Support iOS, macOS, tvOS, and watchOS |
| ✅ | Convert Apple's .p8 file to JWT |
| ✅ | Use Security and CommonCrypto only, no third-party dependencies |
| ✅ | Support provider token based APNs connection |
| 🏗 | Support MusicKit |
| 🏗 | Support DeviceCheck |
| 🏗 | Support App Store Connect API |

## Install

### CocoaPods

You can use [CocoaPods](http://cocoapods.org/) to install `CupertinoJWT` by adding it to your `Podfile`:

```ruby
platform :ios, '10.0'
use_frameworks!

target 'MyApp' do
    pod 'CupertinoJWT'
end
```

## Usage

First, get your key from [Apple Developer site](https://developer.apple.com/account/ios/authkey/). It’s a PEM format .p8 file. It can be use for connecting to [Apple Push Notification service (APNs)](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1), [MusicKit](https://help.apple.com/developer-account/#/devce5522674), [DeviceCheck](https://help.apple.com/developer-account/#/devc3cc013b7) or [App Store Connect API](https://developer.apple.com/videos/play/wwdc2018/303/). You should keep the key safe.

Then, follow the sample code below:

```swift
// Get content of the .p8 file
let p8 = """
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgGH2MylyZjjRdauTk
xxXW6p8VSHqIeVRRKSJPg1xn6+KgCgYIKoZIzj0DAQehRANCAAS/mNzQ7aBbIBr3
DiHiJGIDEzi6+q3mmyhH6ZWQWFdFei2qgdyM1V6qtRPVq+yHBNSBebbR4noE/IYO
hMdWYrKn
-----END PRIVATE KEY-----
"""

// Assign developer information and token expiration setting
let jwt = JWT(keyID: keyID, teamID: teamID, issueDate: Date(), expireDuration: 60 * 60)

do {
    let token = try jwt.sign(with: p8)
    // Use the token in the authorization header in your requests connecting to Apple’s API server.
} catch {
    // Handle error
}

```

## Contribution

- Feedback and [issues](https://github.com/ethanhuang13/CupertinoJWT/issues/new) are welcome.

## Special Thanks

- [yllan](https://github.com/yllan) - [sign.swift](https://gist.github.com/yllan/413ae0d4b17dd6b47383e6a46da55cdd)
