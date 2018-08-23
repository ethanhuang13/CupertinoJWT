//
//  JWT.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

public struct JWT: Codable {
    private struct Header: Codable {
        /// alg
        let algorithm: String = "ES256"

        /// kid
        let keyID: String

        enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyID = "kid"
        }
    }

    private struct Payload: Codable {
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
    }

    private let header: Header

    private let payload: Payload

    public init(keyID: String, teamID: String, issueDate: Date, expireDuration: TimeInterval) {

        header = Header(keyID: keyID)

        let iat = Int(issueDate.timeIntervalSince1970.rounded())
        let exp = iat + Int(expireDuration)

        payload = Payload(teamID: teamID, issueDate: iat, expireDate: exp)
    }

    /// Combine header and payload as digest for signing.
    public func digest() throws -> String {
        let headerString = try JSONEncoder().encode(header.self).base64EncodedURLString()
        let payloadString = try JSONEncoder().encode(payload.self).base64EncodedURLString()
        return "\(headerString).\(payloadString)"
    }

    /// Sign digest with P8(PEM) string. Use the result in your request authorization header.
    public func sign(with p8: P8) throws -> String {
        let digest = try self.digest()

        let signature = try p8.toASN1()
            .toECKeyData()
            .toPrivateKey()
            .es256Sign(digest: digest)

        let token = "\(digest).\(signature)"
        return token
    }
}
