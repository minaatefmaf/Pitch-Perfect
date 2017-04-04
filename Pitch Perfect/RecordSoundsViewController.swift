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
    private let session = AVAudioSession.sharedInstance()

    private var resumeRecording: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initiateTheScene()
    }

    @IBAction private func recordAudio(_ sender: UIButton) {
        // Make sure the app has the permission to record audio (or else, it will only record "silence")
        let micPermissionState = session.recordPermission()
        guard micPermissionState == .granted else {
            showAlertAndRedirectToSettings()
            return
        }
        
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
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch {
                showAlert(Alerts.ErrorTitle, message: Alerts.AudioSessionError)
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
                showAlert(Alerts.ErrorTitle, message: Alerts.AudioRecorderError)
            }
        }
        
        // Prepare recorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            // Move to the next scene (aka perform segue)
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        } else {
            showAlert(Alerts.RecordingFailedTitle, message: Alerts.RecordingFailedMessage)
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
            showAlert(Alerts.ErrorTitle, message: Alerts.AudioSessionError)
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
    
    private func showAlertAndRedirectToSettings() {
        let alert = UIAlertController(title: Alerts.RecordingDisabledTitle, message: Alerts.RecordingDisabledMessage, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: Alerts.GoToSettings, style: .default) { action in
            // Redirect the user to the app's settings in the general seeting app
            UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
        }
        let cancelAction = UIAlertAction(title: Alerts.AskLater, style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}

