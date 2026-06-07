//
//  RemoteDataSource.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

protocol RemoteDataSourceProtocol {
    func fetchJobs() async throws -> [JobDTO]
    func searchJobs(query: String) async throws -> [JobDTO]
}

final class RemoteDataSource: RemoteDataSourceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchJobs() async throws -> [JobDTO] {
        guard let url = Endpoint.allJobs.url else { throw NetworkError.invalidURL }
        let response = try await apiClient.fetch(JobsResponseDTO.self, from: url)
        return response.jobs
    }

    func searchJobs(query: String) async throws -> [JobDTO] {
        guard let url = Endpoint.searchJobs(query: query).url else { throw NetworkError.invalidURL }
        let response = try await apiClient.fetch(JobsResponseDTO.self, from: url)
        return response.jobs
    }
}
