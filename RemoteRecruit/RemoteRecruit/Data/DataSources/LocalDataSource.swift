//
//  LocalDataSource.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

protocol LocalDataSourceProtocol {
    func fetchJobs() -> [JobDTO]
    func searchJobs(query: String) -> [JobDTO]
}

final class LocalDataSource: LocalDataSourceProtocol {

    func fetchJobs() -> [JobDTO] {
        loadFromBundle()
    }

    func searchJobs(query: String) -> [JobDTO] {
        let q = query.lowercased()
        return loadFromBundle().filter {
            $0.title.lowercased().contains(q) ||
            $0.companyName.lowercased().contains(q)
        }
    }

    private func loadFromBundle() -> [JobDTO] {
        guard
            let url  = Bundle.main.url(forResource: "jobs_mock", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let resp = try? JSONDecoder().decode(JobsResponseDTO.self, from: data)
        else { return [] }
        return resp.jobs
    }
}
