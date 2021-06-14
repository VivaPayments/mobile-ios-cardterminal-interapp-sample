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
    
    @IBOutlet weak var refundAmountTextfield: UITextField!
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var orderCodeTextField: UITextField!
    @IBOutlet weak var shortOrderCodeTextField: UITextField!
    @IBOutlet weak var cancelTransactionButton: UIButton!
    @IBOutlet weak var dateFromPicker: UIDatePicker!
    @IBOutlet weak var dateToPicker: UIDatePicker!
    private var dateFromString: String?
    private var dateToString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(dismissGesture)
        
        let bar = UIToolbar()
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let next = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        bar.items = [flexButton, next]
        bar.sizeToFit()
        dateFromPicker.alpha = 0.5
        dateToPicker.alpha = 0.5
        refundAmountTextfield.inputAccessoryView = bar
        referenceTextField.inputAccessoryView = bar
        orderCodeTextField.inputAccessoryView = bar
        shortOrderCodeTextField.inputAccessoryView = bar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dismissKeyboard()
    }
    
    @IBAction func dateFromChanged(_ sender: Any) {
        dateFromPicker.alpha = 1
        let calendar = Calendar.current
        let startOfDayDate = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: dateFromPicker.date, matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .forward)
        dateFromString = startOfDayDate?.toString()
    }
    
    @IBAction func dateToChanged(_ sender: Any) {
        guard let dateTo = (sender as? UIDatePicker)?.date else { return }
        dateToPicker.alpha = 1
        let calendar = Calendar.current
        let endOfDayOfDateTo = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: dateTo, matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .forward)
        dateToString = endOfDayOfDateTo?.toString()
    }
    
    @IBAction func clearDateFrom(_ sender: Any) {
        dateFromPicker.alpha = 0.5
        dateFromString = nil
        dateFromPicker.date = Date()
    }
    
    @IBAction func clearDateTo(_ sender: Any) {
        dateToPicker.alpha = 0.5
        dateToString = nil
        dateToPicker.date = Date()
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
        
        // get decimal amount from string
        var refundAmount: Decimal?
        if let decimalString = refundAmountTextfield.text, let decimalAmount = Decimal(string: decimalString, locale: Locale.current) {
            refundAmount = decimalAmount
        }
        let canceRequestStringURL: String = createCancelRequest(refundAmount: refundAmount, reference: referenceTextField.text, orderCode: orderCodeTextField.text, shortOrderCode: shortOrderCodeTextField.text, dateFrom: dateFromString, dateTo: dateToString)
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(request: canceRequestStringURL)
    }
    
    
    //MARK: - MAIN METHODS
    func createCancelRequest(refundAmount: Decimal?, reference: String?, orderCode: String?, shortOrderCode: String?, dateFrom: String?, dateTo: String?) -> String {
        // construct cancel action url
        var cancelActionURL = Constants.cancelUrlString // vivapayclient://pay/v1?callback=interapp-callback&merchantKey=SG23323424EXS3&appId=com.vivawallet.InterAppDemo&action=cancel
                
        if let amount = refundAmount {
            cancelActionURL += "&amount=\(((amount * 100) as NSDecimalNumber).intValue)" // The amount in cents without any decimal digits.
        }
        
        if let unwrappedReference = reference, unwrappedReference != "" {
            cancelActionURL += "&referenceNumber=\(unwrappedReference)" // transaction reference number
        }
        
        if let unwrappedOrderCode = orderCode, unwrappedOrderCode != ""  {
            cancelActionURL += "&orderCode=\(unwrappedOrderCode)" // transaction order code
        }
        
        if let unwrappedShortOrderCode = shortOrderCode, unwrappedShortOrderCode != ""  {
            cancelActionURL += "&shortOrderCode=\(unwrappedShortOrderCode)" // transaction short Order Code
        }
        
        if let dateFrom = dateFrom {
            cancelActionURL += "&txnDateFrom=\(dateFrom)"
        }
        
        if let dateTo = dateTo {
            cancelActionURL += "&txnDateTo=\(dateTo)"
        }

        let showReceipt = UserDefaults.standard.value(forKey: "show_receipt") as? Bool ?? true
        cancelActionURL += "&show_receipt=\(showReceipt)"
        
        let showResult = UserDefaults.standard.value(forKey: "show_transaction_result") as? Bool ?? true
        cancelActionURL += "&show_transaction_result=\(showResult)"
        
        return cancelActionURL
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


extension InterAppCancelViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}


