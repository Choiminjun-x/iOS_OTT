//
//  MovieDetailView.swift
//  iOS_OTT
//
//  Created by 최민준 on 12/11/23.
//

import UIKit


class MovieDetailView: UIView {

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
}
