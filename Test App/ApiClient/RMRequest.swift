//
//  RMRequest.swift
//  Test App
//
//  Created by wadmin on 30/05/25.
//

import Foundation

final class RMRequest {
    
    private struct Constants {
        static let baseURLString = "https://rickandmortyapi.com/api"
    }
    
    public let httpMethod: String
    
    private let endpoint: RMEndpoint
    
    private let pathComponents: [String]
    
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseURLString
        string += "/"
        string += endpoint.rawValue
        
        if !pathComponents.isEmpty {
            string += "/" + pathComponents.joined(separator: "/")
        }
        
        return string
    }

    
    public var url: URL? {
        guard var urlComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        if !queryParameters.isEmpty {
            urlComponents.queryItems = queryParameters
        }
        
        return urlComponents.url
    }

    public init(
        endpoint: RMEndpoint,
        pathComponents: [String] = [],
        queryParameters: [String: String] = [:],
        httpMethod: String = "GET"
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        self.httpMethod = httpMethod
    }
}

extension RMRequest {

    static let listCharactersRequests = RMRequest(endpoint: .characters)
    static let listEpisodesRequest = RMRequest(endpoint: .episodes)
    static let listLocationsRequest = RMRequest(endpoint: .locations)
}
