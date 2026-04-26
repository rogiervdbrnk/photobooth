import XCTest
@testable import Photostrip

final class PhotoboothSessionTests: XCTestCase {

    func testInitialState() {
        let session = PhotoboothSession(configuration: .three, stripText: "")
        XCTAssertEqual(session.totalShots, 3)
        XCTAssertEqual(session.shotsTaken, 0)
        XCTAssertEqual(session.remainingShots, 3)
        XCTAssertFalse(session.isComplete)
        XCTAssertEqual(session.stripBackgroundStyle, .classicWhite)
        XCTAssertEqual(session.photoFilter, .original)
        XCTAssertEqual(session.photoFrameStyle, .none)
    }

    func testAddPhoto() {
        let session = PhotoboothSession(configuration: .two, stripText: "")
        let image = UIImage()
        session.addPhoto(image)
        XCTAssertEqual(session.shotsTaken, 1)
        XCTAssertEqual(session.remainingShots, 1)
        XCTAssertFalse(session.isComplete)
    }

    func testIsCompleteAfterAllShots() {
        let session = PhotoboothSession(configuration: .one, stripText: "")
        session.addPhoto(UIImage())
        XCTAssertTrue(session.isComplete)
        XCTAssertEqual(session.remainingShots, 0)
    }

    func testCannotAddMoreThanAllowed() {
        let session = PhotoboothSession(configuration: .one, stripText: "")
        session.addPhoto(UIImage())
        session.addPhoto(UIImage()) // moet genegeerd worden
        XCTAssertEqual(session.shotsTaken, 1)
    }

    func testReset() {
        let session = PhotoboothSession(configuration: .three, stripText: "")
        session.addPhoto(UIImage())
        session.addPhoto(UIImage())
        session.reset()
        XCTAssertEqual(session.shotsTaken, 0)
        XCTAssertFalse(session.isComplete)
    }

    func testCanStoreSelectedStripStyles() {
        let session = PhotoboothSession(
            configuration: .two,
            stripText: "Lois 13",
            stripBackgroundStyle: .purpleStars,
            photoFilter: .sepia,
            photoFrameStyle: .confetti
        )

        XCTAssertEqual(session.stripText, "Lois 13")
        XCTAssertEqual(session.stripBackgroundStyle, .purpleStars)
        XCTAssertEqual(session.photoFilter, .sepia)
        XCTAssertEqual(session.photoFrameStyle, .confetti)
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

final class PhotoFilterServiceTests: XCTestCase {

    func testOriginalFilterReturnsInputImage() {
        let service = PhotoFilterService()
        let image = makeTestImage()

        let result = service.applyFilter(.original, to: image)

        XCTAssertEqual(result.pngData(), image.pngData())
    }

    func testStyledFiltersPreserveImageSize() {
        let service = PhotoFilterService()
        let image = makeTestImage()

        for option in PhotoFilterOption.allCases where option != .original {
            let result = service.applyFilter(option, to: image)

            XCTAssertEqual(result.size.width, image.size.width, accuracy: 0.001)
            XCTAssertEqual(result.size.height, image.size.height, accuracy: 0.001)
            XCTAssertNotNil(result.cgImage)
        }
    }

    func testServiceFallsBackToOriginalImageWhenInputCannotBeProcessed() {
        let service = PhotoFilterService()
        let image = UIImage()

        let result = service.applyFilter(.sepia, to: image)

        XCTAssertEqual(result.pngData(), image.pngData())
    }

    private func makeTestImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return renderer.image { context in
            UIColor.systemPink.setFill()
            context.fill(CGRect(x: 0, y: 0, width: 20, height: 40))
            UIColor.systemBlue.setFill()
            context.fill(CGRect(x: 20, y: 0, width: 20, height: 20))
            UIColor.systemYellow.setFill()
            context.fill(CGRect(x: 20, y: 20, width: 20, height: 20))
        }
    }
}
