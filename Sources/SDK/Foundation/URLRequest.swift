//
//  URLRequest.swift
//  SweetRPG SDK
//
//  Created by Paul Schifferer on 4/22/17.
//  Copyright © 2021 SweetRPG. All rights reserved.
//

import Foundation


extension URLRequest {

    init<A>(url : URL, request : Request<A>, accessToken : String?) {
        self.init(url: url, timeoutInterval: 30)

        httpMethod = request.method.name
        httpBody = request.method.httpBody

        setValue(accessToken.map {
            "Bearer \($0)"
        }, forHTTPHeaderField: "Authorization")
        setValue(request.method.contentType, forHTTPHeaderField: "Content-Type")
    }
}
