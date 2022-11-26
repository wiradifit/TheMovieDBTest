//
//  MovieDBServices.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 24/11/22.
//

import Foundation

public protocol MovieDashboardProtocol: AnyObject {
    
    func popularMovies<T: Decodable>(page: Int, responseType: T.Type, completion: @escaping (APIResult<T>) -> Void)    
}

public class MovieDashboardService : MovieDashboardProtocol {
    
    public static let shared = MovieDashboardService()

    public func popularMovies<T: Decodable>(page: Int, responseType: T.Type, completion: @escaping (APIResult<T>) -> Void) {
        
        let parameters = [
            "page": page,
            "region": "ID"] as [String : Any]
        
        NetworkingService.shared.request(.GET,"movie/popular", parameters: parameters , responseType: responseType) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
