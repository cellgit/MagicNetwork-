//
//  FilterPlugin.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Moya


//过滤器插件,请求前带上token,请求后抛出错误
class FilterPlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
//        newRequest.setValue("Content-Type", forHTTPHeaderField: "application/json".urlEncoded)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 60
        return request
    }
}
