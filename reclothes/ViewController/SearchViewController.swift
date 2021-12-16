//
//  SearchViewController.swift
//  reclothes
//
//  Created by Seungoh Han on 2021/12/04.
//

import UIKit

class SearchViewController: UIViewController {
    var searchWord = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchController()
    }
 
    func setupSearchController() {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색해 줘"
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = false

        let search = UIBarButtonItem(systemItem: .search, primaryAction: UIAction(handler: { _ in
            // 검색 내용 저장
            guard let text = searchController.searchBar.text else {
                return
            }
            self.searchWord = text
            
            // To do: 검색 결과 페이지로 연결
            self.performSegue(withIdentifier: "presentResult", sender: nil)
        }))
        self.navigationItem.rightBarButtonItem = search
    }
 
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "presentResult"{
            if let vc = segue.destination as? SearchResultViewController {
                vc.receiveWord(self.searchWord)
            }
        }
    }
}
