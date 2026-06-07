//
//  FetchJobsUseCaseTests.swift
//  RemoteRecruit
//
//  Created by Rashida on 7/06/26.
//

import XCTest
@testable import RemoteRecruit

final class FetchJobsUseCaseTests: XCTestCase {
    var sut: FetchJobsUseCase!
    var mockRepo: MockJobRepository!

    override func setUp() {
        mockRepo = MockJobRepository()
        sut = FetchJobsUseCase(repository: mockRepo)
    }

    func test_execute_returnsJobsFromRepository() async throws {
        mockRepo.stubbedJobs = [.stub(), .stub(id: "2", title: "Android Dev")]
        let result = try await sut.execute()
        XCTAssertEqual(result.count, 2)
    }

    func test_execute_throwsWhenRepositoryThrows() async {
        mockRepo.shouldThrow = true
        do {
            _ = try await sut.execute()
            XCTFail("Expected error")
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
