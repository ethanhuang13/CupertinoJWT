//
//  ECPrivateKey.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation
import CommonCrypto

public typealias ECPrivateKey = SecKey

extension ECPrivateKey {
    internal func es256Sign(digest: String) throws -> String {
        guard let message = digest.data(using: .utf8) else {
            throw CupertinoJWTError.convertStringToData
        }

        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((message as NSData).bytes, CC_LONG(message.count), &hash)
        let digestData = Data(bytes: hash)

        let algorithm = SecKeyAlgorithm.ecdsaSignatureDigestX962SHA256

        guard SecKeyIsAlgorithmSupported(self, .sign, algorithm)
            else {
                throw CupertinoJWTError.keyNotSupportSign
        }

        var error: Unmanaged<CFError>? = nil

        guard let signature = SecKeyCreateSignature(self, algorithm, digestData as CFData, &error) else {
            throw error!.takeRetainedValue()
        }

        return (signature as Data).base64EncodedURLString()
    }
}
