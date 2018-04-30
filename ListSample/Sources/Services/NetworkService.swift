//
//  NetworkService.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/26/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

private enum FetchRequest {
    case args(q: String, pageSize: Int, page: Int)
    
    var parameters: Parameters {
        if case .args(let query, let pageSize, let page) = self {
            return ["q": query, "pageSize": pageSize, "page": page]
        }
        return [:]
    }
}

public struct NetworkService {

    func loadData(page: Int) -> Observable<[Article]> {
        return Observable<[Article]>.create { observer in
            let request = Alamofire.request(Router.readNews(fetchRequest: .args(q: "ubiquity", pageSize: 30, page: page)))
                .responseData { response in
                    switch response.result {
                    case .success(let data):
                        if let successResult = try? JSONDecoder().decode(SuccessResponse.self, from: data) {
                            observer.onNext(successResult.articles)
                        } else {
                            do {
                                let serverError = try JSONDecoder().decode(ErrorResponse.self, from: data)
                                observer.onError(NSError(domain: serverError.code,
                                                         code: -1001,
                                                         userInfo: [NSLocalizedDescriptionKey: serverError.message]))
                            } catch { observer.onError(error) }
                        }
                    case .failure(let error):
                        observer.onError(error)
                    }
            }
            return Disposables.create { request.cancel() }
        }
    }
}

private struct Api {
    private static let key = "f2be998448234e9584d6e0ddb7b79164"
    static var headers = ["x-api-key": Api.key]
}

private enum Router: URLRequestConvertible {
    
    static let baseURLString = "https://newsapi.org"
    
    case readNews(fetchRequest: FetchRequest)
    
    var method: HTTPMethod {
        switch self {
        case .readNews:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .readNews:
            return "/v2/everything"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = Api.headers
        
        switch self {
        case .readNews(let fetchRequest):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: fetchRequest.parameters)
        }
        
        return urlRequest
    }
}
