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
    
    var movieListCellModels: BehaviorRelay<[MovieSearchTableViewCellModel]?> = .init(value: nil)
    var filteredMovieListCellModels: BehaviorRelay<[MovieSearchTableViewCellModel]?> = .init(value: nil)
    
    var movieDetailButtonDidTap: PublishRelay<Int> = .init()
    
    var isFiltering: Bool = false
    
    private let disposeBag: DisposeBag = .init()
    
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
        self.eventBinds()
    }
    
    private func configure() {
        self.movieTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: "MovieSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieSearchTableViewCell")
        }
    }
    
    private func eventBinds() {
        self.movieListCellModels.subscribe(onNext: { cellModels in
            self.movieTableView.reloadData()
        }).disposed(by: self.disposeBag)
        
        self.filteredMovieListCellModels.bind(onNext: { cellModels in
            self.movieTableView.reloadData()
        }).disposed(by: self.disposeBag)
    }
    
    func displayPageInfo(viewModel: MovieSearch.PageInfo.ViewModel?) {
        self.movieListCellModels.accept(viewModel?.cellModel?.cellModels)
    }
}


extension MovieSearchView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ? self.filteredMovieListCellModels.value?.count ?? 0 : self.movieListCellModels.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieSearchTableViewCell", for: indexPath) as? MovieSearchTableViewCell else {
            return UITableViewCell()
        }
        
        if self.isFiltering {
            cell.displayCell(cellModel: self.filteredMovieListCellModels.value?[indexPath.row])
        } else {
            cell.displayCell(cellModel: self.movieListCellModels.value?[indexPath.row])
        }
        
        cell.selectionStyle = .none // didSelect는 동작하게끔 코드로 설정
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movieId = self.movieListCellModels.value?[indexPath.row].movieId else { return }
        
        self.movieDetailButtonDidTap.accept(movieId)
    }
}


extension MovieSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        
        self.filteredMovieListCellModels.accept(self.movieListCellModels.value?.filter({$0.title.localizedCaseInsensitiveContains(text)})) // 대소문자 구분 없이 필터
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        self.filteredMovieListCellModels.accept(self.movieListCellModels.value?.filter({$0.title.localizedCaseInsensitiveContains(text)})) // 대소문자 구분 없이 필터
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.isFiltering = false
        self.movieTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isFiltering = true
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isFiltering = false
        searchBar.showsCancelButton = false
    }
}
