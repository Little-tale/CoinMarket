//
//  APIReqeustManager.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import Foundation
import Alamofire

enum APIError:Error {
    case canMakeResults
    case networkError
    case clientError
    case serverError
    case modelError
    case dataNoHave
    
    var title: String {
       return "에러발생"
    }
    
    var message: String {
        switch self {
        case .canMakeResults:
            "통신에 문제가 발생했어요!"
        case .networkError:
            "통신에 문제가 발생했어요!"
        case .clientError:
            "통신 상태를 확인해주세요"
        case .serverError:
            "현재 서버의 문제가 있어요!"
        case .modelError:
            "앱을 재설치해 주세요!"
        case .dataNoHave:
            "통신에 문제가 발생했어요!"
        }
    }
    
}
// https://api.coingecko.com/api/v3/coins/markets?vs_currency=krw&ids=bitcoin&sparkline=true
class APIReqeustManager {
    private init() {}
    static let shared = APIReqeustManager()
    // MARK: 혹시모를 대안
    func fetchRequest<T:Decodable>(type: T.Type,api: APIType,
                                   completionHandler: @escaping(Result<T, APIError>) -> Void){
        let baseURL = api.baseURL
        let query = api.query
        let url = baseURL + query
        
        
        print("@@@@",url,#function)
        AF.request(url).responseDecodable(of: T.self) { results in

            switch results.result {
               
            case .success(let success):
                
                completionHandler(.success(success))
            case .failure(let failure):
                
                if let error = failure.asAFError {
                    switch error {
                    case .responseValidationFailed(reason: let reason):
                        switch reason {
                        case .dataFileNil :
                            completionHandler(.failure(.dataNoHave))
            
                        default:
                            completionHandler(.failure(.canMakeResults))
                            print(error)
                        }
                        
                    default:
                        completionHandler(.failure(.canMakeResults))
                        print(error)
                    }
                }
                // https://gist.github.com/perlguy99/f7f336b66ccb27fcc148b7d5bdbc9a3f
                if let status = results.response?.statusCode {
                    switch status {
                    case 200:
                        completionHandler(.failure(.modelError))
                    case 400...499:
                        completionHandler(.failure(.clientError))
                    case 500...599:
                        completionHandler(.failure(.serverError))
                    default:
                        completionHandler(.failure(.canMakeResults))
                        print(status)
                    }
                }
            }
        }
    }
    // completionHandler(.failure(.canMakeResults))
   
}

/*
 func fetchRequest<T:>(type: T.Type,api: APIType,
                                completionHandler: @escaping(Result<T, APIError>) -> Void){
     let baseURL = api.baseURL
     let query = api.query
     let url = baseURL + query
     
     AF.request(url).responseDecodable(of: T.self) { results in
         switch results.result {
         case .success(let success):
             completionHandler(.success(success))
         case .failure(let failure):
             completionHandler(.failure(.canMakeResults))
         }
     }
 }
 */
