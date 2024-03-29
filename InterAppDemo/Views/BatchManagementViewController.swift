//
//  BatchManagementViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zat on 1/3/21.
//  Copyright © 2021 Viva Wallet. All rights reserved.
//

import UIKit

class BatchManagementViewController: UIViewController {
    
    enum Command: String {
        case open, close
    }
    
    class func instantiate() -> BatchManagementViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BatchManagementViewController") as! BatchManagementViewController
        return vc
    }

    @IBOutlet weak var batchNameTextfield: UITextField!
    @IBOutlet weak var batchUUIDTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addDoneButtonOnKeyboard()

    }
    
    @IBAction func createBatchButtonTapped(_ sender: Any) {
        // construct new batch url
        var createBatchActionURL = Constants.batchUrlString
        if let batchName = batchNameTextfield.text,
           !batchName.isEmpty {
            createBatchActionURL += "&batchName=" + batchName// newly created batch name
        }
        createBatchActionURL += "&command=" + Command.open.rawValue
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(request: createBatchActionURL)

    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        batchNameTextfield.inputAccessoryView = doneToolbar
        batchUUIDTextfield.inputAccessoryView = doneToolbar
    }

        @objc func doneButtonAction(){
            batchNameTextfield.resignFirstResponder()
            batchUUIDTextfield.resignFirstResponder()
        }
    
    @IBAction func endbatchButtonTapped(_ sender: Any) {
        // construct batch url
        var endBatchActionURL = Constants.batchUrlString //vivapayclient://pay/v1?callback=interapp-callback&merchantKey=SG23323424EXS3&appId=com.vivawallet.InterAppDemo&action=set_printing_settings
        endBatchActionURL += "&command=" + Command.close.rawValue
        if let batchName = batchNameTextfield.text, batchName.isValidName {
            endBatchActionURL += "&batchName=" + batchName // name of batch to end
        }
        if let batchUUID = batchUUIDTextfield.text, batchUUID.isValidName  {
            endBatchActionURL += "&batchId=" + batchUUID // uuid of batch to end
        }
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(request: endBatchActionURL)
    }
}

fileprivate extension String {
    var isValidName: Bool {
        return isAlphaNumeric && trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != ""
    }
}
