//
//  Job.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

struct Job: Identifiable, Equatable {
    let id: String
    let title: String
    let companyName: String
    let location: String
    let salary: String
    let description: String
    let jobType: String
    let url: String
    let tags: [String]
    let publishedAt: String

    var salaryDisplay: String {
        salary.isEmpty ? "Salary not disclosed" : salary
    }

    var jobTypeDisplay: String {
        jobType.replacingOccurrences(of: "_", with: " ").capitalized
    }
}
