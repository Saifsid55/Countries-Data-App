//
//  HomeTableViewHeader.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//

import Foundation
import UIKit

class HomeTableViewHeader: UIView {
    
    var locationLabel: UILabel!
    private var searchBar: UISearchBar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        setLocationLabel()
//        setSearchbar()
    }
    
    private func setLocationLabel() {
        locationLabel = UILabel()
        self.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            locationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        locationLabel.text = "Lucknow\nUttar Pradesh"
        locationLabel.numberOfLines = 0
    }
    
    private func setSearchbar() {
        searchBar = UISearchBar()
        self.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
    
    func calculatedHeight(for width: CGFloat) -> CGFloat {
         let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
         return systemLayoutSizeFitting(targetSize).height
     }
}
