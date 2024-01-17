//
//  MovieDetailView.swift
//  iOS_OTT
//
//  Created by 최민준 on 12/11/23.
//

import UIKit
import SDWebImage


struct MovieDetailViewModel {
    var posterImageURL: String? //backdropPath
    var title: String?
    var tagLine: String? 
    var overview: String?
    var releaseDate: String?
    var runtTime: Int?
    var voteAverage: Double?
    var popularity: Double?
}

class MovieDetailView: UIView {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var tagLineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    static func create() -> MovieDetailView {
        let bundle = Bundle(for: MovieDetailView.self)
        let nib = bundle.loadNibNamed("MovieDetailView", owner: nil)
        let view = nib?.first
        return view as! MovieDetailView
    }
    
    
    // MARK: - Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        
    }
    
    func displayPageInfo(viewModel: MovieDetail.Something.ViewModel?) {
        guard let viewModel = viewModel?.viewModel else { return }
        
        self.posterImageView.sd_setImage(with: URL(string: viewModel.posterImageURL ?? ""))
        self.titleLabel.text = viewModel.title
        self.releaseDateLabel.text = viewModel.releaseDate
        self.tagLineLabel.text = "\"" + (viewModel.tagLine ?? "") + "\"" 
        self.overviewLabel.text = viewModel.overview
    }
}
