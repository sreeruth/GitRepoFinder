//
//  QueryModels.swift
//  GitRepoFinder
//
//  Created by EXI-Ruthala, Sreekanth on 11/18/18.
//  Copyright © 2018 SelfOrg. All rights reserved.
//

import Foundation

struct Search {
    let edges: [Edge]!
    let pageInfo: PageInfo!
    let repositoryCount: Int!
    
    init(with dict:[String: Any]) {
        var edges = [Edge]()
        let count = (dict["edges"] as? [Any])?.count ?? 0
        if count > 0 {
            (dict["edges"] as? [Any])?.forEach({ (edgeDict) in
                let edge = Edge.init(with: (edgeDict as! [String: Any]))
                edges.append(edge)
            })
        }
        self.edges = edges
        pageInfo = PageInfo.init(with: (dict["pageInfo"] as! [String: Any]))
        repositoryCount = (dict["repositoryCount"] as? Int) ?? 0
    }
}

struct Edge {
    let cursor: String!
    let node: Node!
    
    init(with dict:[String: Any]) {
        cursor = (dict["cursor"] as? String) ?? ""
        node = Node.init(with: (dict["node"] as! [String: Any]))
    }
}

struct Node {
    let descriptionHTML: String!
    let forks: Forks!
    let name: String!
    let stargazers: Stargazers!
    let updatedAt: String!
    let owner: Owner!
    
    init(with dict:[String: Any]) {
        descriptionHTML = (dict["descriptionHTML"] as? String) ?? ""
        forks = Forks.init(with: (dict["forks"] as! [String: Any]))
        name = (dict["name"] as? String) ?? ""
        stargazers = Stargazers.init(with: (dict["stargazers"] as! [String: Any]))
        updatedAt = (dict["updatedAt"] as? String) ?? ""
        owner = Owner.init(with: (dict["owner"] as! [String: Any]))
    }
}

struct Owner {
    let login: String!
    let avatarUrl: String!
    
    init(with dict:[String: Any]) {
        login = (dict["login"] as? String) ?? ""
        avatarUrl = (dict["avatarUrl"] as? String) ?? ""
    }
}

struct Forks {
    let totalCount: Int!
    
    init(with dict:[String: Any]) {
        totalCount = (dict["totalCount"] as? Int) ?? 0
    }
}

struct Stargazers {
    let totalCount: Int!
    init(with dict:[String: Any]) {
        totalCount = (dict["totalCount"] as? Int) ?? 0
    }
}

struct PageInfo {
    let endCursor: String!
    let hasNextPage: Bool!
    
    init(with dict:[String: Any]) {
        endCursor = (dict["endCursor"] as? String) ?? ""
        hasNextPage = (dict["hasNextPage"] as? Bool) ?? false
    }
}
