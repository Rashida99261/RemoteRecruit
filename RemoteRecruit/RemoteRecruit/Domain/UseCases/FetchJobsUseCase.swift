//
//  FetchJobsUseCase.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

protocol FetchJobsUseCaseProtocol {
    func execute() async throws -> [Job]
}

final class FetchJobsUseCase: FetchJobsUseCaseProtocol {
    private let repository: JobRepositoryProtocol

    init(repository: JobRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Job] {
        try await repository.fetchJobs()
    }
}
