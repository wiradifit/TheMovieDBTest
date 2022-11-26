//
//  MovieDetailsViewModelTests.swift
//  GLITechnicalTestTests
//
//  Created by Prawira Hadi Fitrajaya on 26/11/22.
//

import XCTest
@testable import GLITechnicalTest

class MovieDashboardViewModelTeste: XCTestCase {
    
    var sut: MovieDetailsViewModel!
    var mockMovieDetailsService: MockMovieDetailsService!
    
    override func setUp() {
        super.setUp()
        mockMovieDetailsService = MockMovieDetailsService()
        sut = MovieDetailsViewModel(service: mockMovieDetailsService)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieDetailsService = nil
        super.tearDown()
    }

    func test_fetch_youtube_trailer() {
        // Given
        let response = DataResponseMock.APIResponse.MovieDetails.youtubeTrailer
        let jsonData = response.data(using: .utf8)!
        mockMovieDetailsService.fetchYoutubeTrailerResponse = jsonData
        
        // When
        sut.getYoutubeTrailer(movieID: 49026)
        
        // Assert
        XCTAssert(mockMovieDetailsService!.isFetchYoutubeTrailerCalled)
    }
    
    func test_fetch_youtube_trailer_fail() {
        // Given
        let error = NetworkingError.invalidResponse
        mockMovieDetailsService.fetchYoutubeTrailerResponse = nil
        
        // When
        sut.getYoutubeTrailer(movieID: 49026)
        
        // Assert
        XCTAssertEqual(mockMovieDetailsService!.failFetchYoutubeTrailerCalled, error.localizedDescription)
    }
    
    func test_fetch_movie_review() {
        // Given
        let response = DataResponseMock.APIResponse.MovieDetails.movieReviews
        let jsonData = response.data(using: .utf8)!
        mockMovieDetailsService.fetchMovieReviewsResponse = jsonData
        
        // When
        sut.getMoviesReview(movieID: 49026)
        
        // Assert
        XCTAssert(mockMovieDetailsService!.isFetchMovieReviewsCalled)
    }
    
    func test_fetch_movie_review_fail() {
        // Given
        let error = NetworkingError.invalidResponse
        mockMovieDetailsService.fetchMovieReviewsResponse = nil
        
        // When
        sut.getMoviesReview(movieID: 49026)
        
        // Assert
        XCTAssertEqual(mockMovieDetailsService!.failFetchMovieReviewsCalled, error.localizedDescription)
    }
    
    func test_create_movie_review_cell_view_model() {
        // Given
        let response = DataResponseMock.APIResponse.MovieDetails.movieReviews
        let jsonData = response.data(using: .utf8)!
        let movieReview: MovieReview = try! JSONDecoder().decode(MovieReview.self, from: jsonData)
        
        mockMovieDetailsService.completionReviews = movieReview.results!
        mockMovieDetailsService.fetchMovieReviewsResponse = jsonData
        
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadTableView = { () in
            expect.fulfill()
        }

        // When
        sut.getMoviesReview(movieID: 49026)

        // Assert
        XCTAssertEqual(sut.numberOfCells, movieReview.results?.count)
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_get_cell_view_model() {
        //Given
        getFinishedMovieReviews()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testReview = mockMovieDetailsService.completionReviews[indexPath.row]
        
        // When
        sut.getMoviesReview(movieID: 49026)
        let vm = sut.getCellViewModel(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.authorReview, testReview.content)
    }
    
}

extension MovieDashboardViewModelTeste {
    private func getFinishedMovieReviews() {
        let response = DataResponseMock.APIResponse.MovieDetails.movieReviews
        let jsonData = response.data(using: .utf8)!
        let movieReview: MovieReview = try! JSONDecoder().decode(MovieReview.self, from: jsonData)
        
        mockMovieDetailsService.completionReviews = movieReview.results!
        mockMovieDetailsService.fetchMovieReviewsResponse = jsonData
    }
}
  
class MockMovieDetailsService: MovieDetailsProtocol {

    var isFetchYoutubeTrailerCalled = false
    var failFetchYoutubeTrailerCalled = String()
    var fetchYoutubeTrailerResponse: Any?

    var isFetchMovieReviewsCalled = false
    var failFetchMovieReviewsCalled = String()
    var fetchMovieReviewsResponse: Any?
    var completionReviews: [MovieReviewResult] = [MovieReviewResult]()

    func youtubeVideos<T>(movieID: Int, responseType: T.Type, completion: @escaping (GLITechnicalTest.APIResult<T>) -> Void) where T : Decodable {
        if let json = fetchYoutubeTrailerResponse {
            let response = try! JSONDecoder().decode(YoutubeVideo.self, from: json as! Data)

            completion(.success(response as! T))
            isFetchYoutubeTrailerCalled = true
        } else {
            completion(.failure(NetworkingError.invalidResponse))
            failFetchYoutubeTrailerCalled = NetworkingError.invalidResponse.localizedDescription
        }
    }
    
    func movieReviews<T>(movieID: Int, responseType: T.Type, completion: @escaping (GLITechnicalTest.APIResult<T>) -> Void) where T : Decodable {
        if let json = fetchMovieReviewsResponse {
            let response = try! JSONDecoder().decode(MovieReview.self, from: json as! Data)
            completion(.success(response as! T))
            isFetchMovieReviewsCalled = true
        } else {
            completion(.failure(NetworkingError.invalidResponse))
            failFetchMovieReviewsCalled = NetworkingError.invalidResponse.localizedDescription
        }
    }
}
