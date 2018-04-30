//
//  NewsListViewModel.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/27/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import Foundation
import RxSwift

struct NewsListViewModel {
    
    private var articleStore: ArticlesStore
    
    init(store: ArticlesStore) {
        articleStore = store
    }
    
    var articles: Observable<[ArticleViewModel]> {
        return self.articleStore.articles.map({ $0.map({ ArticleViewModel(article: $0)}) })
    }
    
    var loadNextPageTrigger: PublishSubject<Void> {
        return articleStore.loadNextPageTrigger
    }
    
    var refreshTrigger: PublishSubject<Void> {
        return articleStore.refreshTrigger
    }
    
    var error: PublishSubject<Error> {
        return articleStore.error
    }
    
}
