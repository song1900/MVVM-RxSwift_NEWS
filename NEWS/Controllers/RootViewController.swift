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
    
    private let articleViewModel = BehaviorRelay<[ArticleViewModel]>(value: [])
    var articleViewModelObserver: Observable<[ArticleViewModel]> {
        return articleViewModel.asObservable()
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
        viewModel.fetchArticles()
            .subscribe { (articleViewModels) in
                self.articleViewModel.accept(articleViewModels)
            } onError: { (error) in
                print("ERROR fetchArticles = \(error.localizedDescription)")
            }.disposed(by: disposeBag)

    }
    
    func subscribe() {
        self.articleViewModelObserver
            .subscribe { (articles) in
                print(articles)
            } onError: { (error) in
                print("ERROR articleViewModelObserver = \(error.localizedDescription)")
            }.disposed(by: disposeBag)

    }
    
    
    
}
