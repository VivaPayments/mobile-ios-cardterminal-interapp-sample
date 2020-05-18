//
//  ReceiptViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 21/1/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    
    class func instantiate(response: InterAppResponse, parameters: [URLQueryItem]) -> ReceiptViewController {
        let rvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReceiptViewController") as! ReceiptViewController
        rvc.receiptViewModel = ReceiptViewModel(response: response)
        rvc.parameters = parameters
        return rvc
    }
    
    
    @IBOutlet weak var receiptTableView: UITableView!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultMessageLabel: UILabel!
    
    var receiptViewModel: ReceiptViewModel!
    var parameters: [URLQueryItem] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = receiptViewModel.transactionResult ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "xmark.circle")
        resultImageView.image = image
        resultImageView.tintColor = receiptViewModel.transactionResult ? .systemBlue : .systemRed
        resultMessageLabel.text = receiptViewModel.transactionResultMessage
        resultMessageLabel.textColor = resultImageView.tintColor
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? DetailsViewController {
            dvc.parameters = parameters
        }
    }
}


extension ReceiptViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows: Int = 4
        rows = (receiptViewModel.installments != nil) ? rows + 1 : rows
        rows = (receiptViewModel.clientReferenceCode != nil) ? rows + 1 : rows
        return rows
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell", for: indexPath) as! ReceiptTableViewCell
        switch indexPath.row {
        case 0:
            cell.configure(titleText: "Transaction type:", valueText: receiptViewModel?.transactionType ?? "")
        case 1:
            cell.configure(titleText: "Amount:", valueText: receiptViewModel.amount)
        case 2:
            cell.configure(titleText: "Card type:", valueText: receiptViewModel.cardType)
        case 3:
            cell.configure(titleText: "Transaction date:", valueText: receiptViewModel.transactionDate)
        case 4:
            cell.configure(titleText: "Client reference ID:", valueText: receiptViewModel.clientReferenceCode!)
        case 5:
            cell.configure(titleText: "Number of installments:", valueText: String(receiptViewModel.installments!))
        default:
            return cell
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let blankView = UIView(frame: CGRect.zero)
        blankView.backgroundColor = .systemBackground
        return blankView
    }
}


class ReceiptTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func configure(titleText: String?, valueText: String?) {
        titleLabel?.text = titleText
        valueLabel?.text = valueText
    }
}
