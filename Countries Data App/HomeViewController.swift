//
//  ViewController.swift
//  Countries Data App
//
//  Created by Mohd Saif on 13/10/25.
//
//https://restcountries.com/v3.1/independent?status=true&fields=languages,capital,flag,name
import UIKit

class HomeViewController: UIViewController {
    
    private var tableView: UITableView!
    private var headerView: HomeTableViewHeader!
    private var searchBar: UISearchBar!
    
    private var searchBarTopConstraint: NSLayoutConstraint!
    private var headerTopConstraint: NSLayoutConstraint!
    private var viewModel: HomeView
    private var lastOffsetY: CGFloat = 0
    private var isAnimatingBack = false
    var accumulatedScrollUp: CGFloat = 0

    
    init(viewModel: HomeView) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLocationLabel()
        setupSearchBar()
        setupTableView()
        
        viewModel.fetchCountries()
        setupBinding()
    }
    
    private func setupLocationLabel() {
        headerView = HomeTableViewHeader()
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerTopConstraint = headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        headerTopConstraint.isActive = true
        
        NSLayoutConstraint.activate([
//            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
    func setupBinding() {
        viewModel.didFetchData = { [weak self] in
            guard let self = self else { return }
            //            DispatchQueue.main.async {
            Task { @MainActor in
                self.tableView.reloadData()
            }
            
            //            }
        }
    }
}

// MARK: TableView DataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCountries
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
             // Accumulate upward scroll distance
             accumulatedScrollUp += abs(scrollDelta)
         } else {
             // Reset accumulation when scrolling down
             accumulatedScrollUp = 0
         }
         
         // Calculate progress: if we've scrolled up enough, start revealing
         var progress: CGFloat
         if offsetY <= animationRange {
             // Near top: use offset-based progress
             progress = offsetY / animationRange
         } else {
             // Middle/bottom: use accumulated scroll to reveal
             progress = max(0, 1 - (accumulatedScrollUp / animationRange))
         }
         progress = max(0, min(1, progress))
         
         if isScrollingUp {
             // Smoothly reveal header when scrolling up
             UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
                 self.headerView.alpha = 1 - progress
                 self.headerView.transform = CGAffineTransform(translationX: 0, y: -progress * maxHeaderTranslation)
                 self.searchBarTopConstraint.constant = 8 - (progress * maxSearchShift)
             }
         } else {
             // Instantly hide header when scrolling down
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
