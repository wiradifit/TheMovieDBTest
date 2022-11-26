//
//  MovieDetailsViewModel.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 25/11/22.
//

import Foundation

class MovieDetailsViewModel {
    
    var service : MovieDetailsProtocol?
    
    var movieReviewResults = MovieReviewResults()
    
    private var movieDetailsCellViewModel = [MovieDetailsCellViewModel]() {
        didSet {
            reloadTableView?()
        }
    }
    
    var numberOfCells: Int {
        return movieDetailsCellViewModel.count
    }
    
    var getYoutubeResult : ((_ response : [YoutubeVideoResult]) -> Void)?
    var setEmptyReviewContainer : ((Int) -> Void)?
    var reloadTableView: (() -> Void)?
    var failedGetResponse : ((String) -> Void)?
    
    init(service: MovieDetailsProtocol = MovieDetailsService()) {
        self.service = service
    }
    
    func getYoutubeTrailer(movieID: Int){
        service?.youtubeVideos(movieID: movieID, responseType: YoutubeVideo.self, completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.getYoutubeResult?(response.results ?? [])
            case .failure(let error):
                self?.failedGetResponse?(error.localizedDescription)
            }
        })
    }
    
    func getMoviesReview(movieID: Int){
        service?.movieReviews(movieID: movieID, responseType: MovieReview.self, completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.fetchData(movieReviewResults: response.results!)
                self?.setEmptyReviewContainer?(response.totalResults!)
            case .failure(let error):
                self?.failedGetResponse?(error.localizedDescription)
            }
        })
    }
    
    func fetchData(movieReviewResults: MovieReviewResults) {
        self.movieReviewResults = movieReviewResults
        var vms = [MovieDetailsCellViewModel]()
        
        for movieReviewResult in movieReviewResults {
            vms.append(createCellModel(movieReviewResult: movieReviewResult))
        }
        
        movieDetailsCellViewModel = vms
    }
    
    func createCellModel(movieReviewResult: MovieReviewResult) -> MovieDetailsCellViewModel {
        let authorName = movieReviewResult.authorDetails?.name ?? ""
        let reviewRating = movieReviewResult.authorDetails?.rating ?? 0
        let authorReview = movieReviewResult.content ?? ""
        
        return MovieDetailsCellViewModel(authorName: authorName, reviewRating: reviewRating, authorReview: authorReview)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> MovieDetailsCellViewModel {
        return movieDetailsCellViewModel[indexPath.row]
    }
}
