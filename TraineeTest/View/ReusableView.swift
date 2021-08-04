//
//  ReusableView.swift
//  TraineeTest
//
//  Created by Nikita Chekmarev on 29.07.2021.
//

import UIKit

class ReusableView: UICollectionReusableView{
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
