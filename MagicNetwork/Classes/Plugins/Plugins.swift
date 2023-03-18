//
//  Plugins.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import Moya

//todo release下不需要log插件,plugins_phone暂时为phone所用,后期要统一
#if DEBUG
public let plugins_phone: [PluginType] = [LoggerPlugin, FilterPlugin(), ErrorHandlerPlugin()]
#else
public let plugins_phone: [PluginType] = [FilterPlugin(), ErrorHandlerPlugin()]
#endif
