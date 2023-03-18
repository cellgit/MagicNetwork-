//
//  MGProviderManager.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import Moya

public class MGProviderManager {
    
    public static var plugin = NetworkActivityPlugin { change, target in
        DispatchQueue.main.async {
            switch change {
            case .began: UIApplication.shared.isNetworkActivityIndicatorVisible = true
            case .ended: UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
}

public class MGProvider<Target: TargetType>: MoyaProvider<Target> {
    public static func endpointClosure(_ target: Target) -> Endpoint {
        let sampleResponseClosure = {
            return EndpointSampleResponse.networkResponse(200, target.sampleData)
        }
        let url = target.baseURL.appendingPathComponent(target.path).absoluteString
        return Endpoint(url: url, sampleResponseClosure: sampleResponseClosure, method: target.method, task: target.task, httpHeaderFields: target.headers)
    }
    
    public init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MGProvider.endpointClosure, plugins: [PluginType] = [MGProviderManager.plugin]) {
        super.init(endpointClosure: endpointClosure, plugins: plugins)
    }
}
