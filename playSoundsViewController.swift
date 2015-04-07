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
    var audioPlayerForEcho: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        // Make the another copy of the recorded audio for the echo effect.
        audioPlayerForEcho = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
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
    
    @IBAction func playEchoAudio(sender: UIButton) {
        stopAudio()
        
        // Play the audio with echo effect
        var playTime: NSTimeInterval
        playTime = audioPlayerForEcho.deviceCurrentTime + 1/2

        audioPlayer.play()
        audioPlayerForEcho.playAtTime(playTime)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAudio()
        
        // Play the audio with reverb effect
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.loadFactoryPreset(.Cathedral)
        changeReverbEffect.wetDryMix = 50
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()

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
        audioPlayerForEcho.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // Make sure that the audio player has its default settings for rate and current time (In case we started the echo effect while (interrupting it) or after playing the sound in slow/fast modes)
        audioPlayer.rate = 1.0
        audioPlayer.currentTime = 0.0
    }
}
