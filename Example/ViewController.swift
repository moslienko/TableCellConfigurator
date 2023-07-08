//
//  ViewController.swift
//  Example
//
//  Created by moslienko on 3 июня 2023 г..
//  Copyright © 2023 Pavel Moslienko. All rights reserved.
//

import UIKit
import TableCellConfigurator
import AppViewUtilits

// MARK: - ViewController

/// The ViewController
class ViewController: AppViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var models: [[AppViewCellIdentifiable]] = []
    private var selectedDate: Date?
    private let values = ["iPhone", "iPad", "Apple Watch", "Apple Vision Pro", "Mac"]
    private var selectingValue: String?
    private var isActiveWifi = true
    private var isActiveOption = true

    public class var fromXib: ViewController {
        ViewController(nibName: "ViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Table"
        
        self.tableView.registerCellClass(RegularCell.self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.backgroundColor = .systemGroupedBackground
                
        selectingValue = values.first
        reloadData()
    }
    
    override func reloadData() {
       
        var basicSection: [AppViewCellIdentifiable] = []
        var buttonsSection: [AppViewCellIdentifiable] = []

        CellType.allCases.forEach({ type in
            switch type {
            case .default:
                let regularModel = RegularCellModel.createDefault(
                    title: "Cellular",
                    subtitle: "Operator",
                    icon: UIImage(systemName: "phone"),
                    style: .default,
                    accessoryType: .disclosureIndicator) {
                        
                    }
                basicSection += [regularModel]
                
                let rightSubtitleModel = RegularCellModel.createDefault(
                    title: "iOS Version",
                    subtitle: "14.0 +",
                    icon: UIImage(systemName: "apple.logo"),
                    style: .value1,
                    accessoryType: .none) {
                        
                    }
                basicSection += [rightSubtitleModel]
            case .dangerTiny:
                let model = RegularCellModel(title: "Logout", subtitle: "", icon: nil, type: .dangerTiny, style: .default, action: { [weak self] in
                })
                buttonsSection += [model]
            case .dangerBold:
                break //section += [model]
            case .withSwitch:
                let model = RegularCellModel.createSwitch(
                    title: "Wi-Fi",
                    icon: UIImage(systemName: "wifi"),
                    isEnabled: isActiveWifi) { val in
                        self.isActiveWifi = val
                        self.reloadData()
                    }
                basicSection += [model]
            case .textContent:
                let model = RegularCellModel(title: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.", subtitle: nil, icon: nil, type: .textContent, style: .default, isEnabled: true, action: nil)
                basicSection += [model]
            case .selectValue:
                let model = RegularCellModel(
                    title: "Select value",
                    subtitle: selectingValue,
                    icon: nil,
                    type: .selectValue,
                    style: .default
                )
                model.contextMenu = createMenuForSelectingValues()
                basicSection += [model]
            case .checkmark:
                let model = RegularCellModel(
                    title: "Option",
                    subtitle: nil,
                    icon: nil,
                    type: .checkmark,
                    style: .default,
                    isEnabled: isActiveOption) {
                        self.isActiveOption.toggle()
                        self.reloadData()
                    }
                basicSection += [model]
            case .datePicker:
                let model = RegularCellModel.createDatePicker(
                    title: "Select date",
                    date: Date(),
                    onChange: { value in
                        self.selectedDate = value
                        self.reloadData()
                    }
                )
                basicSection += [model]
            }
        })
        
        self.models = [basicSection, buttonsSection]
        self.tableView.reloadData()
    }
    
    override func setupView(with state: ViewState) {}
    
    private func createMenuForSelectingValues() -> UIMenu {
        UIMenu(title: "", children: self.values.map({ item in
            UIAction(title: item, handler: { [weak self] _ in
                self?.selectingValue = item
                self?.reloadData()
            })
        }))
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models[safe: section]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = models[safe: indexPath.section]?[safe: indexPath.row]else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(with: RegularCell.self, for: indexPath)
        cell.cellModel = model as? RegularCellModel
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = models[safe: indexPath.section]?[safe: indexPath.row] as? RegularCellModel,
           cellModel.type.isAllowLink {
            cellModel.action?()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension //44.0
    }
}
