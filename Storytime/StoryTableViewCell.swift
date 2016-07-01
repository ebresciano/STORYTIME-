//
//  StoryTableViewCell.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/29/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class StoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storyTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithStory(story: Story) {
        storyTextField.text = Story.kPost
    }
    
        
    

}
