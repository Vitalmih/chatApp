//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Виталий on 16.12.2020.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var messageBubble: UIView!
  
    @IBOutlet weak var messageBubbleText: UILabel!
    
    @IBOutlet weak var messageBubbleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        messageBubble.layer.cornerRadius = messageBubble.frame.size.height / 8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
