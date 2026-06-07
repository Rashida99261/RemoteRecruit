//
//  JobListViewModelTests.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import XCTest
import Combine
@testable import RemoteRecruit

@MainActor
final class JobListViewModelTests: XCTestCase {

    var sut: JobListViewModel!
    var mockFetch: MockFetchJobsUseCase!
    var cancellables = Set<AnyCancellable>()

    // Shared stub data
    let sampleJobs: [Job] = [
        .stub(id: "1", title: "iOS Engineer",   companyName: "Apple",  location: "Remote USA"),
        .stub(id: "2", title: "Android Dev",    companyName: "Google", location: "Remote Europe"),
        .stub(id: "3", title: "iOS Contractor", companyName: "Toptal", location: "Worldwide")
    ]

    override func setUp() {
        super.setUp()
        mockFetch = MockFetchJobsUseCase()
        sut = JobListViewModel(fetchJobsUseCase: mockFetch)
    }

    override func tearDown() {
        sut = nil
        mockFetch = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - loadJobs()

    func test_loadJobs_setsLoadingStateFirst() async {
        mockFetch.stubbedJobs = sampleJobs

        // Capture state transitions
        var states: [ViewState] = []
        sut.$viewState
            .sink { states.append($0) }
            .store(in: &cancellables)

        await sut.loadJobs()

        XCTAssertTrue(states.contains(.loading), "Should pass through .loading state")
    }

    func test_loadJobs_success_setsLoadedState() async {
        mockFetch.stubbedJobs = sampleJobs

        await sut.loadJobs()

        XCTAssertEqual(sut.viewState, .loaded)
    }

    func test_loadJobs_success_populatesJobs() async {
        mockFetch.stubbedJobs = sampleJobs

        await sut.loadJobs()

        XCTAssertEqual(sut.jobs.count, 3)
    }

    func test_loadJobs_emptyResult_setsEmptyState() async {
        mockFetch.stubbedJobs = []

        await sut.loadJobs()

        XCTAssertEqual(sut.viewState, .empty)
        XCTAssertTrue(sut.jobs.isEmpty)
    }

    func test_loadJobs_failure_setsErrorState() async {
        mockFetch.shouldThrow = true

        await sut.loadJobs()

        if case .error(_) = sut.viewState {
            // pass
        } else {
            XCTFail("Expected .error state, got \(sut.viewState)")
        }
    }

    func test_loadJobs_failure_jobsRemainsEmpty() async {
        mockFetch.shouldThrow = true

        await sut.loadJobs()

        XCTAssertTrue(sut.jobs.isEmpty)
    }

    func test_loadJobs_errorMessage_isNotEmpty() async {
        mockFetch.shouldThrow = true

        await sut.loadJobs()

        if case .error(let msg) = sut.viewState {
            XCTAssertFalse(msg.isEmpty)
        } else {
            XCTFail("Expected .error state")
        }
    }

    // MARK: - Local Search (handleSearch via searchText)

    func test_search_byTitle_filtersCorrectly() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "iOS"
        // Wait for debounce (400ms) + buffer
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(sut.jobs.count, 2)
        XCTAssertTrue(sut.jobs.allSatisfy { $0.title.localizedCaseInsensitiveContains("iOS") })
    }

    func test_search_byCompanyName_filtersCorrectly() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "Google"
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(sut.jobs.count, 1)
        XCTAssertEqual(sut.jobs.first?.companyName, "Google")
    }

    func test_search_byLocation_filtersCorrectly() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "Europe"
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(sut.jobs.count, 1)
        XCTAssertEqual(sut.jobs.first?.location, "Remote Europe")
    }

    func test_search_caseInsensitive() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "ios"   // lowercase
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(sut.jobs.count, 2)
    }

    func test_search_noMatch_setsEmptyState() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "Flutter"
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(sut.viewState, .empty)
        XCTAssertTrue(sut.jobs.isEmpty)
    }

    func test_search_clearText_restoresAllJobs() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "iOS"
        try? await Task.sleep(nanoseconds: 600_000_000)
        XCTAssertEqual(sut.jobs.count, 2)

        sut.searchText = ""
        try? await Task.sleep(nanoseconds: 600_000_000)
        XCTAssertEqual(sut.jobs.count, 3)
        XCTAssertEqual(sut.viewState, .loaded)
    }

    func test_search_whitespaceOnly_restoresAllJobs() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "   "
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertEqual(sut.jobs.count, 3)
        XCTAssertEqual(sut.viewState, .loaded)
    }

    func test_search_doesNotCallAPI_onlyFiltersLocally() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        let callCountBefore = mockFetch.executeCallCount

        sut.searchText = "iOS"
        try? await Task.sleep(nanoseconds: 600_000_000)

        // API must NOT be called again for local search
        XCTAssertEqual(mockFetch.executeCallCount, callCountBefore)
    }

    // MARK: - retry()

    func test_retry_reloadsJobs() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()
        XCTAssertEqual(sut.jobs.count, 3)

        mockFetch.stubbedJobs = [.stub(id: "99", title: "New Job")]
        sut.retry()
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertEqual(sut.jobs.count, 1)
        XCTAssertEqual(sut.jobs.first?.title, "New Job")
    }

    func test_retry_afterError_recoversToLoadedState() async {
        mockFetch.shouldThrow = true
        await sut.loadJobs()

        if case .error(_) = sut.viewState { } else {
            XCTFail("Setup failed")
        }

        mockFetch.shouldThrow = false
        mockFetch.stubbedJobs = sampleJobs
        sut.retry()
        try? await Task.sleep(nanoseconds: 200_000_000)

        XCTAssertEqual(sut.viewState, .loaded)
    }

    // MARK: - allJobs integrity

    func test_search_doesNotMutateAllJobs() async {
        mockFetch.stubbedJobs = sampleJobs
        await sut.loadJobs()

        sut.searchText = "iOS"
        try? await Task.sleep(nanoseconds: 600_000_000)
        XCTAssertEqual(sut.jobs.count, 2)

        // Clear search — allJobs must still have original 3
        sut.searchText = ""
        try? await Task.sleep(nanoseconds: 600_000_000)
        XCTAssertEqual(sut.jobs.count, 3)
    }
}
