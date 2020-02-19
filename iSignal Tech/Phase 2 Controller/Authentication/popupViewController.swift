//
//  popupViewController.swift
//  iSignal Tech
//
//  Created by Salman Maredia on 02/06/2017.
//  Copyright © 2017 Salman Maredia. All rights reserved.
//

import UIKit

class popupViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    var dataset:NSArray!
    var dataType:String!
    
    var delegate: writeValueBackDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = dataType
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension popupViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataset.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popupcell", for: indexPath)
        
        switch dataType {
        case "Countries":
            let country:Country = dataset.object(at: indexPath.row) as! Country
            cell.textLabel?.text = country.name
        case "States":
            let state:State = dataset.object(at: indexPath.row) as! State
            cell.textLabel?.text = state.name
        case "Subjects":
            cell.textLabel?.text = dataset.object(at: indexPath.row) as? String
        default:
            cell.textLabel?.text = "--"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        switch dataType {
        case "Countries":
            let country:Country = dataset.object(at: indexPath.row) as! Country
            delegate?.setCountry(value: country)
            self.dismiss(animated: true, completion: nil)
            break
        case "States":
            let state:State = dataset.object(at: indexPath.row) as! State
            delegate?.setState(value: state)
            self.dismiss(animated: true, completion: nil)
            break
        case "Subjects":
            break
        default:
            break
        }
        
    }
}
