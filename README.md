<p align="center">
   <img width="200" src="https://raw.githubusercontent.com/SvenTiigi/SwiftKit/gh-pages/readMeAssets/SwiftKitLogo.png" alt="TableCellConfigurator Logo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat" alt="Swift 5.2">
   </a>
    <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
</p>

# TableCellConfigurator

<p align="center">
ℹ️ Library for quick and easy creation of UITableViewCell's in a platform-standard style
</p>
<p float="center">
<img src="https://i.imgur.com/THabAUO.png" width="30%">

## Features

The library requires a dependency [AppViewUtilits](https://github.com/moslienko/AppViewUtilits/).
<br>
Supported cell types:
- [x] ℹ️ Default (link) cell
- [x] ℹ️ Button cell
- [x] ℹ️ Switch cell
- [x] ℹ️ Text content cell
- [x] ℹ️ Select values cell
- [x] ℹ️ Checkmark cell
- [x] ℹ️ Date picker cell
- [x] ℹ️ Input field cell

## Example

The example application is the best way to see `TableCellConfigurator` in action. Simply open the `TableCellConfigurator.xcodeproj` and run the `Example` scheme.

## Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/moslienko/TableCellConfigurator.git", from: "1.0.0")
]
```

Alternatively navigate to your Xcode project, select `Swift Packages` and click the `+` icon to search for `TableCellConfigurator`.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate TableCellConfigurator into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage
### Table setup

```swift
import AppViewUtilits
import TableCellConfigurator
```
Connect cells:

```swift
self.tableView.registerCellClass(RegularCell.self)
self.tableView.registerCellClass(InputCell.self)
```
Models:

```swift
private var models: [[AppViewCellIdentifiable]] = []
```

UITableViewDataSource:

```swift
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
```
Actions on tap:

```swift
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = models[safe: indexPath.section]?[safe: indexPath.row] as? RegularCellModel,
           cellModel.type.isAllowLink {
            cellModel.action?()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
```

### Link cell
```swift
static func createDefault(title: String, subtitle: String?, icon: UIImage?, style: UITableViewCell.CellStyle, accessoryType: UITableViewCell.AccessoryType, action: Callback?) -> RegularCellModel
```

Example:

```swift
 let model = RegularCellModel.createDefault(
    title: "Cellular",
    subtitle: "Operator",
    icon: UIImage(systemName: "phone"),
    style: .default,
    accessoryType: .disclosureIndicator) {

}
```

### Action button
```swift
static func createActionButton(title: String, style: CellActionButtonStyle, isInteractiveEnabled: Bool, action: Callback?) -> RegularCellModel
```

There are the following styles for the button - two with preset styles and one with customisation:

```swift
enum CellActionButtonStyle {
    case accent
    case danger
    case custom(color: UIColor, textAlignment: UIListContentConfiguration.TextProperties.TextAlignment, font: UIFont)
}
```

Example:

```swift
let model = RegularCellModel.createActionButton(
    title: "Create new",
    style: .accent,
    isInteractiveEnabled: true) {}
```

### Switch cell
```swift
static func createSwitch(title: String, icon: UIImage? = nil, isOn: Bool, onChange: DataCallback<Bool>?) -> RegularCellModel
```

Example:

```swift
var isActiveWifi = true
 ...
let model = RegularCellModel.createSwitch(
    title: "Wi-Fi",
    icon: UIImage(systemName: "wifi"),
    isOn: isActiveWifi) { val in
        self.isActiveWifi = val
}
```

### Text content cell

Cell with multi-line text.<br>
Example:

```swift
let model = RegularCellModel(
    title: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
    type: .textContent
)
```


### Select value cell
Clicking on a cell opens a menu with a list of values.

```swift
func createSelectValues(title: String, selectingValue: String?, icon: UIImage?, contextMenu: UIMenu) -> RegularCellModel
```

Example:

```swift
let values = ["iPhone", "iPad", "Apple Watch", "Apple Vision Pro", "Mac"]
var selectingValue: String?
 ...
let model = RegularCellModel.createSelectValues(
    title: "Select value",
    selectingValue: selectingValue,
    icon: nil,
    contextMenu: createMenuForSelectingValues()
)
...
func createMenuForSelectingValues() - > UIMenu {
    UIMenu(title: "", children: self.values.map({ item in
        UIAction(title: item, handler: { [weak self] _ in
            self?.selectingValue = item
            self?.reloadData()
        })
    }))
}
```


### Checkmark cell

Example:

```swift
var isActiveOption = true
...
let model = RegularCellModel(
    title: "Option",
    type: .checkmark,
    style: .default,
    isOn: isActiveOption) {
    self.isActiveOption.toggle()
}
```

### Date picker cell

```swift
static func createDatePicker(title: String, date: Date?, onChange: DataCallback<Date>?) -> RegularCellModel
```

Example:

```swift
var selectedDate: Date?
...
let model = RegularCellModel.createDatePicker(
    title: "Select date",
    date: selectedDate,
    onChange: { value in
        self.selectedDate = value
        self.reloadData()
    }
)
```

### RegularCellOptions
Some internal parameters can be changed by accessing <i>RegularCellOptions</i>

```swift
public struct RegularCellOptions {
    public var tintColor: UIColor
    public var layoutMargins: UIEdgeInsets
    public var iconSize: CGSize
    public var imageToTextPadding: CGFloat
}
```

Example:

```swift
model.options.tintColor = .red
```


### Input field cell

```swift
var nameValue: String?
...
let model = InputCellModel(
	text: nameValue,
	placeholder: "What's you name?",
	isInteractiveEnabled: true,
	maxLimit: 64,
	valueChanged: { value in
		self.nameValue = value
	}, valueFinishChanged: { value in
	    
	}
)
```

### InputCellOptions
Some internal parameters can be changed by accessing <i>InputCellOptions</i>

```swift
public struct InputCellOptions {
    public var tintColor: UIColor
    public var activeColor: UIColor
    public var disabledColor: UIColor
    public var layoutMargins: UIEdgeInsets
}
```

Example:

```swift
model.options.tintColor = .red
```

### Make cell untouchable
```swift
model.isInteractiveEnabled = false
```

## License

```
TableCellConfigurator
Copyright (c) 2023 Pavel Moslienko 8676976+moslienko@users.noreply.github.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
