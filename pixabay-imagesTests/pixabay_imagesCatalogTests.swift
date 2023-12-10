//
//  pixabay_imagesCatalogTests.swift
//  pixabay-imagesTests
//
//  Created by Nikita Zaitsev on 10/12/2023.
//

import XCTest
@testable import pixabay_images

final class pixabay_imagesCatalogTests: XCTestCase {

    private var viewModel: ImagesCatalogViewModel!

    override func setUpWithError() throws {
        viewModel = ImagesCatalogViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_ViewModel_init() {
        XCTAssertEqual(viewModel.total, 0)
        XCTAssertEqual(viewModel.images, [])
        XCTAssertEqual(viewModel.nextPage, 1)
        XCTAssertEqual(viewModel.selectedItems, [])
        XCTAssertEqual(viewModel.query, "")
    }

    func test_ViewModel_isLastPage_shouldBeFalseOnInit() {
        XCTAssertFalse(viewModel.isLastPage)
    }

    func test_ViewModel_isLastPage_shouldBeTrueWhenTotalEqualsCount() {
        viewModel.images = [.init(id: 1, previewURL: URL(fileURLWithPath: "")), .init(id: 2, previewURL: URL(fileURLWithPath: ""))]
        viewModel.total = 2
        XCTAssertTrue(viewModel.isLastPage)
    }

    func test_ViewModel_isLastPage_shouldBeFalseWhenTotalIsNotEqualsCount() {
        viewModel.images = [.init(id: 1, previewURL: URL(fileURLWithPath: "")), .init(id: 2, previewURL: URL(fileURLWithPath: ""))]
        viewModel.total = 3
        XCTAssertFalse(viewModel.isLastPage)
    }

    func test_ViewModel_imageRequest_ValuesShouldBeEqual() {
        let request = viewModel.imagesRequest
        XCTAssertEqual(request.page, viewModel.nextPage)
        XCTAssertEqual(request.query, viewModel.query)
    }

    func test_ViewModel_shouldClearDataWhenUpdateQuery() {
        viewModel.images = [.init(id: 1, previewURL: URL(fileURLWithPath: "")), .init(id: 2, previewURL: URL(fileURLWithPath: ""))]
        viewModel.total = 3
        viewModel.nextPage = 2
        viewModel.selectedItems = Set(viewModel.images)
        viewModel.updateQuery("random")
        XCTAssertEqual(viewModel.total, 0)
        XCTAssertEqual(viewModel.images, [])
        XCTAssertEqual(viewModel.nextPage, 1)
        XCTAssertEqual(viewModel.selectedItems, [])
        XCTAssertEqual(viewModel.query, "random")
    }

    func test_ViewModel_ValuesShouldNotChangeWhithEqualQueryValue() {
        let images: [Image] = [.init(id: 1, previewURL: URL(fileURLWithPath: "")), .init(id: 2, previewURL: URL(fileURLWithPath: ""))]
        let selectedImages = Set(images)
        let total = 3
        let nextPage = 2
        let emptyQuery = ""
        viewModel.images = images
        viewModel.total = total
        viewModel.nextPage = nextPage
        viewModel.selectedItems = selectedImages
        viewModel.updateQuery(emptyQuery)
        XCTAssertEqual(viewModel.total, total)
        XCTAssertEqual(viewModel.images, images)
        XCTAssertEqual(viewModel.nextPage, nextPage)
        XCTAssertEqual(viewModel.selectedItems, selectedImages)
        XCTAssertEqual(viewModel.query, emptyQuery)
    }
}
