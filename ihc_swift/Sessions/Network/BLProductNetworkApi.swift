//
//  BLProductNetworkApi.swift
//  ihc_swift
//
//  Created by zhujunjie on 2018/2/6.
//  Copyright © 2018年 zjjllj. All rights reserved.
//

import Foundation
import Moya

public enum BLProductNetworkApi {
    
    case categorylist(String?, Array<Int>?)
    case productlist(String?, String, Array<Int>)
    case brandlist(String?, String, Array<Int>)
    case filterbrandlist(String?, String, String, Array<Int>)
    case productinfo(String?, String)
}

extension BLProductNetworkApi: TargetType {
    public var baseURL: URL {
        let licenseid: String = BLLet.shared().configParam.licenseId!
        return URL(string: "https://\(licenseid)bizappmanage.ibroadlink.com/ec4/v1/system/resource")!
    }
    
    public var path: String {
        switch self {
        case .categorylist(_, _):
            return "/categorylist"
        case .productlist(_, _, _):
            return "productlist"
        case .brandlist(_, _, _):
            return "/productbrand/list"
        case .filterbrandlist(_, _, _, _):
            return "/productbrandfilter/list"
        case .productinfo(_, _):
            return "/product/info"
        }
    }
    
    public var method: Moya.Method {
        return .post
    }
    
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    public var task: Task {
        switch self {
        case .categorylist(let brandid, let protocols):
            var params: [String: Any] = [:]
            params["brandid"] = brandid
            params["protocols"] = protocols
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .productlist(let brandid, let categoryid, let protocols):
            var params: [String: Any] = [:]
            params["brandid"] = brandid
            params["categoryid"] = categoryid
            params["protocols"] = protocols
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .brandlist(let brandid, let categoryid, let protocols):
            var params: [String: Any] = [:]
            params["brandid"] = brandid
            params["categoryid"] = categoryid
            params["protocols"] = protocols
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .filterbrandlist(let brandid, let categoryid, let brandname, let protocols):
            var params: [String: Any] = [:]
            params["brandid"] = brandid
            params["categoryid"] = categoryid
            params["brandname"] = brandname
            params["protocols"] = protocols
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .productinfo(let brandid, let pid):
            var params: [String: Any] = [:]
            params["brandid"] = brandid
            params["pid"] = pid
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        let encoder = JSONEncoder()
        let head = BLNetworkCommonHeader()
        let data = try! encoder.encode(head)
        if let dict = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : String] {
            return dict
        }
        return nil
    }

    
}
