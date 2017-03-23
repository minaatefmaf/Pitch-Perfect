//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Mina Atef on 4/3/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    public private(set) var filePathUrl: URL!
    private var title: String!
    
    init(filePathUrl: URL!, title: String!) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}
