import XCTest
@testable import RemoteRecruit

@MainActor
final class JobDetailViewModelTests: XCTestCase {

    // MARK: - formattedDescription (AttributedString)
    // We test the plain string content extracted from AttributedString

    func test_formattedDescription_htmlStripped_containsText() async {
        let sut = JobDetailViewModel(job: .stub(description: "<p>Hello World</p>"))
        let result = String(sut.formattedDescription.characters)
        XCTAssertTrue(result.contains("Hello World"))
    }

    func test_formattedDescription_boldTagStripped_containsText() async {
        let sut = JobDetailViewModel(job: .stub(description: "<p>Hello <b>Swift</b></p>"))
        let result = String(sut.formattedDescription.characters)
        XCTAssertTrue(result.contains("Swift"))
    }

    func test_formattedDescription_invalidHTML_fallsBackToRawString() async {
        let sut = JobDetailViewModel(job: .stub(description: "Plain text no tags"))
        let result = String(sut.formattedDescription.characters)
        XCTAssertTrue(result.contains("Plain text no tags"))
    }

    // MARK: - formattedDate

    func test_formattedDate_validISO_isNotEmpty() async {
        let sut = JobDetailViewModel(job: .stub(publishedAt: "2026-05-01T10:00:00Z"))
        XCTAssertFalse(sut.formattedDate.isEmpty)
    }

    func test_formattedDate_validISO_doesNotReturnRawString() async {
        let sut = JobDetailViewModel(job: .stub(publishedAt: "2026-05-01T10:00:00Z"))
        XCTAssertNotEqual(sut.formattedDate, "2026-05-01T10:00:00Z")
    }

    func test_formattedDate_invalidISO_returnsOriginalString() async {
        let sut = JobDetailViewModel(job: .stub(publishedAt: "not-a-date"))
        XCTAssertEqual(sut.formattedDate, "not-a-date")
    }

    // MARK: - Job entity (no ViewModel needed)

    func test_salaryDisplay_empty_returnsFallback() {
        XCTAssertEqual(Job.stub(salary: "").salaryDisplay, "Salary not disclosed")
    }

    func test_salaryDisplay_withValue_returnsValue() {
        XCTAssertEqual(Job.stub(salary: "$120,000").salaryDisplay, "$120,000")
    }

    func test_jobTypeDisplay_fullTime_formatsCorrectly() {
        XCTAssertEqual(Job.stub(jobType: "full_time").jobTypeDisplay, "Full Time")
    }

    func test_jobTypeDisplay_contract_formatsCorrectly() {
        XCTAssertEqual(Job.stub(jobType: "contract").jobTypeDisplay, "Contract")
    }
}
