//
//  MGProviderError.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
public enum ProviderErrorCode: Int {
    
    case unknown = 40404
    case jsonSerializationFailed = 40407

    public var value: Int {
        return self.rawValue
    }
}

public struct ProviderError: Swift.Error {

    public let code: ProviderErrorCode
    public let failureReason: String

    public init(code: Int, failureReason: String) {
        self.code = ProviderErrorCode(rawValue: code) ?? ProviderErrorCode.unknown
        self.failureReason = NSLocalizedString(failureReason, tableName: ProviderError.tableName, bundle: ProviderError.bundle, comment: "")
    }

    private class Empty {
    }

    private static var bundle: Bundle {
        let classBundle = Bundle(for: Empty.self)
        if let bundleURL = classBundle.url(forResource: "ProviderErrorBundle", withExtension: "bundle") {
            return Bundle(url: bundleURL) ?? classBundle
        } else {
            return classBundle
        }
    }

    private static let tableName: String = "ProviderErrorLocalizable"
}

extension ProviderError: CustomDebugStringConvertible {
    public var localizedDescription: String {
        return failureReason
    }
    public var debugDescription: String {
        return failureReason + "error code: \(code.value)"
    }
}

extension ProviderError {


    public static var jsonSerializationFailed: ProviderError {
        return ProviderError(code: ProviderErrorCode.jsonSerializationFailed.rawValue, failureReason: "JSON Serialization Failed")
    }


}
