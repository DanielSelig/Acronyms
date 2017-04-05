//
//  ViewController.swift
//  Acronym_DanSelig
//
//  Created by Dan Selig on 4/5/17.
//  Copyright © 2017 Dan Selig. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
    
    var defs = [String]()

    let apiParams = ApiParams(scheme: "http", host: "www.nactem.ac.uk", path: "software/acromine/dictionary.py")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    fileprivate func getAcronymDefinitions(args: String, completion: @escaping ( [String]?, Error?) -> Void) {
        let apiInterface = ApiInterface(apiParams: apiParams, args: args)
        
        apiInterface.get(){ (data, error) -> Void in
    
            if let error = error
            {
                completion(nil, error)
            }
                
            else
            {
                if let data = data {
                    if data.isEmpty {
                        self.defs = ["None"]
                    }
                
                    if let dict = data.first, let lfs = dict["lfs"] as? [[String : AnyObject]] {
                        self.defs.removeAll()
                        _ = lfs.map { self.defs.append($0["lf"] as! String) }
                    }
                }
                completion(self.defs, nil)
            }
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else {
            return
        }
        
        if text.characters.count == 3 {
            getAcronymDefinitions(args: "sf=\(text)") {
                defs, error in
                
                if let error = error {
                    print(error)
                    return
                }
                
                self.myTableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return defs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! TableViewCell
        cell.label.text = defs[indexPath.row]
        
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }

}
