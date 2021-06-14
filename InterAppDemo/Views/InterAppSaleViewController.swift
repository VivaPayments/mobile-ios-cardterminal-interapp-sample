//
//  InterAppSaleViewController.swift
//  InterAppDemo
//
//  Created by Evangelos Pittas on 23/12/19.
//  Copyright © 2019 Viva Wallet. All rights reserved.
//

import UIKit

class InterAppSaleViewController: UIViewController {
    
    class func instantiate() -> InterAppSaleViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InterAppSaleViewController") as! InterAppSaleViewController
        return vc
    }
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tipAmountTextField: UITextField!
    @IBOutlet weak var installmentsTextField: UITextField!
    @IBOutlet weak var clientTransactionIdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(dismissGesture)
        
        let bar = UIToolbar()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let next = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        bar.items = [flexButton, next]
        bar.sizeToFit()
        
        amountTextField.inputAccessoryView = bar
        tipAmountTextField.inputAccessoryView = bar
        installmentsTextField.inputAccessoryView = bar
        clientTransactionIdTextField.inputAccessoryView = bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dismissKeyboard()
    }
    
    //MARK: - ACTION METHODS
    /// Sale Transaction Request Action
    /// 1. In order to perform a sale transaction a valid amount must be entered (greater than 0).
    /// 2. Tip amount and Installments are optional.
    /// 3. Tip amount with installments is not a valid payment and merchant should only proceed with choosing one of two.
    /// 4. Installments entry will act as preferred number of installments (check steps 7 and 8 for detailed information).
    ///
    /// 5. Client should present his card to the reader.
    /// 6. After a succesful read, the client will be prompt to enter his PIN if he chooses to insert the card to the reader and/or if the transaction amount is above the floor limit defined by the economic space in which the card was issued.
    ///
    /// Depending if client has provided a number of installments or not step 7 or 8 will follow.
    /// 7. If installments are not provided as a parameter by this app, then step 12 takes place.
    /// 8. If a preferred number of installments is provided, the Card Terminal app will first check if the card presented by the client supports a purchase with installments or not (step 9 or 12)
    /// 9. If the client's card supports installments then the following will take place: Each card supports a maximum number of installments. If the preferred number of installments entered in this app is below this limit then step 12 takes place. Otherwise step 10 takes place.
    /// 10. The Card Terminal app will prompt the user with choosing a valid installments number within the range displayed in the screen. After entering a valid number step 12 takes place. Otherwise step 11 takes place.
    /// 11. The Card Terminal app will prompt the merchant to a screen where he and the client should choose if they should proceed this transaction without the use of installments or if they should abort this transaction.
    /// 12. Card Terminal app will proceed with performing the transaction and return the result back to this app (check AppDelegate for handling the transaction result).
    @IBAction func saleButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        
        var tipAmount: Decimal?
        var preferredInstallments: Int?
        
        // Check If Valid Sale Entry
        // sale amount check
        guard let amount = amountTextField.text, Int(amount) != 0, amount != "" else {
            presentInvalidInputAlert(message: "Please enter a valid amount")
            return
        }
        // tip Or installments check
        if tipAmountTextField.text != "", installmentsTextField.text != "" {
            presentInvalidInputAlert(message: "Can not apply installments with tip")
            return
        }
        
        // get decimal amount from string
        guard let decimalAmount = Decimal(string: amount, locale: Locale.current) else { return }
        // assign tip parameter (if any)
        if let tipEntry = tipAmountTextField.text, let decimalTip = Decimal(string: tipEntry, locale: Locale.current)   {
            tipAmount = decimalTip
        }
        // append number of installments parameter (if any)
        if let installmentsEntry = installmentsTextField.text, let installments: Int = Int(installmentsEntry), installments > 1 {
            preferredInstallments = installments
        }
        
        let saleActionURL = createSaleRequest(amount: decimalAmount, tipAmount: tipAmount, numberOfInstallments: preferredInstallments, clientTransactionId: clientTransactionIdTextField.text)
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(request: saleActionURL)
    }
    
    
    // MARK: - MAIN METHODS
    func createSaleRequest(amount: Decimal, tipAmount: Decimal?, numberOfInstallments: Int?, clientTransactionId: String?) -> String {
        // construct sale action url
        var saleActionURL = Constants.saleUrlString // vivapayclient://pay/v1?callback=interapp-callback&merchantKey=SG23323424EXS3&appId=com.vivawallet.InterAppDemo&action=sale
        
        saleActionURL += "&amount=\(((amount * 100) as NSDecimalNumber).intValue)" // The amount in cents without any decimal digits.
        
        if let tip = tipAmount {
            saleActionURL += "&tipAmount=\(((tip * 100) as NSDecimalNumber).intValue)" // The tip amount in cents without any decimal digits.
        }
        
        // append clientTransactionId parameter (if any)
        if let transactionId = clientTransactionId, transactionId != "" {
            saleActionURL += "&clientTransactionId=\(transactionId)"
        }
        
        // append number of installments parameter (if any)
        if let preferredInstallments = numberOfInstallments, preferredInstallments > 1 {
            saleActionURL += "&withInstallments=true" // enable installments parameter
            saleActionURL += "&preferredInstallments=\(preferredInstallments)"
        }
        else {
            saleActionURL += "&withInstallments=false" // no installments parameter (should be used)
        }
        
        let showReceipt = UserDefaults.standard.value(forKey: "show_receipt") as? Bool ?? true
        saleActionURL += "&show_receipt=\(showReceipt)"
        
        let showRating = UserDefaults.standard.value(forKey: "show_rating") as? Bool ?? true
        saleActionURL += "&show_rating=\(showRating)"
        
        let showResult = UserDefaults.standard.value(forKey: "show_transaction_result") as? Bool ?? true
        saleActionURL += "&show_transaction_result=\(showResult)"
        
        return saleActionURL
    }
    
    //MARK: - SECONDARY METHODS
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func presentInvalidInputAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


extension InterAppSaleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


