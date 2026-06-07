//
//  JobListViewModel.swift
//  RemoteRecruit
//
//  Created by Rashida on 6/06/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class JobListViewModel: ObservableObject {

    // MARK: - Output
    @Published private(set) var jobs: [Job]             = []
    @Published private(set) var viewState: ViewState    = .idle
    @Published var searchText: String                   = ""
    

    private var allJobs: [Job] = []

    // MARK: - Dependencies (Domain use cases only — no Data imports)
    private let fetchJobsUseCase:  FetchJobsUseCaseProtocol
    private var cancellables       = Set<AnyCancellable>()

    init(
        fetchJobsUseCase:  FetchJobsUseCaseProtocol,
    ) {
        self.fetchJobsUseCase  = fetchJobsUseCase
        bindSearch()
    }

    // MARK: - Search debounce
    private func bindSearch() {
        $searchText
            .debounce(
                for: .milliseconds(400),
                scheduler: DispatchQueue.main
            )
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearch(query: query)
            }
            .store(in: &cancellables)
    }

    private func handleSearch(query: String) {
        let trimmed = query.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !trimmed.isEmpty else {
            jobs = allJobs
            viewState = jobs.isEmpty ? .empty : .loaded
            return
        }

        jobs = allJobs.filter { job in
            job.title.localizedCaseInsensitiveContains(trimmed)
            || job.companyName.localizedCaseInsensitiveContains(trimmed)
            || job.location.localizedCaseInsensitiveContains(trimmed)
        }

        viewState = jobs.isEmpty ? .empty : .loaded
    }

    // MARK: - Intents

    func loadJobs() async {
        viewState = .loading

        do {
            let fetchedJobs = try await fetchJobsUseCase.execute()

            allJobs = fetchedJobs
            jobs = fetchedJobs

            viewState = jobs.isEmpty ? .empty : .loaded
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }



    func retry() {
        Task { await loadJobs() }
    }
}

// MARK: - View State
enum ViewState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
