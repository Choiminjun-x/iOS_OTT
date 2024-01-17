//
//  OTTMainView.swift
//  iOS_OTT
//
//  Created by 최민준(Minjun Choi) on 2023/04/07.
//

import UIKit
import SDWebImage
import RxCocoa


enum OTTMainViewModel {
    struct MovieListDataModel {
        var cellModels: [MovieCellModel]
        var isFirstPageYn: Bool
        var isLastPageYn: Bool
    }
}

class OTTMainView: UIView {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var seriesButton: UIButton!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var categorySelectButton: UIButton!
    @IBOutlet weak var mainPosterImageView: UIImageView!
    
    @IBOutlet weak var nowPlayingMovieListTitleLabel: UILabel!
    @IBOutlet weak var nowPlayingMovieListCollectionView: UICollectionView!
    
    @IBOutlet weak var popularMovieListTitleLabel: UILabel!
    @IBOutlet weak var popularMovieListCollectionView: UICollectionView!
    
    @IBOutlet weak var topRatedMovieListTitleLabel: UILabel!
    @IBOutlet weak var topRatedMovieListCollecionView: UICollectionView!
    
    @IBOutlet weak var upComingMovieListTitleLabel: UILabel!
    @IBOutlet weak var upComingMovieListCollecionView: UICollectionView!
    
    private let nowPlayingMovieListDelegate: nowPlayingMovieListDelegate = .init()
    internal var nowPlayingMovieListNextEvent: PublishRelay<Void> {
        get { return self.nowPlayingMovieListDelegate.nextEvent }
    }
    internal var nowPlayingMovieDetailButtonDidTap: PublishRelay<Int> {
        get { return self.nowPlayingMovieListDelegate.movieDetailButtonDidTap }
    }
    
    private let popularMovieListDelegate: popularMovieListDelegate = .init()
    internal var popularMovieListNextEvent: PublishRelay<Void> {
        get { return self.popularMovieListDelegate.nextEvent }
    }
    internal var popularMovieDetailButtonDidTap: PublishRelay<Int> {
        get { return self.popularMovieListDelegate.movieDetailButtonDidTap }
    }

    private let topRatedMovieListDelegate: topRatedMovieListDelegate = .init()
    internal var topRatedMovieListNextEvent: PublishRelay<Void> {
        get { return self.topRatedMovieListDelegate.nextEvent }
    }
    
    private let upComingMovieListDelegate: upComingMovieListDelegate = .init()
    internal var upComingMovieListNextEvent: PublishRelay<Void> {
        get { return self.upComingMovieListDelegate.nextEvent }
    }
    
    private var randomNumber: Int = 0
    
    var currentMovieType: OTTMain.ListType = .popular
    
