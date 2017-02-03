//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mina Atef on 4/3/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: URL!
    var title: String!
    
    init(filePathUrl: URL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
