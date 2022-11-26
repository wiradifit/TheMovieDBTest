//
//  MovieDashboardViewModelTeste.swift
//  GLITechnicalTestTests
//
//  Created by Prawira Hadi Fitrajaya on 26/11/22.
//

import XCTest
@testable import GLITechnicalTest

class MovieDashboardViewModelTest: XCTestCase {
    
    var sut: MovieDashboardViewModel!
    var mockMovieDashboardService: MockMovieDashboardService!
    
    override func setUp() {
        super.setUp()
        mockMovieDashboardService = MockMovieDashboardService()
        sut = MovieDashboardViewModel(service: mockMovieDashboardService)
    }
    
    override func tearDown() {
        sut = nil
        mockMovieDashboardService = nil
        super.tearDown()
    }
    
    func test_fetch_popular_movie() {
        // Given
        let response = DataResponseMock.APIResponse.MovieDashboard.popularMovie
        let jsonData = response.data(using: .utf8)!
        mockMovieDashboardService.fetchPopularMovieResponse = jsonData
        
        // When
        sut.getPopularMovies(page: 1)
        
        // Assert
        XCTAssert(mockMovieDashboardService!.isFetchPopularMovieCalled)
    }
    
    func test_fetch_popular_fail() {
        // Given
        let error = NetworkingError.invalidResponse
        mockMovieDashboardService.fetchPopularMovieResponse = nil
        
        // When
        sut.getPopularMovies(page: 1)
        
        // Assert
        XCTAssertEqual(mockMovieDashboardService!.failFetchPopularMovieCalled, error.localizedDescription)
    }
    
    func test_create_cell_view_model() {
        // Given
        let response = DataResponseMock.APIResponse.MovieDashboard.popularMovie
        let jsonData = response.data(using: .utf8)!
        let movie: Movie = try! JSONDecoder().decode(Movie.self, from: jsonData)
        
        mockMovieDashboardService.completionMovies = movie.results!
        mockMovieDashboardService.fetchPopularMovieResponse = jsonData
        
        let expect = XCTestExpectation(description: "reload closure triggered")
        sut.reloadCollectionView = { () in
            expect.fulfill()
        }
        
        // When
        sut.getPopularMovies(page: 1)
        
        // Assert
        XCTAssertEqual(sut.numberOfCells, movie.results?.count)
        wait(for: [expect], timeout: 1.0)
    }
    
    func test_get_cell_view_model() {
        //Given
        getFinishedMovie()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testMovie = mockMovieDashboardService.completionMovies[indexPath.row]
        
        // When
        sut.getPopularMovies(page: 1)
        let vm = sut.getCellViewModel(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.posterImage, testMovie.posterStringURL)
    }
    
    func test_get_movie_id_result() {
        //Given
        getFinishedMovie()
        
        let indexPath = IndexPath(row: 1, section: 0)
        let testMovie = mockMovieDashboardService.completionMovies[indexPath.row]
        
        // When
        sut.getPopularMovies(page: 1)
        let vm = sut.getMovieResult(at: indexPath)
        
        //Assert
        XCTAssertEqual( vm.id, testMovie.id)
    }
}

extension MovieDashboardViewModelTest {
    
    private func getFinishedMovie() {
        let response = DataResponseMock.APIResponse.MovieDashboard.popularMovie
        let jsonData = response.data(using: .utf8)!
        let movie: Movie = try! JSONDecoder().decode(Movie.self, from: jsonData)
        
        mockMovieDashboardService.completionMovies = movie.results!
        mockMovieDashboardService.fetchPopularMovieResponse = jsonData
    }
}

class MockMovieDashboardService: MovieDashboardProtocol {
    
    var isFetchPopularMovieCalled = false
    var failFetchPopularMovieCalled = String()
    var fetchPopularMovieResponse: Any?
    var completionMovies: [MovieResult] = [MovieResult]()
    
    func popularMovies<T>(page: Int, responseType: T.Type, completion: @escaping (GLITechnicalTest.APIResult<T>) -> Void) {
        if let json = fetchPopularMovieResponse {
            let response = try! JSONDecoder().decode(Movie.self, from: json as! Data)
            completion(.success(response as! T))
            isFetchPopularMovieCalled = true
        } else {
            completion(.failure(NetworkingError.invalidResponse))
            failFetchPopularMovieCalled = NetworkingError.invalidResponse.localizedDescription
        }
    }
}
