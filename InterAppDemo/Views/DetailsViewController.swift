//
//  DetailsViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 27/2/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailsTableView: UITableView!
    
    var parameters: [URLQueryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell", for: indexPath) as! ReceiptTableViewCell
        cell.configure(titleText: parameters[indexPath.row].name, valueText: parameters[indexPath.row].value?.removingPercentEncoding)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let blankView = UIView(frame: CGRect.zero)
        blankView.backgroundColor = .systemBackground
        return blankView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = parameters[indexPath.row].value?.removingPercentEncoding
    }
}
