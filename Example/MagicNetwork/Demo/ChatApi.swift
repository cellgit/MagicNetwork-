//
//  ChatApi.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Moya
import RxSwift

public let ChatProvider = MGProvider<ChatApi>(plugins: plugins_phone)

public enum ChatApi {
    /*
     {
         "model": "gpt-3.5-turbo",
         "messages": [{"role": "user", "content": "Hello!"}]
       }
     */
    case chat(model: String, messages: [[String:String]])
    
}

extension ChatApi: MGApi {
    
    public var path: String {
        
        switch self {
        case .chat:
            return "/chat/completions"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .chat:
            return .post
        
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .chat(model: let model, messages: let messages):
            return ["model": model, "messages": messages]
        }
    }
}

