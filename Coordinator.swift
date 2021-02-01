//
//  Coordinator.swift
//  NEWS
//
//  Created by 송우진 on 2021/01/15.
//

import UIKit

class Coordinator {
    let window: UIWindow
    
    init(window:UIWindow) {
        self.window = window
    }
    
    func start() {
        let rootVC = RootViewController(viewModel: RootViewModel(articleService: ArticleService()))
        let navigationRootVC = UINavigationController(rootViewController: rootVC)
        window.rootViewController = navigationRootVC
        window.makeKeyAndVisible()
    }
}
