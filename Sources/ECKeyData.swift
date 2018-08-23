//
//  ECKeyData.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public typealias ECKeyData = Data

extension ECKeyData {
    public func toPrivateKey() throws -> ECPrivateKey {
        var error: Unmanaged<CFError>? = nil

        guard let privateKey =
            SecKeyCreateWithData(self as CFData,
                                 [kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
                                  kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                                  kSecAttrKeySizeInBits: 256] as CFDictionary,
                                 &error) else {
                                    throw error!.takeRetainedValue()
        }
        return privateKey
    }
}
