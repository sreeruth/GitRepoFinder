//
//  ViewController.swift
//  GitRepoFinder
//
//  Created by EXI-Ruthala, Sreekanth on 11/18/18.
//  Copyright © 2018 SelfOrg. All rights reserved.
//

import UIKit
import Apollo

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchResults: [Edge]?
    var cursorToken: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    let operationQueue = OperationQueue.init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.tableView.allowsSelection = false
        self.tableView.separatorColor = UIColor.black
        self.tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib.init(nibName: "GRFResultCell", bundle: nil), forCellReuseIdentifier: "GRFResultCell")
        
        self.operationQueue.maxConcurrentOperationCount = 1
        
        searchResults = []
        performFirstQuery()
    }
    
    //** MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults?.count ?? 0
    }
    
    //** MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GRFResultCell", for: indexPath) as? GRFResultCell
        
        if (self.searchResults?.count ?? 0) > 0 &&
            (indexPath.row == (self.searchResults?.count ?? 0) - 1) &&
            self.operationQueue.operationCount == 0 {
            self.operationQueue.addOperation {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.performNextQuery()
            }
        }
        
        guard let edge: Edge = self.searchResults?[indexPath.row] else {
            return cell!
        }
        cell?.loadCell(with: edge)
        return cell!
    }
    
    //** MARK:- Query Functions
    internal func performFirstQuery() {
        let url = URL(string: "https://api.github.com/graphql")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("bearer \(kToken)", forHTTPHeaderField: "Authorization")
        
        let body = ["query": kSearchFirstQuery]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let strongSelf = self else { return }
            if let error = error { print(error); return }
            guard let data = data else { print("Data is missing."); return }
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let dataDict = (jsonDict?["data"] as? [String: Any]) else {
                    return
                }
                guard let searchDict = (dataDict["search"] as? [String: Any]) else {
                    return
                }
                
                let searchResult = Search.init(with: searchDict)
                strongSelf.searchResults = searchResult.edges
                if searchResult.pageInfo.hasNextPage {
                    strongSelf.cursorToken = searchResult.pageInfo.endCursor
                }
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.layoutSubviews()
                }
            } catch let e {
                print("Parse error: \(e)")
                return
            }
        })
        task.resume()
    }
    
    internal func performNextQuery() {
        let url = URL(string: "https://api.github.com/graphql")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("bearer \(kToken)", forHTTPHeaderField: "Authorization")
        
        guard let nextToken = self.cursorToken else {
            return
        }
        
        let query = String.init(format: kSearchNextQuery, nextToken)
        let body = ["query": query]
        request.httpBody = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {[weak self] data, _, error in
            guard let strongSelf = self else { return }
            if let error = error { print(error); return }
            guard let data = data else { print("Data is missing."); return }
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let dataDict = (jsonDict?["data"] as? [String: Any]) else {
                    return
                }
                guard let searchDict = (dataDict["search"] as? [String: Any]) else {
                    return
                }
                
                let searchResult = Search.init(with: searchDict)
                strongSelf.searchResults?.append(contentsOf: searchResult.edges)
                if searchResult.pageInfo.hasNextPage {
                    strongSelf.cursorToken = searchResult.pageInfo.endCursor
                }
                DispatchQueue.main.async {
                    strongSelf.tableView.reloadData()
                    strongSelf.tableView.layoutSubviews()
                }
            } catch let e {
                print("Parse error: \(e)")
                return
            }
        })
        task.resume()
    }

}

