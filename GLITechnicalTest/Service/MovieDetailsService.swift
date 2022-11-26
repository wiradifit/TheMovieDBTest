//
//  MovieDetailsService.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 26/11/22.
//

import Foundation

public protocol MovieDetailsProtocol: AnyObject {

    func youtubeVideos<T: Decodable>(movieID: Int, responseType: T.Type, completion: @escaping (APIResult<T>) -> Void)
    func movieReviews<T: Decodable>(movieID: Int, responseType: T.Type, completion: @escaping (APIResult<T>) -> Void)
}

public class MovieDetailsService : MovieDetailsProtocol {
    
    public static let shared = MovieDetailsService()

    public func youtubeVideos<T: Decodable>(movieID: Int, responseType: T.Type, completion: @escaping (APIResult<T>) -> Void) {
        
        NetworkingService.shared.request(.GET,"movie/\(movieID)/videos" , responseType: responseType) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    public func movieReviews<T: Decodable>(movieID: Int, responseType: T.Type, completion: @escaping (APIResult<T>) -> Void) {
        
        NetworkingService.shared.request(.GET,"movie/\(movieID)/reviews" , responseType: responseType) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
