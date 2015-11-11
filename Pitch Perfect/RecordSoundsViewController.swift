//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mina Atef on 4/2/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var labelBelowRecordingButton: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var reRecordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    var resumeRecording: Bool!
    
    override func viewWillAppear(animated: Bool) {
        initiateTheScene()
    }

    @IBAction func recordAudio(sender: UIButton) {
        // Show text "recording"
        labelBelowRecordingButton.text = "recording"

        // Show the re-record, pause, and stop buttons
        reRecordButton.hidden = false
        pauseButton.hidden = false
        stopButton.hidden = false
        // Enable the pause button
        pauseButton.enabled = true
        // Disabling the record button so that the user of our app will now not be able to accidentally press the record button twice.
        recordButton.enabled = false
        
        // Record the user's voice
        
        if(resumeRecording == false) {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] 
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            // Setup audio session
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch _ {
            }

            // Initialize recorder
            let settings = [
                AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
            ]
            do {
                try audioRecorder = AVAudioRecorder(URL: filePath!, settings: settings)
            } catch {
                print("Seetings!!")
                //abort()
            }
            
        }
        
        // Prepare recorder
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            // Move to the next scene (aka perform segue)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            // Access to the "playSoundsViewController" class
            let playSoundsVC: playSoundsViewController = segue.destinationViewController as! playSoundsViewController
            
            // Pass our recorded sound
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func reRecordAudio(sender: UIButton) {
        initiateTheScene()
    }
    
    @IBAction func pauseRecording(sender: UIButton) {
        // Enable the record button
        recordButton.enabled = true
        // Change the label below the recording button to "resume"
        labelBelowRecordingButton.text = "resume"
        // Disable the pause button
        pauseButton.enabled = false
        
        // Enable the resuming mode
        resumeRecording = true
        // Pause recording the user's voice
        audioRecorder.pause()
    }
    
    @IBAction func stopButton(sender: UIButton) {
        // Hide the "recording" text
        labelBelowRecordingButton.hidden = true
        
        // Stop recording the user's voice
        audioRecorder.stop()
        // Deactivate the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch _ {
        }
    }
    
    func initiateTheScene() {
        // Initially hide the re-record, pause, and stop buttons
        reRecordButton.hidden = true
        pauseButton.hidden = true
        stopButton.hidden = true
        // Enable the record button
        recordButton.enabled = true
        // Make sure the label below the recording button is "Tab to record"
        labelBelowRecordingButton.hidden = false
        labelBelowRecordingButton.text = "Tab to Record"
        
        // Initially we're recording the audio for the first time
        resumeRecording = false
    }

}

