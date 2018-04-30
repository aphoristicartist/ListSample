//
//  NewsDetailView.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/30/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import UIKit

class NewsDetailView: UIView {
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let detailLabel = UILabel()
    private let dateLabel = UILabel()
    private let mainImageView = UIImageView()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .white
        addSubViews()
        addConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(detailLabel)
        self.addSubview(dateLabel)
        self.addSubview(mainImageView)
    }
    
    private func addConstraints() {
        mainImageView.leftToSuperview()
        mainImageView.rightToSuperview()
        mainImageView.height(300)
        mainImageView.topToSuperview()
        mainImageView.clipsToBounds = true
        mainImageView.contentMode = .scaleAspectFill
        
        titleLabel.leftToSuperview(offset: 12)
        titleLabel.rightToSuperview(offset: 12)
        titleLabel.topToBottom(of: mainImageView, offset: 12)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        subTitleLabel.leftToSuperview(offset: 12)
        subTitleLabel.rightToSuperview(offset: 12)
        subTitleLabel.topToBottom(of: titleLabel, offset: 12)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .light)
        
        detailLabel.leftToSuperview(offset: 12)
        detailLabel.rightToSuperview(offset: 12)
        detailLabel.topToBottom(of: subTitleLabel, offset: 12)
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        
        dateLabel.leftToSuperview(offset: 12)
        dateLabel.rightToSuperview(offset: 12)
        dateLabel.topToBottom(of: detailLabel, offset: 5)
        dateLabel.font = UIFont.systemFont(ofSize: 11, weight: .thin)
        dateLabel.textAlignment = .right
    }
    
    private let placeholderImage = UIImage(named: "Placeholder")
    var viewModel: ArticleViewModel? {
        didSet {
            mainImageView.image = UIImage(named: "Placeholder")
            titleLabel.text = viewModel?.sourceName
            if let urlString = viewModel?.urlToImage,
                let url = URL(string: urlString) {
                mainImageView.kf.setImage(with: url, placeholder: placeholderImage)
            }
            subTitleLabel.text = viewModel?.title
            dateLabel.text = viewModel?.publishedAt
            detailLabel.text = viewModel?.description
        }
    }
    
}
