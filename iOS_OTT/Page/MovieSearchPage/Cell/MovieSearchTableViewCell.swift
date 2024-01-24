//
//  MovieSearchTableViewCell.swift
//  iOS_OTT
//
//  Created by 최민준 on 1/21/24.
//

import UIKit
import SDWebImage
import SnapKit


struct MovieSearchTableViewCellModel {
    var imageURL: String
    var title: String
    var movieId: Int 
}

class MovieSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func layoutSubviews() {
        // 테이블 뷰 셀 사이의 간격
        super.layoutSubviews()
        
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        self.posterImageView.do {
            $0.layer.cornerRadius = 6
        }
    }
 
    func displayCell(cellModel: MovieSearchTableViewCellModel?) {
        guard let cellModel = cellModel else { return }
        self.posterImageView.sd_setImage(with: URL(string: cellModel.imageURL))
        self.titleLabel.text = cellModel.title
    }
}
