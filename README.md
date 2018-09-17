# CupertinoJWT

![GitHub release](https://img.shields.io/github/release/ethanhuang13/CupertinoJWT.svg)
![GitHub top language](https://img.shields.io/github/languages/top/ethanhuang13/CupertinoJWT.svg)
![](https://img.shields.io/badge/Platforms-iOS%2010.0%2B%20%7C%20macOS%2010.12%2B%20%7C%20%20tvOS%2010.0%2B%20%7C%20watchOS%203.0%2B-lightgrey.svg)
[![License](https://img.shields.io/github/license/ethanhuang13/CupertinoJWT.svg)](https://github.com/ethanhuang13/knil/blob/master/LICENSE)
[![Twitter](https://img.shields.io/badge/Twitter-%40ethanhuang13-blue.svg)](https://twitter.com/ethanhuang13)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://paypal.me/ethanhuang13)

Parse Apple's `.p8` private key file and sign [JWT](https://jwt.io) with ES256, without third-party dependencies. Supports Apple's server-side APIs.

## Features

| | Features |
| --- | --- |
| 😇 | Open source iOS project written in Swift 4 |
| ✅ | Support iOS, macOS, tvOS, and watchOS |
| ✅ | Parse Apple's .p8 private key file |
| ✅ | Sign JSON Web Token with ES256 algorithm |
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

If you see CocoaPods warning about script phase, it is because CupertinoJWT requires CommonCrypto framework. And Apple didn't expose its header for Swift until Xcode 10. We use the script phase to generate module map to use it in Swift.

## What's this all about?

Apple has several server APIs uses JSON Web Token([JWT](https://jwt.io)) as authentication method, including [Apple Push Notification service (APNs)](https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/CommunicatingwithAPNs.html#//apple_ref/doc/uid/TP40008194-CH11-SW1), [MusicKit](https://help.apple.com/developer-account/#/devce5522674), [DeviceCheck](https://help.apple.com/developer-account/#/devc3cc013b7) and [App Store Connect API](https://developer.apple.com/videos/play/wwdc2018/303/). Probably more in the future.

After creating the token, one must sign it with an Apple-provided private key, using the Elliptic Curve Digital Signature Algorithm (ECDSA) with the P-256 curve and the SHA-256 hash algorithm, or ES256.

This task is very common and well-supported with mature server-side languages like Ruby, Java, Python, or JS. With Swift, however, is not that easy. One often needs to use OpenSSL or its forks, even server-side Swift frameworks like Vapor or Perfect use OpenSSL forks. If you want to do this on iOS, it's even harder.

Personally I'm interested in creating developer tools running on iOS. For example, we can use the JWT for App Store Connect API on a developer tool app.

Turned out we can just use Apple's Security and CommonCrypto frameworks, and support all Apple platforms. And that's what CupertinoJWT does.

The result is, with CupertinoJWT, we can easily create developer tools on iOS (and also macOS, tvOS, and watchOS) connecting to APNs, App Store Connect, or other Apple server APIs.

## What does CupertinoJWT do?

The private keys provided by Apple are PEM format `.p8` files. CupertinoJWT parses and convert them to ASN.1 data, retrieve the private keys, loads with `SecKeyCreateWithData` method, and finally create signature using `SecKeyCreateSignature` method.

## Usage

First, get your `.p8` key file from [Apple Developer site](https://developer.apple.com/account/ios/authkey/). It can be download once. Keep the file safe. (As a developer, you should know the importance for keeping the private keys safe.)

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
    // e.g. urlRequest.addValue(_ value: "bearer \(token)", forHTTPHeaderField field: "authorization")
} catch {
    // Handle error
}
```

## Contribution

- Feedback and [issues](https://github.com/ethanhuang13/CupertinoJWT/issues/new) are welcome.

## Special Thanks

- [yllan](https://github.com/yllan) - [sign.swift](https://gist.github.com/yllan/413ae0d4b17dd6b47383e6a46da55cdd)
