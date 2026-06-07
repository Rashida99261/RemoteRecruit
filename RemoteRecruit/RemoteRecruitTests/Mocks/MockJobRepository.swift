//
//  MockJobRepository.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation
@testable import RemoteRecruit

final class MockJobRepository: JobRepositoryProtocol {
    var stubbedJobs: [Job] = []
    var shouldThrow = false

    func fetchJobs() async throws -> [Job] {
        if shouldThrow { throw NetworkError.invalidResponse }
        return stubbedJobs
    }

    func searchJobs(query: String) async throws -> [Job] {
        if shouldThrow { throw NetworkError.invalidResponse }
        let q = query.lowercased()
        return stubbedJobs.filter {
            $0.title.lowercased().contains(q) ||
            $0.companyName.lowercased().contains(q)
        }
    }
}
