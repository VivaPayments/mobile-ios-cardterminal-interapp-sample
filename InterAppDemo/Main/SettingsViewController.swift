//
//  SettingsViewController.swift
//  InterAppDemo
//
//  Created by Alexandros Zattas on 5/8/20.
//  Copyright © 2020 Viva Wallet. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    enum SettingsKeys: String, CaseIterable {
        case sendEmptyAppId = "Send Empty App id"
        case sendEmptyCallback = "Send Empty Callback"
        case sendEmptyAction = "Send Empty Action"
        case sendEmptyInstallments = "Send Empty Installments"
        case show_receipt
        case show_rating
        case show_transaction_result
        case batchManagement = "Batch Management"
        case receiptOptions = "Receipt Options"
        case getPrintingSettings = "Get Printing Settings"
        case sendLogs = "Send Logs"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsKeys.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: indexPath)
            as! SettingsTableViewCell
        cell.titleLabel.text = SettingsKeys.allCases[indexPath.row].rawValue
        if SettingsKeys.allCases[indexPath.row] == .show_receipt
            || SettingsKeys.allCases[indexPath.row] == .show_rating
            || SettingsKeys.allCases[indexPath.row] == .show_transaction_result
            || SettingsKeys.allCases[indexPath.row] == .sendEmptyAction
            || SettingsKeys.allCases[indexPath.row] == .sendEmptyCallback
            || SettingsKeys.allCases[indexPath.row] == .sendEmptyAppId
            || SettingsKeys.allCases[indexPath.row] == .sendEmptyInstallments
        {
            cell.settingsSwitch.isOn =
                UserDefaults.standard.value(forKey: SettingsKeys.allCases[indexPath.row].rawValue)
                as? Bool ?? (indexPath.row <= 3 ? false : true)
        } else {
            cell.settingsSwitch.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SettingsTableViewCell else {
            return
        }
        switch cell.titleLabel.text {
        case SettingsKeys.batchManagement.rawValue:
            let batchManagementVC = BatchManagementViewController.instantiate()
            navigationController?.pushViewController(batchManagementVC, animated: true)
        case SettingsKeys.getPrintingSettings.rawValue:
            (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
                request: Constants.getPrintingSettingsUrlString
            )
        case SettingsKeys.receiptOptions.rawValue:
            let receiptOptionsVC = ReceiptOptionsViewController.instantiate()
            navigationController?.pushViewController(receiptOptionsVC, animated: true)
        case SettingsKeys.sendLogs.rawValue:
            (UIApplication.shared.delegate as? AppDelegate)?.performInterAppRequest(
                request: Constants.sendLogsUrlString
            )

        default:
            break
        }
    }
}

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!

    @IBAction func switchTapped(_ sender: Any) {
        if let settingsKey = titleLabel.text {
            UserDefaults.standard.set(settingsSwitch.isOn, forKey: settingsKey)
            UserDefaults.standard.synchronize()
        }
    }
}
