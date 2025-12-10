//
//  CountriesTVC.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//

import Foundation
import UIKit

class CountriesTVC: UITableViewCell {
    private var countryNameLbl: UILabel!
    private var countryFlag: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        setCountryNameLbl()
        setCountryFlag()
    }
    
    private func setCountryNameLbl() {
        countryNameLbl = UILabel()
        contentView.addSubview(countryNameLbl)
        countryNameLbl.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countryNameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            countryNameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4)
        ])
    }
    
    private func setCountryFlag() {
        countryFlag = UILabel()
        contentView.addSubview(countryFlag)
        countryFlag.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countryFlag.topAnchor.constraint(equalTo: countryNameLbl.bottomAnchor, constant: 4),
            countryFlag.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4)
        ])
    }
    
    func config(countryData: Countries?) {
        if let country = countryData {
            countryNameLbl.text = country.name.common
            countryFlag.text = country.flag
        }
    }
}
