//
//  ApiTableViewController.swift
//  Example
//
//  Created by Colby L Williams on 9/18/18.
//  Copyright © 2018 Colby L Williams. All rights reserved.
//

import UIKit

class ApiTableViewController: UITableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return Api.all.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "apiCell", for: indexPath)
        
        cell.textLabel?.text = Api.all[indexPath.row].title
        
        return cell
    }
    
    enum Api {
        case analyze
        case describe
        case thumbnail
        case ocr
        case domainSpecific
        case tag
        
        var title: String {
            switch self {
            case .analyze:          return "Analyze Image"
            case .describe:         return "Describe Image"
            case .thumbnail:        return "Get Thumbnail"
            case .ocr:              return "Analyze Image"
            case .domainSpecific:   return "Recognize Domain Specific Content"
            case .tag:              return "Tag Image"
            }
        }
        
        static let all: [Api] = [.analyze, .describe, .thumbnail, .ocr, .domainSpecific, .tag]
    }
}
