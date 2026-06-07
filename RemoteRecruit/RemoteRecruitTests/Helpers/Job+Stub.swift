//
//  Job+Stub.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

@testable import RemoteRecruit

extension Job {
    static func stub(
        id: String          = "1",
        title: String       = "iOS Engineer",
        companyName: String = "Apple",
        location: String    = "Remote",
        salary: String      = "$120k",
        description: String = "<p>Great role</p>",
        jobType: String     = "full_time",
        url: String         = "https://apple.com",
        tags: [String]      = ["iOS", "Swift"],
        publishedAt: String = "2026-01-01T00:00:00Z"
    ) -> Job {
        Job(id: id, title: title, companyName: companyName,
            location: location, salary: salary, description: description,
            jobType: jobType, url: url, tags: tags, publishedAt: publishedAt)
    }
}
