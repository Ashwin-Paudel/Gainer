//
//  SettingsTableViewController.swift
//  Gainer
//
//  Created by आश्विन पौडेल  on 2021-01-22.
//
import QuickTableViewController

class SettingsViewController: QuickTableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    tableContents = [
      Section(title: "Subscribers", rows: [
        SwitchRow(text: "Open url in Mini Browser", switchValue: true, action: { _ in
            if SettingsConfig.opensInMiniBrowser == false {
                SettingsConfig.opensInMiniBrowser = true
            } else if SettingsConfig.opensInMiniBrowser == true {
                SettingsConfig.opensInMiniBrowser = false
            }
        })
      ], footer: "The browser that is opened when you click the subscribe button"),
        
        Section(title: "Campains", rows: [
          SwitchRow(text: "Show progress in percentage", switchValue: false, action: { _ in
            if SettingsConfig.showsPercentage == false {
                SettingsConfig.showsPercentage = true
            } else if SettingsConfig.showsPercentage == true {
                SettingsConfig.showsPercentage = false
            }
          })
        ], footer: "Instead of showing a fraction, it will show a percentage")
    ]
  }

  // MARK: - Actions

  private func showAlert(_ sender: Row) {
    // ...
  }

  private func didToggleSelection() -> (Row) -> Void {
    return { [weak self] row in
      // ...
    }
  }

}
