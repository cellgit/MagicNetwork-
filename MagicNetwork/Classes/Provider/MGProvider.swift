//
//  MGProvider.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Moya
//import ObjectMapper

public protocol SugarTargetType: TargetType {
    var parameters: [String: Any]? { get }
}

public extension SugarTargetType {
    var parameters: [String: Any]? {
        nil
    }
}

public protocol MGApi: SugarTargetType {
    
}

extension MGApi {

    public var parameterEncoding: Moya.ParameterEncoding {
        if self.method == .get || self.method == .head {
            return URLEncoding.default
        } else {
            return JSONEncoding.default
        }
    }

    public var baseURL: URL {
        return URL.initUrl(string: NetworkEnvironment.shared.domain)
    }

    public var headers: [String: String]? {
//        return ["Content-Type": "application/json", "Authorization": "Bearer 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"]
//        return ["Content-Type": "application/json"]
        return [String: String]()
    }
    
    public var task: Task {
        if let parameters = parameters {
            if let isBody = parameters["isBody"] as? Bool, isBody == true {
                // 判断是否是 body 请求
                if JSONSerialization.isValidJSONObject(parameters) {
                    if let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                        return .requestCompositeData(bodyData: data, urlParameters: parameters)
                    }
                }
            }
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }

        return .requestPlain
    }

    public var sampleData: Data {
        return Data()
    }

}

struct MGContext {

    public static var publicParameters: [String: Any] {

        let info: [String: Any] = [:]

        return info
    }
}

private extension URL {
    static func initUrl(string: String) -> URL {
        guard let url = URL.init(string: string) else {
            let urlWithPercentEscapes = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            let url = URL.init(string: urlWithPercentEscapes.safeWrapper)
            return url ?? URL.initUrl(string: "")
        }
        return url
    }

    static var documentsURL: URL {
        return try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    }
}

private extension Optional where Wrapped == String {
    var safeWrapper: Wrapped {
        switch self {
        case let .some(value):
            return value
        default:
            return ""
        }
    }
}
