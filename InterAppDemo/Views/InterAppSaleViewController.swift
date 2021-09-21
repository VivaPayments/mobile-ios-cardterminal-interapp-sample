//
//  InterAppSaleViewController.swift
//  InterAppDemo
//
//  Created by Evangelos Pittas on 23/12/19.
//  Copyright © 2019 Viva Wallet. All rights reserved.
//

import UIKit

typealias ISVDetails = (clientId: String?, amount: Decimal?, clientSecret: String?, sourceCode: String?)

class InterAppSaleViewController: UIViewController {
    
    class func instantiate() -> InterAppSaleViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InterAppSaleViewController") as! InterAppSaleViewController
        return vc
    }
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var tipAmountTextField: UITextField!
    @IBOutlet weak var isvAmountTextField: UITextField!
    @IBOutlet weak var installmentsTextField: UITextField!
    @IBOutlet weak var clientTransactionIdTextField: UITextField!
    @IBOutlet weak var isvClientIdTextField: UITextField!
    @IBOutlet weak var isvClientSecretTextField: UITextField!
    @IBOutlet weak var isvSourceCodeTextField: UITextField!
    private(set) var keyboardHeight: CGFloat = 315
    
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
        isvAmountTextField.inputAccessoryView = bar
        isvClientIdTextField.inputAccessoryView = bar
        isvClientSecretTextField.inputAccessoryView = bar
        isvSourceCodeTextField.inputAccessoryView = bar
        isvClientIdTextField.text = "auyf99x03sachvn3f5ogldykz8214c2o4vl8cvvs97p19.apps.vivapayments.com"
        isvClientSecretTextField.text = "43ddf004fdf740c0a5b13477dff50991"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dismissKeyboard()
    }
    
    //MARK: - ACTION METHODS
    @IBAction func saleButtonTapped(_ sender: UIButton) {
        dismissKeyboard()
        
        var tipAmount: Decimal?
        var isvDetails: ISVDetails = (clientId: nil, amount: nil, clientSecret: nil, sourceCode: nil)
        var preferredInstallments: String?
        
        // Check If Valid Sale Entry
        // sale amount check
        guard let amount = amountTextField.text, Int(amount) != 0, amount != "" else {
            presentInvalidInputAlert(message: "Please enter a valid sale amount")
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
        if let installmentsEntry = installmentsTextField.text {
            preferredInstallments = installmentsEntry
        }

        if let isvAmount = isvAmountTextField.text,
           let isvAmountDecimal = Decimal(string: isvAmount, locale: Locale.current) {
            isvDetails.amount = isvAmountDecimal
        }
        if let isvClientId = isvClientIdTextField.text, isvClientId != ""   {
            isvDetails.clientId = isvClientId
        }
        if let isvClientSecret = isvClientSecretTextField.text, isvClientSecret != ""   {
            isvDetails.clientSecret = isvClientSecret
        }
        if let sourceCode = isvSourceCodeTextField.text, sourceCode != ""   {
            isvDetails.sourceCode = sourceCode
        }

        if isvClientIdTextField.text?.isEmpty == false ||
            isvAmountTextField.text?.isEmpty == false ||
            isvClientSecretTextField.text?.isEmpty == false  {
        }

        let saleActionURL = createSaleRequest(amount: decimalAmount, tipAmount: tipAmount, isvDetails: isvDetails, numberOfInstallments: preferredInstallments, clientTransactionId: clientTransactionIdTextField.text)
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(request: saleActionURL)
    }
    
    
    // MARK: - MAIN METHODS
    func createSaleRequest(amount: Decimal, tipAmount: Decimal?, isvDetails: ISVDetails?, numberOfInstallments: String?, clientTransactionId: String?) -> String {
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
        if let preferredInstallments = numberOfInstallments, numberOfInstallments?.isEmpty == false {
            saleActionURL += "&withInstallments=true" // enable installments parameter
            saleActionURL += "&preferredInstallments=\(preferredInstallments)"
        } else if UserDefaults.standard.value(forKey:
                SettingsViewController.SettingsKeys.sendEmptyInstallments.rawValue)  as? Bool == true {
            saleActionURL += "&withInstallments=true"
        }
        else {
            saleActionURL += "&withInstallments=false" // no installments parameter (should be used)
        }
        
        if let clientId = isvDetails?.clientId {
            saleActionURL += "&ISV_clientId=\(clientId)"
        }
        if let clientSecret = isvDetails?.clientSecret {
            saleActionURL += "&ISV_clientSecret=\(clientSecret)"
        }
        if let amount = isvDetails?.amount {
            saleActionURL += "&ISV_amount=\(((amount * 100) as NSDecimalNumber).intValue)" // The ISV amount in cents without any decimal digits.
        }
        if let sourceCode = isvDetails?.sourceCode {
            saleActionURL += "&ISV_sourceCode=\(sourceCode)"
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
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
    }
}


extension InterAppSaleViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let diff = UIScreen.main.bounds.height - self.keyboardHeight
            let globalPoint = textField.superview?.convert(textField.frame.origin, to: nil)
            if diff < (globalPoint?.y  ?? 0) {
                UIView.animate(withDuration: 0.2) { [weak self] in
                    self?.view.transform = CGAffineTransform(translationX: 0, y: diff - (globalPoint?.y ?? 0) - textField.frame.height)
                }
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}


