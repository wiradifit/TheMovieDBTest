//
//  NetworkingService.swift
//  GLITechnicalTest
//
//  Created by Prawira Hadi Fitrajaya on 24/11/22.
//

import Foundation

public typealias APIResult<T: Decodable> = Result<T, Error>

public final class Networking {
    
    public enum Method: String {
        case GET, POST, PATCH, PUT, DELETE
    }
}

protocol NetworkingServiceProtocol: AnyObject {
    
    func request<T: Decodable>(_  method: Networking.Method, _ endpoint: String, parameters: [String : Any], responseType: T.Type, completion: @escaping (_ result: Result<T, NetworkingError>) -> Void)
}

public final class NetworkingService: NetworkingServiceProtocol {
    
    public static let shared = NetworkingService()
    
    private func constructRequest(_ method: Networking.Method, _ endpoint: String, parameters: [String : Any] = [:]) -> URLRequest {
        
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2NDk1ZWJkYWU4ZWM5ODAwN2EwNzk1MzZlMWU0NTE3ZSIsInN1YiI6IjYzN2YxZDg1YTRhZjhmMDA3ZWVjMWYxNyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BOyahERwBvgWmW6qIMxgB-aVKF3xgM7e8BmDBbYMs5E"
        
        let defaultHeaders: [String: String] = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
        
        guard let url = URL.construct(endpoint) else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = defaultHeaders
        request.httpMethod = method.rawValue
        
        if method != .GET {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } else {
            request.url = URL.construct(endpoint, queries: parameters)
        }
        
        return request
    }
    
    func request<T: Decodable>(_ method: Networking.Method = .GET, _ endpoint: String, parameters: [String : Any] = [:], responseType: T.Type, completion: @escaping (_ result: Result<T, NetworkingError>) -> Void) {
        
        let request = constructRequest(method, endpoint, parameters: parameters)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(responseType, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(result), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
            
            let url = request.url?.absoluteString ?? ""
            var logOutput = "HTTP_REQUEST: \(method) \(url) \n"
            if method != .GET {
                logOutput += "BODY: \(parameters.debugDescription) \n"
            }
            if let responseJSON = String(data: data, encoding: .utf8) {
                logOutput += "JSON: \(responseJSON)"
            }
            print(logOutput)
            
        })
        task.resume()
    }
    
    private func executeCompletionHandlerInMainThread<T: Decodable>(with result: Result<T, NetworkingError>, completion: @escaping (Result<T, NetworkingError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
}

enum NetworkingError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
