//
//  CupertinoJWTError.swift
//  CupertinoJWT
//
//  Created by Ethanhuang on 2018/8/23.
//  Copyright © 2018年 Elaborapp Co., Ltd. All rights reserved.
//

import Foundation

enum CupertinoJWTError: Error {
    case convertStringToData
    case invalidP8
    case invalidAsn1
    case keyNotSupportSign
}
