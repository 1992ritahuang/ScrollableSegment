//
//  PageSettingDelegate.swift
//  ScrollableSegment
//
//  Created by Rita Huang on 2025/1/11.
//

import UIKit

protocol PageSettingDelegate {
    func updateCurrentIndex(index:Int)
}

class PageContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var pageDelegate:PageSettingDelegate?
    var pageIndex: Int = 0
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init tableview
        tableView = UITableView(frame: CGRect(x: 0, y: 54.0, width: view.frame.width, height: view.frame.height-54.0), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "normalCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = self.pageDelegate {
            //update currentIndex of StockVC and update collection text color
            self.pageDelegate?.updateCurrentIndex(index: pageIndex)
        }
    }
    
    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
        cell.textLabel?.text = "Page \(pageIndex + 1) - Row \(indexPath.row)"
        return cell
    }
}

