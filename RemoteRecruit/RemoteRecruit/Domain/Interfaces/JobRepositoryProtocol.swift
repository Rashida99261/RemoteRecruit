//
//  JobRepositoryProtocol.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import Foundation

protocol JobRepositoryProtocol {
    func fetchJobs() async throws -> [Job]
    func searchJobs(query: String) async throws -> [Job]
}
