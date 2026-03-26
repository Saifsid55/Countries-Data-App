//
//  Untitled.swift
//  Countries Data App
//
//  Created by Muhammad Saif on 27/03/26.
//
import UIKit

final class CountryDetailViewController: UIViewController {
    private let country: Country
    
    init(country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = country.name.common
        navigationItem.largeTitleDisplayMode = .never
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let officialNameLabel = UILabel()
        officialNameLabel.text = country.name.official
        officialNameLabel.font = .preferredFont(forTextStyle: .headline)
        officialNameLabel.numberOfLines = 0
        
        let flagLabel = UILabel()
        flagLabel.text = country.flag
        flagLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        let capitalLabel = UILabel()
        capitalLabel.text = "Capital: \(country.capital.first ?? "N/A")"
        capitalLabel.font = .preferredFont(forTextStyle: .subheadline)
        capitalLabel.numberOfLines = 0
        
        [officialNameLabel, flagLabel, capitalLabel].forEach(stackView.addArrangedSubview)
        
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
}
