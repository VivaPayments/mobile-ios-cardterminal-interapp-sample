//
//  InterAppCancelViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zat on 14/5/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import UIKit

class InterAppCancelViewController: UIViewController {
    
    class func instantiate() -> InterAppCancelViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InterAppCancelViewController") as! InterAppCancelViewController
        return vc
    }
    
    
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var cancelTransactionButton: UIButton!
        
    var urlStr: String! // base interApp url string
    let schemeURL = "vivapayclient://pay/v1" // The Viva's custom URL scheme, the host and the version.
    let callback = "?callback=interapp-callback" // The URI callback that will handle the result.
    let merchantKey = "&merchantKey=SG23323424EXS3" // The merchant's key.
    let clientAppID = "&appId=com.vivawallet.InterAppDemo" // The client app id.
    let cancelAction = "&action=cancel" // Cancel transaction

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Construct base interApp url string
        urlStr = schemeURL + callback + merchantKey + clientAppID
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(dismissGesture)
        
        let bar = UIToolbar()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let next = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        bar.items = [flexButton, next]
        bar.sizeToFit()
        
        referenceTextField.inputAccessoryView = bar
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        dismissKeyboard()
    }
    
    
    
//MARK: - ACTION METHODS
    /// Cancel Transaction Request Action
    /// 1. Client should present his card to the reader.
    /// 2. The card terminal app will get the 3 latest transcations perfomed by the specific card.
    /// 3. If a transaction reference number is provided as a parameter from this app (look within the method) and it matches one of those 3 transcations, then the card terminal app will proceed with canceling the specific transaction immediately.
    /// 4. Otherwise a transcations list with details will be presented for the merchant to choose.
    /// 5. If no transactions are found the appropriate message will be displayed.
    /// 6. Check AppDelegate for handling the transaction result
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissKeyboard()
        
        let canceRequestStringURL: String = createCancelRequest(reference: referenceTextField.text)
        performInterAppRequest(request: canceRequestStringURL)
    }
    
    
    
    
//MARK: - MAIN METHODS
 
    func createCancelRequest(reference: String?) -> String {
        
        // construct sale action url
        var cancelActionURL = schemeURL + callback + merchantKey + clientAppID + cancelAction
                
        if let unwrappedReference = reference, unwrappedReference != "" {
            cancelActionURL += "&referenceNumber=\(unwrappedReference)" // transaction reference number
        }
        
        return cancelActionURL
    }
    
        
    func performInterAppRequest(request: String){
        guard let url = URL(string: request) else { return } // url with constructed parameters
        UIApplication.shared.open(url) { (result) in
            if result {
                // The URL was delivered successfully!
            }
        }
    }
    
    

//MARK: - SECONDARY METHODS
    @objc func dismissKeyboard(){
        referenceTextField.resignFirstResponder()
    }
    
    
    func presentInvalidInputAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension InterAppCancelViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


