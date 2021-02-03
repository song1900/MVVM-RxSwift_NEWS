//
//  ArticleCell.swift
//  NEWS
//
//  Created by 송우진 on 2021/02/02.
//

import UIKit
import SnapKit
import RxSwift
import Then
import SDWebImage

class ArticleCell: UICollectionViewCell {
    // MARK: Properties
    let disposeBag = DisposeBag()
    var viewModel = PublishSubject<ArticleViewModel>()
    
    lazy var imageView = UIImageView().then {
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.backgroundColor = .secondarySystemBackground
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.numberOfLines = 3
    }
    
    // MARK: Lifecycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    func subscribe() {
        self.viewModel.subscribe(onNext: {articleViewModel in
            if let urlString = articleViewModel.imageUrl {
                self.imageView.sd_setImage(with: URL(string: urlString), completed: nil)
            }
            
            self.titleLabel.text = articleViewModel.title
            self.descriptionLabel.text = articleViewModel.description
            
        }).disposed(by: disposeBag)

    }
    
    // MARK: Configures
    func configureUI() {
        backgroundColor = .systemBackground
        
        layer.cornerRadius = 8
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.35).cgColor
        layer.shadowOpacity = 1
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-10)
            $0.left.equalToSuperview().offset(20)
            $0.size.equalTo(CGSize(width: 60, height: 60))
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.top)
            $0.left.equalTo(imageView.snp.right).offset(20)
            $0.right.equalToSuperview().inset(40)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview().inset(5)
            $0.left.right.equalTo(titleLabel)
        }
    }
}
