//
//  NewsDetailViewController.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/30/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    private var viewModel: ArticleViewModel
    
    init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        let mainView = NewsDetailView()
        mainView.viewModel = viewModel
        view = mainView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
    }
    
}
