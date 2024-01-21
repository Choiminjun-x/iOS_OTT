//
//  MovieSearchPresenter.swift
//  iOS_OTT
//
//  Created by 최민준 on 1/18/24.
//  Copyright (c) 2024 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol MovieSearchPresentationLogic {
    func presentPageInfo(response: MovieSearch.PageInfo.Response)
    func presentPageInfoError(response: MovieSearch.PageInfo.Response)
}

class MovieSearchPresenter: MovieSearchPresentationLogic {
    weak var viewController: MovieSearchDisplayLogic?
    
    private let imageBaseUrl: String = "https://image.tmdb.org/t/p/original"
    
    // MARK: Do something
    
    func presentPageInfo(response: MovieSearch.PageInfo.Response) {
        let cellModel: [MovieSearchTableViewCellModel] = response.movieListData?.results?.compactMap {
            guard let path = $0.backdropPath,
                  let title = $0.title else { return nil }
            return .init(imageURL: imageBaseUrl + path, title: title)
        } ?? []
        
        let isFirstPageYn: Bool = {
            let boolean = response.movieListData?.page == 1 //첫 페이지
            return boolean
        }()
        
        let isLastPageYn: Bool = {
            let boolean = response.movieListData?.page == response.movieListData?.totalPages //맨 끝
            return boolean
        }()
        
        self.viewController?.displayPageInfo(viewModel: .init(
            listType: .nowPlaying,
            cellModel: .init(cellModels: cellModel, isFirstPageYn: isFirstPageYn, isLastPageYn: isLastPageYn)))
    }
    
    func presentPageInfoError(response: MovieSearch.PageInfo.Response) {
        
    }
}
