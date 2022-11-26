//
//  MovieDBServiceTests.swift
//  GLITechnicalTestTests
//
//  Created by Prawira Hadi Fitrajaya on 24/11/22.
//

import XCTest
@testable import GLITechnicalTest

class MovieDashboardServiceTests: XCTestCase {
    
    var sut: MovieDashboardService?
    
    override func setUp() {
        super.setUp()
        sut = MovieDashboardService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_popular_movie() {
        let sut = self.sut!
        let expect = XCTestExpectation(description: "callback movie")

        sut.popularMovies(page: 1, responseType: Movie.self) { result in
            expect.fulfill()
            switch result {
            case .success(let response):
                XCTAssertNotNil(response.results)
            case .failure(_):
                return
            }
        }
        
        wait(for: [expect], timeout: 3)
    }
}
