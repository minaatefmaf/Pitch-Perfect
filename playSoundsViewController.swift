//
//  playSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mina Atef on 4/3/15.
//  Copyright (c) 2015 minaatefmaf. All rights reserved.
//

import UIKit
import AVFoundation

class playSoundsViewController: UIViewController {
    
    @IBOutlet private weak var slowButton: UIButton!
    @IBOutlet private weak var fastButton: UIButton!
    @IBOutlet private weak var chipmunkButton: UIButton!
    @IBOutlet private weak var darthvaderButton: UIButton!
    @IBOutlet private weak var echoButton: UIButton!
    @IBOutlet private weak var reverbButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    private var audioPlayer: AVAudioPlayer!
    private var audioPlayerForEcho: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile!
    
    enum PlayingState { case playing, notPlaying }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = try? AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        // Make the another copy of the recorded audio for the echo effect.
        audioPlayerForEcho = try? AVAudioPlayer(contentsOf: receivedAudio.filePathUrl as URL)
        
        // Enable the rate property to use it in playing the audio either in slow or fast modes
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        // initialize (recording) audio file
        do {
            audioFile = try AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        } catch let error {
            showAlert(Alerts.AudioFileError, message: String(describing: error.localizedDescription))
        }
        
        // Setup the audio session so that the played back sound works even in silent mode
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
        } catch {
            showAlert(Alerts.ErrorTitle, message: Alerts.AudioSessionError)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // configure the UI for the initial state
        configureUI(.notPlaying)
    }
    
    @IBAction private func playSlowAudio(_ sender: UIButton) {
        // configure the UI for the "playing" mode
        configureUI(.playing)
        
        // Play audio slowly
        playAudioWithDifferentRates(0.5, startFromTheBeginning: true)
        audioPlayer.play()
    }

    @IBAction private func playFastAudio(_ sender: UIButton) {
        // configure the UI for the "playing" mode
        configureUI(.playing)
        
        // Play audio in fast mode
        playAudioWithDifferentRates(1.5, startFromTheBeginning: true)
        audioPlayer.play()
    }

    @IBAction private func playChipmunkAudio(_ sender: UIButton) {
        // configure the UI for the "playing" mode
        configureUI(.playing)
        
        // Play the audio with high pitch
        changePitchEffect(1000)
        
    }
    
    @IBAction private func playDarthvaderAudio(_ sender: UIButton) {
        // configure the UI for the "playing" mode
        configureUI(.playing)
        
        // Play the audio with low pitch
        changePitchEffect(-1000)
    }
    
    @IBAction private func playEchoAudio(_ sender: UIButton) {
        // configure the UI for the "playing" mode
        configureUI(.playing)
        
        stopAudio()
        
        // Play the audio with echo effect
        var playTime: TimeInterval
        playTime = audioPlayerForEcho.deviceCurrentTime + 1/2

        audioPlayer.play()
        audioPlayerForEcho.play(atTime: playTime)
    }
    
    @IBAction private func playReverbAudio(_ sender: UIButton) {
        // configure the UI for the "playing" mode
        configureUI(.playing)
        
        stopAudio()
        
        // Play the audio with reverb effect
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(.cathedral)
        changeReverbEffect.wetDryMix = 50
        audioEngine.attach(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.ErrorTitle, message: Alerts.AudioEngineError)
        }
        
        audioPlayerNode.play()

    }
    
    @IBAction private func stopPlayedSounds(_ sender: UIButton) {
        stopAudio()
        
        // configure the UI for the "not playing" mode
        configureUI(.notPlaying)
    }
    
    private func playAudioWithDifferentRates(_ rate: Float, startFromTheBeginning: Bool){
        stopAudio()
        
        audioPlayer.rate = rate
        if startFromTheBeginning {
            audioPlayer.currentTime = 0.0
        }
        audioPlayer.play()
    }
    
    private func changePitchEffect(_ pitch: Float) {
        stopAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.ErrorTitle, message: Alerts.AudioEngineError)
        }
        
        audioPlayerNode.play()
    }
    
    private func stopAudio() {
        audioPlayer.stop()
        audioPlayerForEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Make sure that the audio player has its default settings for rate and current time (In case we started the echo effect while (interrupting it) or after playing the sound in slow/fast modes)
        audioPlayer.rate = 1.0
        audioPlayer.currentTime = 0.0
    }
    
    
    // MARK: UI Functions
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        slowButton.isEnabled = enabled
        fastButton.isEnabled = enabled
        chipmunkButton.isEnabled = enabled
        darthvaderButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }
    
    private func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
}
