//
//  MockFetchJobsUseCase.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation
@testable import RemoteRecruit

final class MockFetchJobsUseCase: FetchJobsUseCaseProtocol {
    var stubbedJobs: [Job] = []
    var shouldThrow = false
    private(set) var executeCallCount = 0   // tracks API call count for local-search test

    func execute() async throws -> [Job] {
        executeCallCount += 1
        if shouldThrow { throw NetworkError.invalidResponse }
        return stubbedJobs
    }
}
