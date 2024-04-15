//
//  ReceiptOptionsViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zat on 16/3/21.
//  Copyright © 2021 Viva Wallet. All rights reserved.
//

import UIKit

class ReceiptOptionsViewController: UIViewController {
    
    enum PrinterSettingsKeys: String, CaseIterable {
        case businessDescriptionEnabled
        case businessDescriptionType
        case printLogoOnMerchantReceipt
        case printVATOnMerchantReceipt
        case isBarcodeEnabled
        case printAddressOnReceipt
        case isMerchantReceiptEnabled
        case isCustomerReceiptEnabled
        case isPrintingReceiptEnabled
    }
    
    enum BusinessDescriptionType: String {
        case businessName
        case tradeName
        case storeName
    }
    
    class func instantiate() -> ReceiptOptionsViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReceiptOptionsViewController") as! ReceiptOptionsViewController
        return vc
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var printerSettingsDictionary: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PrinterSettingsKeys.allCases.forEach { (key) in
            printerSettingsDictionary[key.rawValue] = "false"
        }
        tableView.allowsMultipleSelection = true
    }
    
    @IBAction func applySettingsButtonTapped(_ sender: Any) {
        var printerSettingsURL = Constants.setPrintingSettingsUrlString
        printerSettingsDictionary.forEach { (setting) in
            printerSettingsURL += "&" + setting.key + "=" + setting.value
        }
        (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(request: printerSettingsURL)
    }
}


extension ReceiptOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.selectionStyle = .none
        cell.detailTextLabel?.textColor = .systemBlue
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = PrinterSettingsKeys.businessDescriptionType.rawValue
        case 1:
            cell.detailTextLabel?.text = BusinessDescriptionType.businessName.rawValue
        case 2:
            cell.detailTextLabel?.text = BusinessDescriptionType.storeName.rawValue
        case 3:
            cell.detailTextLabel?.text = BusinessDescriptionType.tradeName.rawValue
        case 4:
            cell.textLabel?.text = PrinterSettingsKeys.businessDescriptionEnabled.rawValue
        case 5:
            cell.textLabel?.text = PrinterSettingsKeys.printLogoOnMerchantReceipt.rawValue
        case 6:
            cell.textLabel?.text = PrinterSettingsKeys.printVATOnMerchantReceipt.rawValue
        case 7:
            cell.textLabel?.text = PrinterSettingsKeys.isBarcodeEnabled.rawValue
        case 8:
            cell.textLabel?.text = PrinterSettingsKeys.printAddressOnReceipt.rawValue
        case 9:
            cell.textLabel?.text = PrinterSettingsKeys.isMerchantReceiptEnabled.rawValue
        case 10:
            cell.textLabel?.text = PrinterSettingsKeys.isCustomerReceiptEnabled.rawValue
        case 11:
            cell.textLabel?.text = PrinterSettingsKeys.isPrintingReceiptEnabled.rawValue
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.isSelected == true ? .checkmark : .none
        if let rawValue = cell?.textLabel?.text ?? cell?.detailTextLabel?.text {
            if indexPath.row <= 3 {
                printerSettingsDictionary[PrinterSettingsKeys.businessDescriptionType.rawValue] = rawValue
            } else {
                printerSettingsDictionary[rawValue] = "true"
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.row != 0 else { return nil }
        guard indexPath.row <= 3 else { return indexPath }

        var reloadList = [1, 2, 3]
        
        reloadList.remove(at: indexPath.row - 1)
        
        for i in reloadList {
            tableView.deselectRow(at: IndexPath.init(item: i, section: 0), animated: false)
            tableView.reloadRows(at: [IndexPath.init(item: i, section: 0)], with: .none)
        }

        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = cell?.isSelected == true ? .checkmark : .none
        if let rawValue = cell?.textLabel?.text ?? cell?.detailTextLabel?.text{
            if indexPath.row <= 3 {
                printerSettingsDictionary[PrinterSettingsKeys.businessDescriptionType.rawValue] = ""
            } else {
                printerSettingsDictionary[rawValue] = "false"
            }
        }
    }
}
