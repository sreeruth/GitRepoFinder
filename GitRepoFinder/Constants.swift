//
//  Constants.swift
//  GitRepoFinder
//
//  Created by EXI-Ruthala, Sreekanth on 11/18/18.
//  Copyright © 2018 SelfOrg. All rights reserved.
//

import Foundation

let kToken = "5e0de51a3e32df99ce90744753545495815f7366"
let kSearchString = "GraphQL"

//** Queries
let kSearchFirstQuery = "query { " +
    "search(query: \"GraphQL\", type: REPOSITORY, first: 10) { " +
    "repositoryCount " +
    "edges {" +
    "node {" +
    "... on Repository {" +
    "name " +
    "descriptionHTML " +
    "stargazers {" +
    "totalCount" +
    "}" +
    "forks {" +
    "totalCount" +
    "}" +
    "owner {" +
    "login " +
    "avatarUrl" +
    "}" +
    "updatedAt" +
    "}" +
    "}" +
    "cursor" +
    "}" +
    "pageInfo {" +
    "endCursor " +
    "hasNextPage" +
    "}" +
    "}" +
"}"

let kSearchNextQuery = "query { " +
    "search(query: \"GraphQL\", type: REPOSITORY, first: 10, after: %@) { " +
    "repositoryCount " +
    "edges {" +
    "node {" +
    "... on Repository {" +
    "name " +
    "descriptionHTML " +
    "stargazers {" +
    "totalCount" +
    "}" +
    "forks {" +
    "totalCount" +
    "}" +
    "owner {" +
    "login " +
    "avatarUrl" +
    "}" +
    "updatedAt" +
    "}" +
    "}" +
    "cursor" +
    "}" +
    "pageInfo {" +
    "endCursor " +
    "hasNextPage" +
    "}" +
    "}" +
"}"
