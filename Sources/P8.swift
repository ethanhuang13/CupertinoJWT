//
//  P8.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public typealias P8 = String

extension P8 {
    /// Convert PEM format .p8 file to DER-encoded ASN.1 data
    public func toASN1() throws -> ASN1 {
        let base64 = self
            .split(separator: "\n")
            .filter({ $0.hasPrefix("-----") == false })
            .joined(separator: "")

        guard let asn1 = Data(base64Encoded: base64) else {
            throw CupertinoJWTError.invalidP8
        }
        return asn1
    }
}
