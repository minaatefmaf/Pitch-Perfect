//
//  AppPermissions.swift
//  Pitch Perfect
//
//  Created by Mina Atef on 4/4/17.
//  Copyright © 2017 minaatefmaf. All rights reserved.
//

import AVFoundation

class AppPermissions {
    
    // MARK: Mic Permission
    public class func askUserPermissionForTheMic() {
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission() {_ in }
    }
}
