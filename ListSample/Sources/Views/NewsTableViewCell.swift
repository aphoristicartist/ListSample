//
//  NewsTableViewCell.swift
//  ListSample
//
//  Created by Lisenko, Aleksandr on 4/27/18.
//  Copyright © 2018 Lisenko, Aleksandr. All rights reserved.
//

import UIKit
import TinyConstraints
import Kingfisher

class NewsTableViewCell: UITableViewCell {
    
    static var cellHeight: CGFloat {
        return 44
    }
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let dateLabel = UILabel()
    private let mainImageView = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        addConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(mainImageView)
    }
    
    private func addConstraints() {
        mainImageView.leftToSuperview(offset: 12)
        mainImageView.size(CGSize(width: 44, height: 44))
        mainImageView.topToSuperview(offset: 8)
        mainImageView.clipsToBounds = true
        mainImageView.contentMode = .scaleAspectFill
        
        titleLabel.leftToRight(of: mainImageView, offset: 12)
        titleLabel.rightToSuperview(offset: 12)
        titleLabel.topToSuperview(offset: 8)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
        subTitleLabel.leftToRight(of: mainImageView, offset: 12)
        subTitleLabel.rightToSuperview(offset: 12)
        subTitleLabel.topToBottom(of: titleLabel, offset: 5)
        subTitleLabel.numberOfLines = 0
        subTitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .thin)
        
        dateLabel.leftToRight(of: mainImageView, offset: 12)
        dateLabel.rightToSuperview(offset: 12)
        dateLabel.topToBottom(of: subTitleLabel, offset: 5)
        dateLabel.bottomToSuperview(offset: -8)
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
        }
    }
    
    override func prepareForReuse() {
        viewModel = nil
        mainImageView.image = placeholderImage
    }
    
}
