//
//  MovieCell.swift
//  iOS_OTT
//
//  Created by 최민준(Minjun Choi) on 2023/04/07.
//

import UIKit
import SnapKit
import SDWebImage
import RxSwift


struct MovieCellModel {
    var imageURL: String
}

class MovieCell: UICollectionViewCell {
    
    // MARK: - Properties
    private let imageView: UIImageView = .init()
    
    private let disposeBag: DisposeBag = .init()
    
    var selectClosure: (()->Void)?
    
    // MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Method
    private func setAppearance() {
        self.imageView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 5
            self.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.height.equalToSuperview()
                $0.width.equalTo(self.imageView.snp.height).multipliedBy(0.66)
                $0.center.equalToSuperview()
            }
        }
        
        UIButton().do {
            self.addSubview($0)
            
            $0.snp.makeConstraints {
                $0.width.height.equalToSuperview()
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
            
            $0.rx
                .tap
                .bind {
                    self.selectClosure?() 
                }.disposed(by: self.disposeBag)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.sd_cancelCurrentImageLoad()
    }
    
    //MARK: - displayCell in CollectionView
    func displayCellModel(_ model: MovieCellModel) {
        self.imageView.sd_setImage(with: URL(string: model.imageURL))
    }
}
