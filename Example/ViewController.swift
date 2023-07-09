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
    private var nameValue: String?
    
    public class var fromXib: ViewController {
        ViewController(nibName: "ViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.title = "Table cells"
        
        self.tableView.registerCellClass(RegularCell.self)
        self.tableView.registerCellClass(InputCell.self)
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
                regularModel.options.tintColor = .systemGreen
                
                let rightSubtitleModel = RegularCellModel.createDefault(
                    title: "iOS Version",
                    subtitle: "14.0 +",
                    icon: UIImage(systemName: "apple.logo"),
                    style: .value1,
                    accessoryType: .none) {
                        
                    }
                basicSection += [regularModel, rightSubtitleModel]
            case .actionButton:
                let dangerModel = RegularCellModel.createActionButton(
                    title: "Logout",
                    style: .danger,
                    isInteractiveEnabled: true) {
                        
                    }
                
                let accentModel = RegularCellModel.createActionButton(
                    title: "Create new",
                    style: .accent,
                    isInteractiveEnabled: true) {
                        print("f")
                    }
                
                let customModel = RegularCellModel.createActionButton(
                    title: "My custom button",
                    style: .custom(
                        color: .purple,
                        textAlignment: .center,
                        font: .systemFont(ofSize: 21, weight: .bold)
                    ),
                    isInteractiveEnabled: true) {
                        
                    }
                buttonsSection += [dangerModel, accentModel, customModel]
            case .withSwitch:
                let model = RegularCellModel.createSwitch(
                    title: "Wi-Fi",
                    icon: UIImage(systemName: "wifi"),
                    isOn: isActiveWifi) { val in
                        self.isActiveWifi = val
                        self.reloadData()
                    }
                basicSection += [model]
            case .textContent:
                let model = RegularCellModel(
                    title: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
                    type: .textContent
                )
                basicSection += [model]
            case .selectValue:
                let model = RegularCellModel.createSelectValues(
                    title: "Select value",
                    selectingValue: selectingValue,
                    icon: nil,
                    contextMenu: createMenuForSelectingValues()
                )
                basicSection += [model]
            case .checkmark:
                let model = RegularCellModel(
                    title: "Option",
                    type: .checkmark,
                    style: .default,
                    isOn: isActiveOption) {
                        self.isActiveOption.toggle()
                        self.reloadData()
                    }
                basicSection += [model]
            case .datePicker:
                let model = RegularCellModel.createDatePicker(
                    title: "Select date",
                    date: selectedDate,
                    onChange: { value in
                        self.selectedDate = value
                        self.reloadData()
                    }
                )
                basicSection += [model]
            }
        })
        
        let inputModel = InputCellModel(
            text: nameValue,
            placeholder: "What's you name?",
            isInteractiveEnabled: true,
            maxLimit: 64,
            valueChanged: { value in
                self.nameValue = value
            }, valueFinishChanged: { value in
                
            })
        basicSection += [inputModel]
        
        self.models = [basicSection, buttonsSection]
        self.tableView.reloadData()
        self.tableView.layoutSubviews()
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
        guard let model = models[safe: indexPath.section]?[safe: indexPath.row] else {
            return UITableViewCell()
        }
        if let model = model as? RegularCellModel {
            let cell = tableView.dequeueReusableCell(with: RegularCell.self, for: indexPath)
            cell.cellModel = model
            
            return cell
        } else if let model = model as? InputCellModel {
            let cell = tableView.dequeueReusableCell(with: InputCell.self, for: indexPath)
            cell.cellModel = model
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = models[safe: indexPath.section]?[safe: indexPath.row] as? RegularCellModel,
           cellModel.type.isAllowLink {
            cellModel.action?()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Regular"
        case 1:
            return "Buttons"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }
}
