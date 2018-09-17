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
    public func es256Sign(digest: String) throws -> String {
        guard let message = digest.data(using: .utf8) else {
            throw CupertinoJWTError.digestDataCorruption
        }

        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256((message as NSData).bytes, CC_LONG(message.count), &hash)
        let digestData = Data(bytes: hash)

        let algorithm = SecKeyAlgorithm.ecdsaSignatureDigestX962SHA256

        guard SecKeyIsAlgorithmSupported(self, .sign, algorithm)
            else {
                throw CupertinoJWTError.keyNotSupportES256Signing
        }

        var error: Unmanaged<CFError>? = nil

        guard let signature = SecKeyCreateSignature(self, algorithm, digestData as CFData, &error) else {
            throw error!.takeRetainedValue()
        }

        let rawSignature = try (signature as ASN1).toRawSignature()

        return rawSignature.base64EncodedURLString()
    }
}
