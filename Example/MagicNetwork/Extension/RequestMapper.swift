//
//  RequestMapper.swift
//  MagicNetwork_Example
//
//  Created by liuhongli on 2023/3/18.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import KakaJSON
import ObjectMapper

extension MoyaError: MessageError {
    var message: String? {
        return "哎呀，与服务器连接失败了"
    }
}

protocol MessageError: Error {
    var message: String? { get }
}

//业务错误
public struct BusinessError: MessageError {

    public enum ErrorType: Int {
        //成功
        case success = 0
        //token失效,外部一般不用处理,过滤器已经处理过
        case tokenLose = 401
        //系统错误,给的500
        case systemError = 500
    }

    public let errorType: ErrorType?
    public let errorCode: Int
    public let message: String?

    public init(errorCode: Int, message: String?) {
        self.errorCode = errorCode
        self.errorType = ErrorType.init(rawValue: errorCode)

        switch errorCode {
        case 4011:
            self.message = nil
        default:
            self.message = message
        }
    }
}

//内部错误
public enum InsideError: Error {
    //服务器返回的格式不对,解析不到result和code字段
    case formatterError
}

extension PrimitiveSequenceType where Trait == SingleTrait, Element == Moya.Response {
    //code为0的时候,转为result字段数据,否则抛出业务错误,即BusinessError,注:此方法要么抛出网络本身错误,要么抛出code不为0时候的错误
    //为0的时候成功,发送result的值(可能为nil)
    public func mapResult() -> Single<Any?> {
        map { (response: Moya.Response) -> Any? in
            guard let json = try? response.mapJSON() as? [String: Any] else {
                //格式不对,返回内部错误
                throw  InsideError.formatterError
            }
            return json
        }
    }

    //map结果为json
    public func mapResultJson() -> Single<[String: Any]?> {
        mapResult().map { $0 as? [String: Any] }
    }

    //只要有result即可
    public func mapCompletable() -> Completable {
        mapResultJson().asCompletable()
    }

    //结果转为string
    public func mapResultString() -> Single<String?> {
        mapResult().map { $0 as? String }
    }

    //map出model,若没有result,发送nil值
    public func mapModel<T: Mappable>(type: T.Type) -> Single<T?> {
        mapResultJson().map { json in
            guard let json = json else {
                return nil
            }
            return Mapper<T>().map(JSON: json)
        }
    }

    // 同上,基于KaKaJson的模型协议
    public func mapModel<T: Convertible>(type: T.Type) -> Single<T?> {
        mapResultJson().map { json in
            guard  let json = json else { return nil }
            return json.kj.model(type)
        }
    }


    //解析result,如果result是数组,解析,否则解析里面的data字段,若都解不出来,发送空数组
    //注:不发送空置而发送空数组是因为逻辑上就应该是返回空的json字段,只是后台没有按规则来而已
    public func mapModels<T: Mappable>(type: T.Type) -> Single<[T]?> {
        mapResult().map { result in
            //能解析成数组,直接解析
            if let result = result as? [[String: Any]] {
                return Mapper<T>().mapArray(JSONArray: result)
            }
            //否则,去看data是否是对象数组
            if let result = result as? [String: Any],
               let data = result["data"] as? [[String: Any]] {
                return Mapper<T>().mapArray(JSONArray: data)
            }
            return []
        }
    }

    // 同上,只是基于KaKaJson,另外,返回值不会再是可选,而是空数组
    // modelsKey:解析哪个字段来取数组,默认为nil
    func mapModels<T: Convertible>(modelsKey: String? = nil, type: T.Type) -> Single<[T]> {
        mapResult().map { result in
            if let result = result as? [[String: Any]] {
                return result.kj.modelArray(type)
            }
            if let result = result as? [String: Any],
               let data = result[modelsKey ?? "data"] as? [[String: Any]] {
                return data.kj.modelArray(type)
            }
            return []
        }
    }
}
