//
//  ViewController.swift
//  NEWS
//
//  Created by 송우진 on 2021/01/15.
//

import UIKit
import RxSwift
import RxRelay

class RootViewController: UIViewController {
    
    // MARK: - Properties
    let viewModel: RootViewModel
    let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .systemBackground
        return cv
    }()
    
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
        configureCollectionView()
        fetchArticles()
        subscribe()
    }
    
    // MARK: - Configures
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        self.title = self.viewModel.title
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureCollectionView() {
        self.collectionView.register(ArticleCell.self, forCellWithReuseIdentifier: "cell")
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
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } onError: { (error) in
                print("ERROR articleViewModelObserver = \(error.localizedDescription)")
            }.disposed(by: disposeBag)

    }
    
    
    
}

extension RootViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return articleViewModel.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ArticleCell

        cell.imageView.image = nil

        let articleViewModel = self.articleViewModel.value[indexPath.row]
        cell.viewModel.onNext(articleViewModel)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    
}