    static func create() -> OTTMainView {
        let bundle = Bundle(for: OTTMainView.self)
        let nib = bundle.loadNibNamed("OTTMainView", owner: nil)
        let view = nib?.first
        return view as! OTTMainView
    }
    
    
    // MARK: - Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        self.seriesButton.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 0.5
        }
        
        self.categoryButton.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 0.5
        }
        
        self.categorySelectButton.do {
            $0.layer.cornerRadius = 12
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 0.5
        }
        
        self.mainPosterImageView.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 20
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowRadius = 10
            $0.layer.borderColor = UIColor.white.cgColor
            $0.layer.borderWidth = 0.3
        }
        
        self.nowPlayingMovieListTitleLabel.text = "현재 상영중인 콘텐츠"
        self.nowPlayingMovieListCollectionView.do {
            $0.delegate = self.nowPlayingMovieListDelegate
            $0.dataSource = self.nowPlayingMovieListDelegate
            $0.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                let itemHeight: Double = 290
                let itemWidth: Double = itemHeight * 0.65
                $0.itemSize = .init(width: itemWidth, height: itemHeight)
                $0.scrollDirection = .horizontal
            }
        }
        
        self.popularMovieListTitleLabel.text = "지금 뜨는 콘텐츠"
        self.popularMovieListCollectionView.do {
            $0.delegate = self.popularMovieListDelegate
            $0.dataSource = self.popularMovieListDelegate
            $0.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                let itemHeight: Double = 170
                let itemWidth: Double = itemHeight * 0.65
                $0.itemSize = .init(width: itemWidth, height: itemHeight)
                $0.scrollDirection = .horizontal
            }
        }
        
        self.topRatedMovieListTitleLabel.text = "인기 콘텐츠"
        self.topRatedMovieListCollecionView.do {
            $0.delegate = self.topRatedMovieListDelegate
            $0.dataSource = self.topRatedMovieListDelegate
            $0.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                let itemHeight: Double = 170
                let itemWidth: Double = itemHeight * 0.65
                $0.itemSize = .init(width: itemWidth, height: itemHeight)
                $0.scrollDirection = .horizontal
            }
        }
        
        self.upComingMovieListTitleLabel.text = "개봉 예정 콘텐츠"
        self.upComingMovieListCollecionView.do {
            $0.delegate = self.upComingMovieListDelegate
            $0.dataSource = self.upComingMovieListDelegate
            $0.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionViewCell")
            ($0.collectionViewLayout as? UICollectionViewFlowLayout)?.do {
                let itemHeight: Double = 170
                let itemWidth: Double = itemHeight * 0.65
                $0.itemSize = .init(width: itemWidth, height: itemHeight)
                $0.scrollDirection = .horizontal
            }
        }
        
    }
    
    public func displayMovieList(viewModel: OTTMain.Something.ViewModel) {
        guard let listType = viewModel.listType else { return }
        
        self.currentMovieType = listType
        
        switch listType {
        case .nowPlaying:
            guard let cellModels = viewModel.cellModel?.cellModels else { return }
            
            let randomNum = Int.random(in: 0 ..< 20)
            self.randomNumber = randomNum
            let mainImage = cellModels[randomNum]
            //스트레치 이미지 뷰에 랜덤으로 이미지 삽입
            self.mainPosterImageView.sd_setImage(with: URL(string: mainImage.imageURL), completed: nil)
            
            self.nowPlayingMovieListDelegate.cellModels = {
                if viewModel.cellModel?.isFirstPageYn == true {
                    return cellModels
                } else {
                    var arr = self.nowPlayingMovieListDelegate.cellModels
                    arr?.append(contentsOf: cellModels)
                    return arr
                }
            }()
            
            self.nowPlayingMovieListCollectionView.reloadData()
            break
            
        case .popular:
            guard let cellModels = viewModel.cellModel?.cellModels else { return }
            
            self.popularMovieListDelegate.cellModels = {
                if viewModel.cellModel?.isFirstPageYn == true {
                    return cellModels
                } else {
                    var arr = self.popularMovieListDelegate.cellModels
                    arr?.append(contentsOf: cellModels)
                    return arr
                }
            }()
            
            self.popularMovieListCollectionView.reloadData()
            break
            
        case .topRated:
            guard let cellModels = viewModel.cellModel?.cellModels else { return }
            
            self.topRatedMovieListDelegate.cellModels = {
                if viewModel.cellModel?.isFirstPageYn == true {
                    return cellModels
                } else {
                    var arr = self.topRatedMovieListDelegate.cellModels
                    arr?.append(contentsOf: cellModels)
                    return arr
                }
            }()
            
            self.topRatedMovieListCollecionView.reloadData()
            break
            
        case .upComing:
            guard let cellModels = viewModel.cellModel?.cellModels else { return }
            
            self.upComingMovieListDelegate.cellModels = {
                if viewModel.cellModel?.isFirstPageYn == true {
                    return cellModels
                } else {
                    var arr = self.upComingMovieListDelegate.cellModels
                    arr?.append(contentsOf: cellModels)
                    return arr
                }
            }()
            
            self.upComingMovieListCollecionView.reloadData()
            break
        }
    }
}


fileprivate class nowPlayingMovieListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var cellModels: [MovieCellModel]?
    var isLastPage: Bool = false
    internal let nextEvent: PublishRelay<Void> = .init()
    internal let movieDetailButtonDidTap: PublishRelay<Int> = .init()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MovieCollectionViewCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.movieDetailButtonDidTap.accept(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 5
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}

fileprivate class popularMovieListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var cellModels: [MovieCellModel]?
    var isLastPage: Bool = false
    internal let nextEvent: PublishRelay<Void> = .init()
    internal let movieDetailButtonDidTap: PublishRelay<Int> = .init()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MovieCollectionViewCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 5
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}

fileprivate class topRatedMovieListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var cellModels: [MovieCellModel]?
    var isLastPage: Bool = false
    internal let nextEvent: PublishRelay<Void> = .init()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MovieCollectionViewCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 5
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}

fileprivate class upComingMovieListDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var cellModels: [MovieCellModel]?
    var isLastPage: Bool = false
    internal let nextEvent: PublishRelay<Void> = .init()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cellModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath).do {
            guard let cellModel = self.cellModels?[indexPath.row] else { return }
            ($0 as? MovieCollectionViewCell)?.displayCellModel(cellModel)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.cellModels?.count else { return }
        let isLastCell = indexPath.row + 1 == count - 5
        if isLastCell, self.isLastPage == false {
            self.nextEvent.accept(())
        }
    }
}


