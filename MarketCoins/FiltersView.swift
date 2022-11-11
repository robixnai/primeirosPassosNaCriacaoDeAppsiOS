//
//  FiltersView.swift
//  MarketCoins
//
//  Created by Robson Moreira on 07/11/22.
//

import UIKit

protocol ToolbarFiltersViewDelegate: AnyObject {
    func filtersView(_ filtersView: FiltersView, didSelect filter: Filter, forCellRow row: Int)
    func cancelFilter(for filtersView: FiltersView)
}

class FiltersView: UIView {
    
    private var selectedOption: Filter?

    public weak var delegate: ToolbarFiltersViewDelegate?
    
    public var cellRow: Int = -1
    public var filterOptions: [Filter] = [] {
        didSet {
            selectedOption = filterOptions.first
        }
    }
    
    lazy var filterTollbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "OK", style: .done, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancelar", style: .plain, target: self, action: #selector(self.cancelTapped))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }()
    
    lazy var filterPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .systemGray6
        pickerView.isUserInteractionEnabled = true
        return pickerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setupView()
    }
    
    @objc private func doneTapped() {
        if let selectedOption {
            delegate?.filtersView(self, didSelect: selectedOption, forCellRow: cellRow)
        } else {
            cancelTapped()
        }
    }
    
    @objc private func cancelTapped() {
        delegate?.cancelFilter(for: self)
    }
}

extension FiltersView {
    
    private func setupView() {
        addSubviews(filterTollbar, filterPickerView)
        
        filterTollbar.translatesAutoresizingMaskIntoConstraints = false
        filterPickerView.translatesAutoresizingMaskIntoConstraints = false
        
        filterTollbar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        filterTollbar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        filterTollbar.bottomAnchor.constraint(equalTo: filterPickerView.topAnchor).isActive = true
        
        filterPickerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
        filterPickerView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
        filterPickerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

extension FiltersView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedOption = filterOptions[row]
    }
}

extension FiltersView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filterOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let filter = filterOptions[row]
        
        switch filter.type {
        case .coins:
            if let coinsFilter = CoinsFilterEnum(rawValue: filter.key) {
                return "\(coinsFilter.symbol) - \(coinsFilter.name)"
            }
        case .top:
            if let key = Int(filter.key), let topFilter = TopFilterEnum(rawValue: key) {
                return topFilter.title
            }
        case .priceChangePercentage:
            if let priceChangePercentageFilter = PriceChangePercentageFilterEnum(rawValue: filter.key) {
                return priceChangePercentageFilter.title
            }
        case .orderBy:
            if let orderByFilter = OrderByFilterEnum(rawValue: filter.key) {
                return "\(orderByFilter.title) \(orderByFilter.order)"
            }
        }
        
        return ""
    }
    
}
