//
//  JWT.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

/// Generalized form of a JWT.
public struct JsonWebToken<H: Codable, P: Codable>: Codable {
    private let header: H
    private let payload: P
    
    public init(header: H, payload: P) {
        self.header = header
        self.payload = payload
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

// One possible way to compose a specific header and payload structure
// into a JWT. In this case, it is for APNs.
public struct JWT: Codable {
    private struct APNsHeader: Codable {
        /// alg
        let algorithm: String = "ES256"
        
        /// kid
        let keyID: String
        
        enum CodingKeys: String, CodingKey {
            case algorithm = "alg"
            case keyID = "kid"
        }
    }
    
    private struct APNsPayload: Codable {
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
    
    private let jwt: JsonWebToken<APNsHeader, APNsPayload>
    
    public init(keyID: String, teamID: String, issueDate: Date, expireDuration: TimeInterval) {
        
        let header = APNsHeader(keyID: keyID)
        
        let iat = Int(issueDate.timeIntervalSince1970.rounded())
        let exp = iat + Int(expireDuration)
        
        let payload = APNsPayload(teamID: teamID, issueDate: iat, expireDate: exp)
        
        jwt = JsonWebToken<APNsHeader, APNsPayload>(header: header, payload: payload)
    }
    
    public func digest() throws -> String {
        return try jwt.digest()
    }
    
    public func sign(with p8: P8) throws -> String {
        return try jwt.sign(with: p8)
    }
}
