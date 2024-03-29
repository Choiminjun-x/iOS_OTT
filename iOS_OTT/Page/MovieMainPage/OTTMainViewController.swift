//
//  OTTMainViewController.swift
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
import RxSwift
import RxCocoa


protocol OTTMainDisplayLogic: AnyObject {
    func displayPageInfo(viewModel: OTTMain.Something.ViewModel)
}

class OTTMainViewController: UIViewController, OTTMainDisplayLogic {
    var interactor: OTTMainBusinessLogic?
    var router: (NSObjectProtocol & OTTMainRoutingLogic & OTTMainDataPassing)?
    
    var pageView: OTTMainView { self.view as! OTTMainView }
    
    private let disposeBag: DisposeBag = .init()
    
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = OTTMainInteractor()
        let presenter = OTTMainPresenter()
        let router = OTTMainRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
    // MARK: - View lifecycle
    
    override func loadView() {
        self.view = OTTMainView.create()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.requestPageInfo()
        self.eventBinding()
    }
    
    private func eventBinding() {
        self.pageView.nowPlayingMovieListNextEvent.bind { [unowned self] in
            self.interactor?.requestPageInfo(request: .init(listType: .nowPlaying, pageType: .next))
        }.disposed(by: self.disposeBag)
        
        self.pageView.nowPlayingMovieDetailButtonDidTap.bind { [unowned self] (index) in
            self.router?.routeToMovieDetailPage(listType: .nowPlaying, index: index)
        }.disposed(by: self.disposeBag)
        
        self.pageView.popularMovieListNextEvent.bind { [unowned self] in
            self.interactor?.requestPageInfo(request: .init(listType: .popular, pageType: .next))
        }.disposed(by: self.disposeBag)
       
        self.pageView.topRatedMovieListNextEvent.bind { [unowned self] in
            self.interactor?.requestPageInfo(request: .init(listType: .topRated, pageType: .next))
        }.disposed(by: self.disposeBag)
        
        self.pageView.upComingMovieListNextEvent.bind { [unowned self] in
            self.interactor?.requestPageInfo(request: .init(listType: .upComing, pageType: .next))
        }.disposed(by: self.disposeBag)
        
        self.pageView.popularMovieDetailButtonDidTap.bind { [unowned self] (index) in
            self.router?.routeToMovieDetailPage(listType: .nowPlaying, index: index)
        }.disposed(by: self.disposeBag)
    }
    
    
    // MARK: Do something
    
    func requestPageInfo() {
        self.interactor?.requestPageInfo(request: .init(listType: .nowPlaying, pageType: .first))
        self.interactor?.requestPageInfo(request: .init(listType: .popular, pageType: .first))
        self.interactor?.requestPageInfo(request: .init(listType: .topRated, pageType: .first))
        self.interactor?.requestPageInfo(request: .init(listType: .upComing, pageType: .first))
    }
    
    func displayPageInfo(viewModel: OTTMain.Something.ViewModel) {
        guard let listType = viewModel.listType else { return }
        
        switch listType {
        case .nowPlaying:
            self.pageView.displayMovieList(viewModel: .init(listType: .nowPlaying, cellModel: viewModel.cellModel))
            break
        case .popular:
            self.pageView.displayMovieList(viewModel: .init(listType: .popular, cellModel: viewModel.cellModel))
            break
        case .topRated:
            self.pageView.displayMovieList(viewModel: .init(listType: .topRated, cellModel: viewModel.cellModel))
            break
        case .upComing:
            self.pageView.displayMovieList(viewModel: .init(listType: .upComing, cellModel: viewModel.cellModel))
            break
        }
    }
    
}
