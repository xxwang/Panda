//
//  CustomResponse.swift
//  Base-Swift-UIKit
//
//  Created by 奥尔良小短腿 on 2024/3/25.
//

 import Foundation
 import ObjectMapper

class CustomResponse<T: Mappable>: Mappable {
   /// 请求是否成功
   var isOk: Bool = false
   /// 状态码
   var code: Int = 0
   /// 提示消息
   var message: String?
   /// 时间戳
   var timestamp: Int = 0
   /// 数据模型
   var data: T?

   init() {}
   required init?(map: Map) {}
    
   func mapping(map: Map) {
       code <- map["code"]
       message <- map["message"]
       timestamp <- map["timestamp"]
       data <- map["data"]
   }
}
