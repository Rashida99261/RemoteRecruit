//
//  JobRepository.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

final class JobRepository: JobRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource:  LocalDataSourceProtocol

    init(
        remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource(),
        localDataSource:  LocalDataSourceProtocol  = LocalDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource  = localDataSource
    }

    func fetchJobs() async throws -> [Job] {
        do {
            let dtos = try await remoteDataSource.fetchJobs()
            return dtos.map { $0.toDomain() }
        } catch {
            return localDataSource.fetchJobs().map { $0.toDomain() }
        }
    }

    func searchJobs(query: String) async throws -> [Job] {
        do {
            let dtos = try await remoteDataSource.searchJobs(query: query)
            return dtos.map { $0.toDomain() }
        } catch {
            return localDataSource.searchJobs(query: query).map { $0.toDomain() }
        }
    }
}
