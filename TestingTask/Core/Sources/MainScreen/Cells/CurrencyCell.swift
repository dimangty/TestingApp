//
//  CurrencyCell.swift
//  TestingTask
//
//  Created by Dima Bykov on 19.07.2022.
//

import UIKit

class CurrencyCell: UITableViewCell {
    static var cellName = String(describing: CurrencyCell.self)
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(item: CurrencyItemModel) {
        titleLabel.text = item.title
        selectorImageView.image = item.checked ? UIImage(named: "CurrencyOnIcon") : UIImage(named: "CurrencyOffIcon")
    }
    
}
