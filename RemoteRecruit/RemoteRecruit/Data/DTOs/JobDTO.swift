//
//  JobDTO.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

struct JobDTO: Codable {
    let id: Int
    let title: String
    let companyName: String
    let location: String
    let salary: String
    let description: String
    let jobType: String
    let url: String
    let tags: [String]
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case id, title, url, tags, salary, description
        case companyName  = "company_name"
        case location     = "candidate_required_location"
        case jobType      = "job_type"
        case publishedAt  = "publication_date"
    }

    // DTO → Domain Entity mapping lives here
    func toDomain() -> Job {
        Job(
            id:          String(id),
            title:       title,
            companyName: companyName,
            location:    location,
            salary:      salary,
            description: description,
            jobType:     jobType,
            url:         url,
            tags:        tags,
            publishedAt: publishedAt
        )
    }
}

struct JobsResponseDTO: Codable {
    let jobs: [JobDTO]
}
