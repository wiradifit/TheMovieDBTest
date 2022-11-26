//
//  MovieDetailsServiceTests.swift
//  GLITechnicalTestTests
//
//  Created by Prawira Hadi Fitrajaya on 26/11/22.
//

import XCTest
@testable import GLITechnicalTest

class MovieDetailsServiceTests: XCTestCase {
    
    var sut: MovieDetailsService?
    
    override func setUp() {
        super.setUp()
        sut = MovieDetailsService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_youtube_trailer() {
        let sut = self.sut!
        let expect = XCTestExpectation(description: "callback youtube")

        sut.youtubeVideos(movieID: 49026, responseType: YoutubeVideo.self) { result in
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
    
    func test_fetch_movie_reviews() {
        let sut = self.sut!
        let expect = XCTestExpectation(description: "callback movie reviews")

        sut.movieReviews(movieID: 49026, responseType: MovieReview.self) { result in
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
