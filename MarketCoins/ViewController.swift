//
//  ViewController.swift
//  MarketCoins
//
//  Created by Robson Moreira on 06/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGradient(colors: UIColor.black.cgColor, UIColor.darkGray.cgColor, UIColor.lightGray.cgColor)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        navigationItem.backButtonTitle = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.barStyle = .black
    }
    
    func setup() {
        preconditionFailure("This method must be overridden")
    }
    
    func showError(for messagem: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: "Erro", message: messagem, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { action in
            if self is CoinViewController {
                self.navigationController?.popViewController(animated: true)
            } else {
                exit(0)
            }
        }))
        alert.addAction(UIAlertAction(title: "Tentar novamente", style: .default, handler: handler))
        
        present(alert, animated: true)
    }
}
