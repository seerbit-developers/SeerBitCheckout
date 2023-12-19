//
//  ApiClient.swift
//  seerbit_native_ios_sdk
//
//  Created by Miracle Eugene on 26/10/2023.
//

import Foundation

let bearerToken = "68826aea9005de7812429b7983838b06e2c7fffbb3d9487f33bc51c943a3a499"

enum NetworkErrors : Error {
    case networkError(description: String)
    case parseingError(description: String)
    case noDataError(description: String)
    case apiError(description: String)
}

public enum HTTPRequestMethod: String {
    case get="GET"
    case post="POST"
    case put="PUT"
    case patch="PATCH"
    case delete="DELETE"
}

class APIClient {
    
    func makeAPIRequest<Request: Codable, Response: Codable>(
      url: String,
      method: HTTPRequestMethod,
      parameters: Request? = nil,
      completion: @escaping (Result<Response, Error>) -> Void
    ) {

        var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(bearerToken)"]
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        if let parameters = parameters, method != .get {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(parameters)

        urlRequest.httpBody = jsonData
      }

      URLSession.shared.dataTask(with: urlRequest) { data, response, error in
          
//            let httpResponse = response as? HTTPURLResponse
//          print(httpResponse?.statusCode, "resdfd")
          
        if let error = error {
            completion(.failure(error))
          return
        }

        guard let data = data else {
            completion(.failure(error as! NetworkErrors))
          return
        }
          
              do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Response.self, from: data)
                  completion(.success(decodedData))
              } catch {
                  completion(.failure(error))
              }
      }.resume()
    }
}
