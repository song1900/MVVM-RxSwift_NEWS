//
//  ArticleService.swift
//  NEWS
//
//  Created by 송우진 on 2021/01/18.
//

import Foundation
import Alamofire
import RxSwift

protocol ArticleServiceProtocol {
    func fetchNews() -> Observable<[Article]>
}

class ArticleService: ArticleServiceProtocol {
    
    func fetchNews() -> Observable<[Article]> {
        return Observable.create { (observer) -> Disposable in
            
            self.fetchNews { (error, articles) in
                if let error = error { observer.onError(error)}
                if let articles = articles { observer.onNext(articles) }
                
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    private func fetchNews(completion:@escaping((Error?, [Article]?) -> Void)) {
        // All articles about Bitcoin from the last month, sorted by recent first
        let urlString = "http://newsapi.org/v2/everything?q=bitcoin&from=2020-12-18&sortBy=publishedAt&apiKey="
        
        guard let url = URL(string: urlString + APIKey) else {
            return completion(NSError(domain: "woojin", code: 404, userInfo: nil), nil)
        }
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: ArticleResponse.self) { response in
            if let error = response.error {
                return completion(error, nil)
            }
            
            if let articles = response.value?.articles {
                return completion(nil, articles)
            }
        }
        
        
    }
}
