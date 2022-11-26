//
//  URLExt.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 24/11/22.
//

import Foundation

extension URL {
    static func construct(_ endpoint: String, queries: [String : Any] = [:]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/" + endpoint
        components.queryItems = queries.isEmpty ? nil : queries
            .compactMapValues({
                if let value = $0 as? String {
                    return value
                } else {
                    return "\($0)"
                } })
            .map({ URLQueryItem(name: $0.key, value: $0.value) })
        return components.url
    }
}
