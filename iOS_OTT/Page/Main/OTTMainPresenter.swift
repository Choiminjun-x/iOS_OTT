//
//  OTTMainPresenter.swift
//  iOS_OTT
//
//  Created by 최민준(Minjun Choi) on 2023/04/07.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol OTTMainPresentationLogic {
    func presentPageInfo(response: OTTMain.Something.Response)
    func presentPageInfoError(response: OTTMain.Something.Response)
}

class OTTMainPresenter: OTTMainPresentationLogic {
    weak var viewController: OTTMainDisplayLogic?
    
    // MARK: Do something
    
    func presentPageInfo(response: OTTMain.Something.Response) {
        guard let listType = response.listType else { return }
        
        let imageBaseUrl: String = "https://image.tmdb.org/t/p/original"
        
        switch listType {
        case .nowPlaying:
            let cellModel: [MovieCellModel] = response.nowPlayingMovieListData?.results?.compactMap {
                guard let path = $0.posterPath else { return nil }
                return .init(imageURL: imageBaseUrl + path)
            } ?? []
            
            let isFirstPageYn: Bool = {
                let boolean = response.nowPlayingMovieListData?.page == 1 //첫 페이지
                return boolean
            }()
            
            let isLastPageYn: Bool = {
                let boolean = response.nowPlayingMovieListData?.page == response.nowPlayingMovieListData?.totalPages //맨 끝
                return boolean
            }()
            
            self.viewController?.displayPageInfo(viewModel: .init(listType: .nowPlaying,
                                                                  cellModel: .init(
                                                                    cellModels: cellModel,
                                                                    isFirstPageYn: isFirstPageYn,
                                                                    isLastPageYn: isLastPageYn)))
            break
            
        case .popular:
            let cellModel: [MovieCellModel] = response.popularMovieListData?.results?.compactMap {
                guard let path = $0.posterPath else { return nil }
                return .init(imageURL: imageBaseUrl + path)
            } ?? []
            
            let isFirstPageYn: Bool = {
                let boolean = response.popularMovieListData?.page == 1 //첫 페이지
                return boolean
            }()
            
            let isLastPageYn: Bool = {
                let boolean = response.popularMovieListData?.page == response.popularMovieListData?.totalPages //맨 끝
                return boolean
            }()
            
            self.viewController?.displayPageInfo(viewModel: .init(listType: .popular,
                                                                  cellModel: .init(
                                                                    cellModels: cellModel,
                                                                    isFirstPageYn: isFirstPageYn,
                                                                    isLastPageYn: isLastPageYn)))
            break
            
        case .topRated:
            let cellModel: [MovieCellModel] = response.topRatedMovieListData?.results?.compactMap {
                guard let path = $0.posterPath else { return nil }
                return .init(imageURL: imageBaseUrl + path)
            } ?? []
            
            let isFirstPageYn: Bool = {
                let boolean = response.topRatedMovieListData?.page == 1 //첫 페이지
                return boolean
            }()
            
            let isLastPageYn: Bool = {
                let boolean = response.topRatedMovieListData?.page == response.topRatedMovieListData?.totalPages //맨 끝
                return boolean
            }()
            
            self.viewController?.displayPageInfo(viewModel: .init(listType: .topRated,
                                                                  cellModel: .init(
                                                                    cellModels: cellModel,
                                                                    isFirstPageYn: isFirstPageYn,
                                                                    isLastPageYn: isLastPageYn)))
            break
        case .upComing:
            let cellModel: [MovieCellModel] = response.upComingMovieListData?.results?.compactMap {
                guard let path = $0.posterPath else { return nil }
                return .init(imageURL: imageBaseUrl + path)
            } ?? []
            
            let isFirstPageYn: Bool = {
                let boolean = response.upComingMovieListData?.page == 1 //첫 페이지
                return boolean
            }()
            
            let isLastPageYn: Bool = {
                let boolean = response.upComingMovieListData?.page == response.upComingMovieListData?.totalPages //맨 끝
                return boolean
            }()
            
            self.viewController?.displayPageInfo(viewModel: .init(listType: .upComing,
                                                                  cellModel: .init(
                                                                    cellModels: cellModel,
                                                                    isFirstPageYn: isFirstPageYn,
                                                                    isLastPageYn: isLastPageYn)))
            break
        }
    }
    
    func presentPageInfoError(response: OTTMain.Something.Response) {
        
    }
}
