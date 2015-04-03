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
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        // Enable the rate property to use it in playing the audio either in slow or fast modes
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        // Play audio slowly
        playAudioWithDifferentRates(0.5, startFromTheBeginning: true)
        audioPlayer.play()
    }

    @IBAction func playFastAudio(sender: UIButton) {
        // Play audio in fast mode
        playAudioWithDifferentRates(1.5, startFromTheBeginning: true)
        audioPlayer.play()
    }

    @IBAction func playChipmunkAudio(sender: UIButton) {
        // Play the audio with high pitch
        changePitchEffect(1000)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        // Play the audio with low pitch
        changePitchEffect(-1000)
    }
    
    @IBAction func stopPlayedSounds(sender: UIButton) {
        stopAudio()
    }
    
    func playAudioWithDifferentRates(rate: Float, startFromTheBeginning: Bool){
        stopAudio()
        
        audioPlayer.rate = rate
        if startFromTheBeginning {
            audioPlayer.currentTime = 0.0
        }
        audioPlayer.play()
    }
    
    func changePitchEffect(pitch: Float) {
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func stopAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
