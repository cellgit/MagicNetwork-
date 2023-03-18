//
//  ChatModel.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import KakaJSON

struct ChatModel: Convertible {
    var choices : [Choice]?
    var usage : Usage?
    var created : Int?
    var id : String?
    var model : String?
    var object : String?
}

struct Choice: Convertible {
    var finishReason : String?
    var index : Int?
    var message : Message?
}

struct Usage: Convertible {
    var completionTokens : Int?
    var promptTokens : Int?
    var totalTokens : Int?
}

struct Message: Convertible {
    var content : String?
    var role : String?
}
