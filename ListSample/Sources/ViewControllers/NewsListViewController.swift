//
//  NewsListViewController.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/26/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import UIKit
import TinyConstraints
import RxCocoa
import RxSwift

final class NewsListViewController: UIViewController {
    
    private var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    private let disposeBag = DisposeBag()
    private var viewModel: NewsListViewModel
    
    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        rx.sentMessage(#selector(UIViewController.viewDidLoad))
            .map { _ in () }
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAndConfigureTableView()
        addRefreshControl()
        bindViewModel()
        addSubscriberToItemSelected()
        addSubscriberForNextPageLoading()
        addSubscriberToError()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func addAndConfigureTableView() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = NewsTableViewCell.cellHeight
        tableView.register(NewsTableViewCell.self,
                           forCellReuseIdentifier: NewsTableViewCell.className)
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .map { _ in () }
            .bind(to: viewModel.refreshTrigger)
            .disposed(by: disposeBag)
        viewModel.articles.subscribe ({_ in
            refreshControl.endRefreshing()
        })
        .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel
            .articles
            .bind(to: tableView
                .rx.items(cellIdentifier: NewsTableViewCell.className,
                                         cellType: NewsTableViewCell.self)) { $2.viewModel = $1 }
            .disposed(by: disposeBag)
    }
    
    private func addSubscriberToItemSelected() {
        tableView.rx
            .modelSelected(ArticleViewModel.self)
            .subscribe { [weak self] event in
            if case .next(let viewModel) = event {
                self?.navigationController?.pushViewController(NewsDetailViewController(viewModel: viewModel), animated: true)
            }
        }.disposed(by: disposeBag)
    }
    
    private func addSubscriberForNextPageLoading() {
        tableView.rx.reachedBottom
            .map { _ in () }
            .bind(to: viewModel.loadNextPageTrigger)
            .disposed(by: disposeBag)
    }
    
    private func addSubscriberToError() {
        viewModel.error.subscribe {  [weak self] event in
            switch event {
            case .next(let error),
                 .error(let error):
                self?.showAlertController(message: error.localizedDescription)
            case .completed:
                break
            }
        }.disposed(by: disposeBag)
    }
    
    private func showAlertController(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
