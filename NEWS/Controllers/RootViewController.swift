//
//  ViewController.swift
//  NEWS
//
//  Created by SungHo Han on 2021/01/15.
//

import UIKit
import RxSwift
import RxRelay

class RootViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: RootViewModel
    let disposeBag = DisposeBag()
    
    private let articles = BehaviorRelay<[Article]>(value: [])
    var articlesObserver: Observable<[Article]> {
        return articles.asObservable()
    }
    
    // MARK: - Lifecycles
    init(viewModel: RootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchArticles()
        subscribe()
    }
    
    // MARK: - Configures
    func configureUI() {
        view.backgroundColor = .red
    }
    
    // MARK: - Helpers
    func fetchArticles() {
        self.viewModel.fetchArticles()
            .subscribe { (articles) in
                self.articles.accept(articles)
                print(articles)
            } onError: { (error) in
                print("ERROR = \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
    }
    
    func subscribe() {
        self.articlesObserver
            .subscribe { (articles) in
            // collectionview reload
        }
        .disposed(by: disposeBag)

    }
    
}
