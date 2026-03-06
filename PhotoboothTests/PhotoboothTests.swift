import XCTest
@testable import Photobooth

final class PhotoboothSessionTests: XCTestCase {

    func testInitialState() {
        let session = PhotoboothSession(configuration: .three)
        XCTAssertEqual(session.totalShots, 3)
        XCTAssertEqual(session.shotsTaken, 0)
        XCTAssertEqual(session.remainingShots, 3)
        XCTAssertFalse(session.isComplete)
    }

    func testAddPhoto() {
        let session = PhotoboothSession(configuration: .two)
        let image = UIImage()
        session.addPhoto(image)
        XCTAssertEqual(session.shotsTaken, 1)
        XCTAssertEqual(session.remainingShots, 1)
        XCTAssertFalse(session.isComplete)
    }

    func testIsCompleteAfterAllShots() {
        let session = PhotoboothSession(configuration: .one)
        session.addPhoto(UIImage())
        XCTAssertTrue(session.isComplete)
        XCTAssertEqual(session.remainingShots, 0)
    }

    func testCannotAddMoreThanAllowed() {
        let session = PhotoboothSession(configuration: .one)
        session.addPhoto(UIImage())
        session.addPhoto(UIImage()) // moet genegeerd worden
        XCTAssertEqual(session.shotsTaken, 1)
    }

    func testReset() {
        let session = PhotoboothSession(configuration: .three)
        session.addPhoto(UIImage())
        session.addPhoto(UIImage())
        session.reset()
        XCTAssertEqual(session.shotsTaken, 0)
        XCTAssertFalse(session.isComplete)
    }
}

final class ShotConfigurationTests: XCTestCase {

    func testRawValues() {
        XCTAssertEqual(ShotConfiguration.one.rawValue,   1)
        XCTAssertEqual(ShotConfiguration.two.rawValue,   2)
        XCTAssertEqual(ShotConfiguration.three.rawValue, 3)
    }

    func testDisplayNames() {
        XCTAssertEqual(ShotConfiguration.one.displayName,   "1 foto")
        XCTAssertEqual(ShotConfiguration.two.displayName,   "2 foto's")
        XCTAssertEqual(ShotConfiguration.three.displayName, "3 foto's")
    }

    func testAllCasesCount() {
        XCTAssertEqual(ShotConfiguration.allCases.count, 3)
    }
}
