//
//  DIContainer.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()

    // MARK: - Data Layer
    private lazy var apiClient: APIClientProtocol = APIClient.shared
    private lazy var remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource(apiClient: apiClient)
    private lazy var localDataSource: LocalDataSourceProtocol = LocalDataSource()
    private lazy var jobRepository: JobRepositoryProtocol = JobRepository(
        remoteDataSource: remoteDataSource,
        localDataSource: localDataSource
    )

    // MARK: - Domain Layer
    private lazy var fetchJobsUseCase: FetchJobsUseCaseProtocol = FetchJobsUseCase(repository: jobRepository)

    // MARK: - Presentation Layer (factory methods)
    func makeJobListViewModel() -> JobListViewModel {
        JobListViewModel(
            fetchJobsUseCase: fetchJobsUseCase)
    }
}
