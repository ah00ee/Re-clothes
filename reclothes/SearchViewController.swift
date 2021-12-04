//
//  SearchViewController.swift
//  reclothes
//
//  Created by Seungoh Han on 2021/12/04.
//

import UIKit

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
    }
    
    func setupSearchController() {
        // style 1
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색해 줘"
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        // style 2
        //        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.frame.width - 80, height: 0))
        //        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: searchBar)
        //
        //        self.navigationItem.title = "Search"
        //        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        let search = UIBarButtonItem(systemItem: .search, primaryAction: UIAction(handler: { _ in
            // 검색 내용 저장
            guard let text = searchController.searchBar.text else {
                return
            }
            print(text)
            
            // To do: 검색 결과 페이지로 연결
            
        }))
        self.navigationItem.rightBarButtonItem = search
    }
}
