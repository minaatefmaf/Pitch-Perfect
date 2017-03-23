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

    @IBOutlet private weak var labelBelowRecordingButton: UILabel!
    @IBOutlet private weak var stopButton: UIButton!
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet private weak var reRecordButton: UIButton!
    @IBOutlet private weak var pauseButton: UIButton!

    private var audioRecorder: AVAudioRecorder!
    private var recordedAudio: RecordedAudio!
    
    private var resumeRecording: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        initiateTheScene()
    }

    @IBAction private func recordAudio(_ sender: UIButton) {
        // Show text "recording"
        labelBelowRecordingButton.text = "recording..."

        // Show the re-record, pause, and stop buttons
        reRecordButton.isHidden = false
        pauseButton.isHidden = false
        stopButton.isHidden = false
        // Enable the pause button
        pauseButton.isEnabled = true
        // Disabling the record button so that the user of our app will now not be able to accidentally press the record button twice.
        recordButton.isEnabled = false
        
        // Record the user's voice
        if(resumeRecording == false) {
            // Prepare the file's path
            // Give the file a constant name "and path" so the file gets rewritten every time wih the same name
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(fileURLWithPath: pathArray.joined(separator: "/"))
            
            // Setup audio session
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch _ {
            }

            // Initialize recorder
            let settings = [
                //AVSampleRateKey: 12000.0,
                AVNumberOfChannelsKey: 1 as NSNumber,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ] as [String : Any]
            do {
                try audioRecorder = AVAudioRecorder(url: filePath, settings: settings)
            } catch {
                print("Seetings!!")
                //abort()
            }
            
        }
        
        // Prepare recorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            // Move to the next scene (aka perform segue)
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            print("Recording was not successful")
            recordButton.isEnabled = true
            stopButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            // Access to the "playSoundsViewController" class
            let playSoundsVC: playSoundsViewController = segue.destination as! playSoundsViewController
            
            // Pass our recorded sound
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction private func reRecordAudio(_ sender: UIButton) {
        initiateTheScene()
    }
    
    @IBAction private func pauseRecording(_ sender: UIButton) {
        // Enable the record button
        recordButton.isEnabled = true
        // Change the label below the recording button to "resume"
        labelBelowRecordingButton.text = "Tab to Resume"
        // Disable the pause button
        pauseButton.isEnabled = false
        
        // Enable the resuming mode
        resumeRecording = true
        // Pause recording the user's voice
        audioRecorder.pause()
    }
    
    @IBAction private func stopButton(_ sender: UIButton) {
        // Hide the "recording" text
        labelBelowRecordingButton.isHidden = true
        
        // Stop recording the user's voice
        audioRecorder.stop()
        // Deactivate the audio session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
            // To Play the audio on the loud speaker mode
            try audioSession.setCategory(AVAudioSessionCategoryAmbient)
        } catch _ {
        }
    }
    
    private func initiateTheScene() {
        // Initially hide the re-record, pause, and stop buttons
        reRecordButton.isHidden = true
        pauseButton.isHidden = true
        stopButton.isHidden = true
        // Enable the record button
        recordButton.isEnabled = true
        // Make sure the label below the recording button is "Tab to record"
        labelBelowRecordingButton.isHidden = false
        labelBelowRecordingButton.text = "Tab to Record"
        
        // Initially we're recording the audio for the first time
        resumeRecording = false
    }

}

