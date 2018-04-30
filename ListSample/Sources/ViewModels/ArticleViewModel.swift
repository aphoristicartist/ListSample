//
//  ArticleViewModel.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/27/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import Foundation
import RxSwift

struct ArticleViewModel {
    
    let dateFormatter = DateFormatter()
    
    private func formatDateString(targetString: String?,
                                  fromFormat: String,
                                  toFormat: String) -> String {
        guard let target = targetString else { return "" }
        dateFormatter.dateFormat = fromFormat
        guard let fromDate = dateFormatter.date(from: target) else { return "" }
        dateFormatter.dateFormat = toFormat
        return dateFormatter.string(from: fromDate)
    }
    
    let sourceName: String?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    var publishedAt: String?
    
    init(article: Article) {
        author = article.author
        title = article.title
        description = article.description
        url = article.url
        urlToImage = article.urlToImage?.hasPrefix("//") ?? false ? "http:".appending(article.urlToImage ?? "") : article.urlToImage
        sourceName = article.source?.name
        publishedAt = formatDateString(targetString: article.publishedAt, fromFormat: "yyyy-MM-dd'T'HH:mm:ssZ", toFormat: "MMM dd, yyyy")
    }
    
}
