//
//  MovieDashboardViewModel.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 24/11/22.
//

import Foundation

class MovieDashboardViewModel {
    
    var service : MovieDashboardProtocol?
    
    var movieResults = MovieResults()
    
    private var movieDashboardCellViewModel = [MovieDashboardCellViewModel]() {
        didSet {
            self.reloadCollectionView?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return movieDashboardCellViewModel.count
    }

    var reloadCollectionView: (() -> ())?
    var showAlertClosure: (() -> ())?
    
    init(service: MovieDashboardProtocol = MovieDashboardService()) {
        self.service = service
    }
    
    func getPopularMovies(page: Int){
        service?.popularMovies(page: page, responseType: Movie.self, completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.fetchData(movieResults: response.results ?? [])
            case .failure(let error):
                self?.alertMessage = error.localizedDescription
            }
        })
    }
    
    func getMorePopularMovies(page: Int){
        service?.popularMovies(page: page, responseType: Movie.self, completion: { [weak self] result in
            switch result {
            case .success(let response):
                self?.fetchMoreData(movieResults: response.results ?? [])
            case .failure(let error):
                self?.alertMessage = error.localizedDescription
            }
        })
    }
    
    func fetchData(movieResults: MovieResults) {
        self.movieResults = movieResults
        var vms = [MovieDashboardCellViewModel]()
        
        for movieResult in movieResults {
            vms.append(createCellModel(movieResult: movieResult))
        }
        
        self.movieDashboardCellViewModel = vms
    }
    
    func fetchMoreData(movieResults: MovieResults) {
        var vms = [MovieDashboardCellViewModel]()
        
        for movieResult in movieResults {
            vms.append(createCellModel(movieResult: movieResult))
            self.movieResults.append(movieResult)
        }
        
        for vms in vms {
            self.movieDashboardCellViewModel.append(vms)
        }
    }
    
    func createCellModel(movieResult: MovieResult) -> MovieDashboardCellViewModel {
        let posterImage = movieResult.posterStringURL
        
        return MovieDashboardCellViewModel(posterImage: posterImage)
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> MovieDashboardCellViewModel {
        return movieDashboardCellViewModel[indexPath.row]
    }
    
    func getMovieResult(at indexPath: IndexPath) -> MovieResult {
        return movieResults[indexPath.row]
    }
}
