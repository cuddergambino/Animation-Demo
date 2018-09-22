//
//  NSManagedObject+Extensions.swift
//  AnimationStudio
//
//  Created by Akash Desai on 9/22/18.
//  Copyright © 2018 Boundless Mind. All rights reserved.
//

import Foundation

extension EmojisplosionParams {
    public override func awakeFromInsert() {
        super.awakeFromInsert()

        setPrimitiveValue([0, -150], forKey: #keyPath(acceleration))
        setPrimitiveValue([0.5, 0.5], forKey: #keyPath(viewMargin))
    }

    
}
