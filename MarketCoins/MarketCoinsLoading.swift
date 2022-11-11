//
//  MarketCoinsLoading.swift
//  MarketCoins
//
//  Created by Robson Moreira on 10/11/22.
//

import UIKit

class MarketCoinsLoading {
    
    public static let shared = MarketCoinsLoading()
    
    private init() {}
    
    func start(from view: UIView, isBackground: Bool = true, isLarge: Bool = true) {
        let loading = LoadingView(parrentView: view, isBackground: isBackground, isLarge: isLarge)
        loading.indicatorView.startAnimating()
        view.addSubview(loading)
        loading.commonInit()
    }
    
    func stop(from view: UIView) {
        for view in view.subviews {
            if let view = view as? LoadingView {
                view.indicatorView.stopAnimating()
                view.removeFromSuperview()
            }
        }
    }
    
}

class LoadingView: UIView {
    
    private var parrentView: UIView?
    private var isBackground = true
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.4)
        return view
    }()
    
    lazy var indicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.color = .systemGray6
        return activityIndicatorView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(parrentView: UIView, isBackground: Bool, isLarge: Bool) {
        self.init(frame: .zero)
        self.parrentView = parrentView
        self.isBackground = isBackground
        
        self.indicatorView.style = isLarge ? .large : .medium
    }
    
    func commonInit() {
        setupView()
    }
}

extension LoadingView {
    
    private func setupView() {
        if isBackground {
            addSubviews(backgroundView, indicatorView)
            
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            
            if let parrentView {
                backgroundView.topAnchor.constraint(equalTo: parrentView.topAnchor).isActive = true
                backgroundView.leadingAnchor.constraint(equalTo: parrentView.leadingAnchor).isActive = true
                backgroundView.trailingAnchor.constraint(equalTo: parrentView.trailingAnchor).isActive = true
                backgroundView.bottomAnchor.constraint(equalTo: parrentView.bottomAnchor).isActive = true
            } else {
                backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                backgroundView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
                backgroundView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
                backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
            
            indicatorView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            indicatorView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        } else {
            addSubviews(indicatorView)
            
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            
            if let parrentView {
                indicatorView.centerXAnchor.constraint(equalTo: parrentView.centerXAnchor).isActive = true
                indicatorView.centerYAnchor.constraint(equalTo: parrentView.centerYAnchor).isActive = true
            } else {
                indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
                indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        }
    }
    
}
