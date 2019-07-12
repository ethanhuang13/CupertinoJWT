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

### Carthage

[Carthage][] is a simple, decentralized dependency manager for Cocoa. To install CupertinoJWT with Carthage:

 1. Make sure Carthage is [installed][Carthage Installation].

 2. Update your `Cartfile` to include the following:

```ruby
github "ethanhuang13/CupertinoJWT"
```

 3. Run `carthage update` and [add the appropriate framework][Carthage Usage].

[Carthage]: https://github.com/Carthage/Carthage
[Carthage Installation]: https://github.com/Carthage/Carthage#installing-carthage
[Carthage Usage]: https://github.com/Carthage/Carthage#adding-frameworks-to-an-application

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

### APNs Example

This example demonsrates an alternative approach to constructing a JWT for use with APNs.  In this case we are reading the key from a P8 file stored on disk. The path to the key is obtained by reading the ASC_API_KEY_PATH environment variable.  The header and payload are defined in the client code here (no longer inside CupertinoJWT framework).

```swift
var p8: String? = nil

if let ascApiKeyPath = ProcessInfo.processInfo.environment["ASC_API_KEY_PATH"] {
    do {
        let fileURL = URL(fileURLWithPath: ascApiKeyPath)
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        p8 = content
    }
    catch {
        /* error handling here */
        print(error)
    }
}

do {
    struct APNsHeader: Codable {
        /// alg
        let algorithm: String = "ES256"
        
        /// kid
        let keyID: String
        
        enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyID = "kid"
        }
    }
    
    struct APNsPayload: Codable {
        /// iss
        public let teamID: String
        
        /// iat
        public let issueDate: Int
        
        /// exp
        public let expireDate: Int
        
        enum CodingKeys: String, CodingKey {
            case teamID = "iss"
            case issueDate = "iat"
            case expireDate = "exp"
        }
        
        init(teamID: String, issueDate: Date = Date(), expireDuration: Int = 20 * 60) {
            self.teamID = teamID
            self.issueDate = Int(issueDate.timeIntervalSince1970.rounded())
            self.expireDate = self.issueDate + Int(expireDuration)
        }
        
        init(teamID: String, issueDate: Int, expireDate: Int) {
            self.teamID = teamID
            self.issueDate = issueDate
            self.expireDate = expireDate
        }
    }
    
    let apnsHeader = APNsHeader(keyID: "JMR5QXHU8X")
    let issueDate = Date()
    let iat = Int(issueDate.timeIntervalSince1970.rounded())
    let expireDuration = 20 * 60
    let exp = iat + Int(expireDuration)
    let apnsPayload = APNsPayload(teamID: "69a6de93-630a-47e3-e053-5b8c7c11a4d1", issueDate: iat, expireDate: exp)
    let jwt = JsonWebToken<APNsHeader, APNsPayload>(header: apnsHeader, payload: apnsPayload)
    
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    do {
        let jsonData = try jsonEncoder.encode(jwt)
        let jsonString = String(data: jsonData, encoding: .utf8)
        print(jsonString!)
    }
    catch {
        print(error)
    }
    
    let token = try jwt.sign(with: p8!)
    print(token)
}
catch {
    print(error)
}
```

### AppStoreConnect Example

This example demonsrates an alternative approach to constructing a JWT for use with App Store Connect.  In this case we are reading the key from a P8 file stored on disk. The path to the key is obtained by reading the ASC_API_KEY_PATH environment variable.  The header and payload are defined in the client code here (no longer inside CupertinoJWT framework).

```swift
var p8: String? = nil

if let ascApiKeyPath = ProcessInfo.processInfo.environment["ASC_API_KEY_PATH"] {
    do {
        let fileURL = URL(fileURLWithPath: ascApiKeyPath)
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        p8 = content
    }
    catch {
        /* error handling here */
        print(error)
    }
}
do {
    struct AppStoreConnectHeader: Codable {
        /// alg
        let algorithm: String = "ES256"
        
        /// kid
        let keyID: String
        
        /// typ
        let type: String = "JWT"
        
        enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyID = "kid"
            case type = "typ"
        }
    }
    
    struct AppStoreConnectPayload: Codable {
        /// iss
        public let teamID: String
        
        /// exp
        public let expireDate: Int
        
        /// aud
        public let audience: String = "appstoreconnect-v1"
        
        enum CodingKeys: String, CodingKey {
            case teamID = "iss"
            case expireDate = "exp"
            case audience = "aud"
        }
    }
    
    let ascHeader = AppStoreConnectHeader(keyID: "JMR5QXHU8X")
    let issueDate = Date()
    let iat = Int(issueDate.timeIntervalSince1970.rounded())
    let expireDuration = 20 * 60
    let exp = iat + Int(expireDuration)
    let ascPayload = AppStoreConnectPayload(teamID: "69a6de93-630a-47e3-e053-5b8c7c11a4d1", expireDate: exp)
    let jwt = JsonWebToken<AppStoreConnectHeader, AppStoreConnectPayload>(header: ascHeader, payload: ascPayload)
    
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    do {
        let jsonData = try jsonEncoder.encode(jwt)
        let jsonString = String(data: jsonData, encoding: .utf8)
        print(jsonString!)
    }
    catch {
        print(error)
    }

    let token = try jwt.sign(with: p8!)
    print(token)
}
catch {
    print(error)
}
```

## Contribution

- Feedback and [issues](https://github.com/ethanhuang13/CupertinoJWT/issues/new) are welcome.
- Submit each pull request for single purpose. Here is a great [article](http://sergeyzhuk.me/2018/12/29/code_review/) about making code review easier.

## Special Thanks

- [yllan](https://github.com/yllan) - [sign.swift](https://gist.github.com/yllan/413ae0d4b17dd6b47383e6a46da55cdd)
