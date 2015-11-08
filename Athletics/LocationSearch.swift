//
//  LocationSearch.swift
//  Athletics
//
//  Created by grobinson on 11/2/15.
//  Copyright © 2015 Wambl. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

protocol LocationSearchPTC {
    
    func locationSelected(item: MKMapItem)
    
}

class LocationSearch: UIViewController {

    var results: [MKMapItem] = []
    
    var delegate: LocationSearchPTC?
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        search.delegate = self
        
        edgesForExtendedLayout = UIRectEdge()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
    }

}

extension LocationSearch: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        if searchBar.text != "" {
            
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchBar.text
            
            let search = MKLocalSearch(request: request)
            
            search.startWithCompletionHandler { (response, error) in
                
                if let r = response {
                    
                    self.results = r.mapItems
                    
                    self.table.reloadData()
                    
                }
                
            }
            
        }
        
        return true
        
    }
    
}

extension LocationSearch: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        let item = results[indexPath.row]
        
        if let placemark = item.placemark.addressDictionary {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
            
            cell.textLabel?.text = item.name
            cell.textLabel?.font = UIFont.systemFontOfSize(13)
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(10)
            cell.detailTextLabel?.alpha = 0.8
            var txt = ABCreateStringWithAddressDictionary(placemark, true)
            if let city = item.placemark.locality { txt += ", \(city)" }
            if let state = item.placemark.administrativeArea { txt += ", \(state)" }
            cell.detailTextLabel?.text = txt
            
        } else {
            
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            cell.textLabel?.text = item.name
            cell.textLabel?.font = UIFont.systemFontOfSize(13)
            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let item = results[indexPath.row]
        
        delegate?.locationSelected(item)
        
        if let n = navigationController {
            
            n.popViewControllerAnimated(true)
            
        } else {
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
}