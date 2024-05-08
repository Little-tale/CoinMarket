//
//  URLSessionManager.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 5/8/24.
//

import Foundation



final class URLSessionManager {
   
    private init() {}
    
    static let shared = URLSessionManager()
    
    
    func fetchCoin<T:Decodable>(type: T.Type, apiType:APIType) async throws -> T {
        
        let baseURL = apiType.baseURL
        let query = apiType.query
       
        guard let url = URL(string: baseURL + query) else {
            throw APIError.canMakeResults
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        let jsDecode = JSONDecoder()
        jsDecode.keyDecodingStrategy = .useDefaultKeys
        
        do {
            let model = try jsDecode.decode(type, from: data)
            return model
        } catch {
            throw APIError.modelError
        }
    }
    
}
