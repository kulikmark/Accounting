//
//  ExpendedFooterTableView.swift
//  Accounting
//
//  Created by Марк Кулик on 08.06.2024.
//

//import UIKit
//import SnapKit
//
//struct ExpandedModel {
//    var isExpanded: Bool
//    let title: String
//    let array: [String]
//}
//
//extension HomeWorkTableViewController: HeaderViewDelegate {
//    func expandedSection(button: UIButton) {
//        let section = button.tag
//
//        let isExpanded = arrayOfData[section].isExpanded
//        arrayOfData[section].isExpanded = !isExpanded
//
//        tableView.reloadSections(IndexSet(integer: section), with: .automatic)
//    }
//}
//
//class HomeWorkTableViewController: UITableViewController {
//
//    var arrayOfData = [ExpandedModel]()
//
//    private var expandedIndexSet: IndexSet = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        arrayOfData = [
//            ExpandedModel(isExpanded: true, title: "Words", array: ["One", "Two", "Three", "Four", "Five"]),
//            ExpandedModel(isExpanded: true, title: "Numbers", array: ["6", "7", "8", "9", "10"]),
//            ExpandedModel(isExpanded: true, title: "Сharacters", array: ["Q", "W", "E", "R", "T", "Y"]),
//            ExpandedModel(isExpanded: true, title: "Emojis", array: ["😀", "😡", "🥶", "😱", "😈"])
//        ]
//
//        tableView.delegate = self
//        tableView.dataSource = self
//
//        // Регистрируем кастомный заголовок
//        tableView.register(CustomHeaderView.self, forHeaderFooterViewReuseIdentifier: CustomHeaderView.reuseIdentifier)
//
//        // Дополнительные настройки, если нужно
//        tableView.tableFooterView = UIView() // Чтобы убрать лишние разделители
//    }
//
//    let headerID = String(describing: CustomHeaderView.self)
//
//    private func tableViewConfig() {
//        let nib = UINib(nibName: headerID, bundle: nil)
//        tableView.register(nib, forHeaderFooterViewReuseIdentifier: headerID)
//
//        tableView.tableFooterView = UIView()
//    }
//}
//
//extension HomeWorkTableViewController {
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return arrayOfData.count
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if !arrayOfData[section].isExpanded {
//            return 0
//        }
//
//        return arrayOfData[section].array.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        let data = arrayOfData[indexPath.section].array[indexPath.row]
//        cell.textLabel?.text = data
//        return cell
//    }
//
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! CustomHeaderView
//
//        header.configure(title: arrayOfData[section].title, section: section)
//        header.rotateImage(arrayOfData[section].isExpanded)
//        header.delegate = self
//
//        return header
//    }
//
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 44
//    }
//
//
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        if expandedIndexSet.contains(indexPath.row) {
//            expandedIndexSet.remove(indexPath.row)
//        } else {
//            expandedIndexSet.insert(indexPath.row)
//        }
//
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return expandedIndexSet.contains(indexPath.row) ? 308 : 44
//    }
//}
//
//protocol HeaderViewDelegate: AnyObject {
//    func expandedSection(button: UIButton)
//}
//
//class CustomHeaderView: UITableViewHeaderFooterView {
//
//    weak var delegate: HeaderViewDelegate?
//
//    static let reuseIdentifier = "CustomHeaderView"
//
//    let titleLabel: UILabel!
//    let headerButton: UIButton!
//
//    override init(reuseIdentifier: String?) {
//        self.titleLabel = UILabel()
//        self.headerButton = UIButton(type: .custom) // Создаем кнопку
//
//        super.init(reuseIdentifier: reuseIdentifier)
//
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        addSubview(titleLabel)
//        addSubview(headerButton) // Добавляем кнопку
//
//        titleLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(16)
//            make.centerY.equalToSuperview()
//        }
//
//        headerButton.snp.makeConstraints { make in
//            make.edges.equalToSuperview() // Занимает всю область заголовка
//        }
//
//        headerButton.addTarget(self, action: #selector(tapHeader), for: .touchUpInside) // Назначаем действие
//    }
//
//    func configure(title: String, section: Int) {
//        titleLabel.text = title
//        headerButton.tag = section
//    }
//
//    func rotateImage(_ expanded: Bool) {
//         let angle: CGFloat = expanded ? .pi : 0
//         headerButton.imageView?.transform = CGAffineTransform(rotationAngle: angle)
//     }
//
//     @objc func tapHeader(sender: UIButton) {
//         delegate?.expandedSection(button: sender)
//     }
//
//     // Добавляем метод для установки изображения кнопке
//     func setImage(_ image: UIImage?, for state: UIControl.State) {
//         headerButton.setImage(image, for: state)
//     }
//}

