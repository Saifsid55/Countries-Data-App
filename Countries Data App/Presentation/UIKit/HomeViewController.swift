//
//  HomeViewController.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//

import UIKit

/// UIKit screen that shows the countries in a table view.
///
/// File responsibility:
/// - Build and layout UIKit views (header, search bar, table).
/// - Ask view model to load data.
/// - Refresh table view when view model sends updates.
/// - Handle scroll animation for header/search area.
///
/// File connections:
/// - Reads data from `HomeViewModel` in `Presentation/UIKit/HomeViewModel.swift`.
/// - Uses `CountriesTVC` from `CountriesTVC.swift` for table cells.
/// - Uses `HomeTableViewHeader` from `HomeTableViewHeader.swift`.




final class HomeViewController: UIViewController {
    private var tableView: UITableView!
    private var headerView: HomeTableViewHeader!
    private var searchBar: UISearchBar!
    
    private var searchBarTopConstraint: NSLayoutConstraint!
    private var headerTopConstraint: NSLayoutConstraint!
    private var viewModel: HomeViewModeling
    private var lastOffsetY: CGFloat = 0
    private var accumulatedScrollUp: CGFloat = 0
    
    init(viewModel: HomeViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLocationLabel()
        setupSearchBar()
        setupTableView()
        fetchData()
        setupBinding()
    }
    
    private func setupLocationLabel() {
        headerView = HomeTableViewHeader()
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerTopConstraint = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        headerTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupSearchBar() {
        searchBar = UISearchBar()
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        searchBarTopConstraint = searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8)
        searchBarTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupTableView() {
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(CountriesTVC.self, forCellReuseIdentifier: "CountriesTVC")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupBinding() {
        viewModel.didFetchData = { [weak self] in
            guard let self = self else { return }
            Task { @MainActor in
                self.tableView.reloadData()
            }
        }
    }
    
    private func fetchData() {
        Task {
            await viewModel.fetchCountries()
        }
        
    }
}

// MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCountries ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesTVC") as! CountriesTVC
        let country = viewModel.dataByIndex(index: indexPath.row)
        cell.config(countryData: country)
        return cell
    }
}

// MARK: Scroll fading effect
extension HomeViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let animationRange: CGFloat = 80
        let maxHeaderTranslation: CGFloat = 25
        let maxSearchShift: CGFloat = 100
        
        let scrollDelta = offsetY - lastOffsetY
        let isScrollingUp = scrollDelta < 0
        
        if isScrollingUp {
            accumulatedScrollUp += abs(scrollDelta)
        } else {
            accumulatedScrollUp = 0
        }
        
        var progress: CGFloat
        if offsetY <= animationRange {
            progress = offsetY / animationRange
        } else {
            progress = max(0, 1 - (accumulatedScrollUp / animationRange))
        }
        progress = max(0, min(1, progress))
        
        if isScrollingUp {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
                self.headerView.alpha = 1 - progress
                self.headerView.transform = CGAffineTransform(translationX: 0, y: -progress * maxHeaderTranslation)
                self.searchBarTopConstraint.constant = 8 - (progress * maxSearchShift)
            }
        } else {
            headerView.layer.removeAllAnimations()
            headerView.alpha = 1 - progress
            headerView.transform = CGAffineTransform(translationX: 0, y: -progress * maxHeaderTranslation)
            searchBarTopConstraint.constant = 8 - (progress * maxSearchShift)
        }
        view.layoutIfNeeded()
        view.setNeedsLayout()
        lastOffsetY = offsetY
    }
}
