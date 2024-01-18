//
//  MovieSearchView.swift
//  iOS_OTT
//
//  Created by 최민준 on 1/18/24.
//

import UIKit

struct MovieSearchViewModel {
    
}

class MovieSearchView: UIView {
    
    static func create() -> MovieSearchView {
        let bundle = Bundle(for: MovieSearchView.self)
        let nib = bundle.loadNibNamed("MovieSearchView", owner: nil)
        let view = nib?.first
        return view as! MovieSearchView
    }
    
    
    // MARK: - Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        
    }
}
