//
//  ArticlesStore.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/27/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ArticlesStore {
    
    let refreshTrigger = PublishSubject<Void>()
    let loadNextPageTrigger = PublishSubject<Void>()
    let articles = BehaviorRelay<[Article]>(value: [])
    let error = PublishSubject<Error>()
    
    private var page: Int = 1
    private let loading = BehaviorRelay<Bool>(value: false)
    private let networkService: NetworkService
    private let disposeBag = DisposeBag()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
        
        let refreshRequest = loading
            .asObservable()
            .sample(refreshTrigger)
            .flatMap { $0 ? Observable.empty() :
                    Observable<Int>.create { observer in
                        observer.onNextAndCompleted(1)
                        return Disposables.create()
                }
        }
        
        let nextPageRequest = loading.asObservable()
            .sample(loadNextPageTrigger)
            .flatMap { [unowned self] in
                return $0 ? Observable.empty() :
                    Observable<Int>.create { [unowned self] observer in
                        self.page += 1
                        observer.onNextAndCompleted(self.page)
                        return Disposables.create()
                }
        }
        
        let request = Observable
            .of(refreshRequest, nextPageRequest)
            .merge()
            .share(replay: 1)
        
        let response = request.flatMap { [unowned self] in
            self.networkService.loadData(page: $0)
                .do(onError: { [weak self] in
                    self?.error.onNext($0)
                })
                .catchError { _ in Observable.empty() }
            }.share(replay: 1)
        
        Observable
            .combineLatest(response, articles.asObservable()) { [unowned self] response, elements in
                return self.page == 1 ? response : elements + response
            }
            .sample(response)
            .bind(to: articles)
            .disposed(by: disposeBag)
        
        Observable
            .of(request.map { _ in true },
                response.map { $0.count == 0 },
                error.map { _ in false })
            .merge()
            .bind(to: loading)
            .disposed(by: disposeBag)
    }
    
}
