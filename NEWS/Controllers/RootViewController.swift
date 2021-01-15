//
//  ViewController.swift
//  NEWS
//
//  Created by SungHo Han on 2021/01/15.
//

import UIKit
import RxSwift


class RootViewController: UIViewController {
    // MARK: - Properties
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Configures
    func configureUI() {
        view.backgroundColor = .red
    }
    
    
    
}
