//
//  Endpoint.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

enum Endpoint {
    case allJobs
    case searchJobs(query: String)

    var url: URL? {
        var components        = URLComponents()
        components.scheme     = "https"
        components.host       = "remotive.com"
        components.path       = "/api/remote-jobs"

        if case .searchJobs(let q) = self {
            components.queryItems = [URLQueryItem(name: "search", value: q)]
        }
        return components.url
    }
}
