//
//  RootViewModel.swift
//  NEWS
//
//  Created by 송우진 on 2021/01/18.
//

import Foundation
import RxSwift

final class RootViewModel {
    let title = "NEWS"
    
    private let articleService: ArticleServiceProtocol
    
    init(articleService: ArticleServiceProtocol) {
        self.articleService = articleService
    }
    
    func fetchArticles() -> Observable<[ArticleViewModel]> {
        articleService.fetchNews().map {
            $0.map {
                ArticleViewModel(article: $0)
            }
        }
    }
}
