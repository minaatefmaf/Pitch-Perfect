//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by Mina Atef on 4/2/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelBelowRecordingButton: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        // Hide the stop button
        stopButton.hidden = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        // Show text "recording"
        labelBelowRecordingButton.hidden = false
        // Show the stop button
        stopButton.hidden = false
    }

    @IBAction func stopButton(sender: UIButton) {
        // Hide the "recording" text
        labelBelowRecordingButton.hidden = true
    }
    
}

