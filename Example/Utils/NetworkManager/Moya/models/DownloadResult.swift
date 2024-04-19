//
//  DownloadResult.swift
//  Example
//
//  Created by apple on 2024/4/18.
//

import Foundation
import ObjectMapper

class DownloadResult: PDModel {
    var filePath: String?
    
    override func mapping(map: Map) {
        filePath <- map["filePath"]
    }
}
