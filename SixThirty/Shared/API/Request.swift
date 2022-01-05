//
//  Request.swift
//  SixThirty (iOS)
//
//  Created by 蔡志文 on 2022/1/5.
//

import Foundation

class Request {
    
    func requestData(with url: String) async throws -> Data {
       guard let url = URL(string: url) else {
           throw "Could not create the URL"
       }
       
       let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
       
       guard (response as? HTTPURLResponse)?.statusCode == 200 else {
           throw "The server responded with an error."
       }
       
       return data
   }
}
