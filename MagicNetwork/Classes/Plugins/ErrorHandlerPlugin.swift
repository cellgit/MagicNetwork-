//
//  ErrorHandlerPlugin.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Moya


//只做统一的错误处理,如token失效等,外部的由外部调用的时候单独处理
class ErrorHandlerPlugin: PluginType {
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        guard let response = result.value else {
            return
        }
        //返回的数据必须能转json,且code必须为0,否则返回空(或者可以抛出一个错误)
        guard let json = (try? response.mapJSON()) as? [String: Any],
              let code = json["code"] as? Int
                else {
            return
        }
        dealError(code: code, message: json["message"])
    }

    func dealError(code: Int, message: Any?) {
        debugPrint("error code \(code)")
        switch code {
        case 401:
            break
        case 500:
            //系统错误
            
            break
        default:
            break
        }
    }
}
