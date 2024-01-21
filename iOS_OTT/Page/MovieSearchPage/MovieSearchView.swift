//
//  MovieSearchView.swift
//  iOS_OTT
//
//  Created by 최민준 on 1/18/24.
//

import UIKit
import RxSwift
import RxCocoa


struct MovieSearchViewModel {
    struct MovieListDataModel {
        var cellModels: [MovieSearchTableViewCellModel]
        var isFirstPageYn: Bool
        var isLastPageYn: Bool
    }
}

class MovieSearchView: UIView {
    
    @IBOutlet weak var movieTableView: UITableView!
    
//    var movieListCellModel: BehaviorRelay<MovieSearchTableViewCellModel?> = .init(value: nil)
    var movieListCellModel: [MovieSearchTableViewCellModel]?
    
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
        self.movieTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: "MovieSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieSearchTableViewCell")
        }
    }
    
    func displayPageInfo(viewModel: MovieSearch.PageInfo.ViewModel?) {
        self.movieListCellModel = viewModel?.cellModel?.cellModels
        self.movieTableView.reloadData()
    }
}

extension MovieSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movieListCellModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchTableViewCell", for: indexPath) as? MovieSearchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.displayCell(cellModel: self.movieListCellModel?[indexPath.row])
            
        return cell
    }
}
