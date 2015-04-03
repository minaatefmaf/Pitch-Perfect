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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Add a path to our movie_qoute.mp3 file.
        if let filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
            // change the file path url from string to NSURL and use it to initiate the AVAudioPlayer instance
            let filePathUrl = NSURL.fileURLWithPath(filePath)
            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
            // Enable the rate property to use it in playing the audio either in slow or fast modes
            audioPlayer.enableRate = true
        } else {
            println("the filePath is empty")
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPlayedSounds(sender: UIButton) {
        audioPlayer.stop()
    }
    
    func playAudioWithDifferentRates(rate: Float, startFromTheBeginning: Bool){
        audioPlayer.stop()
        audioPlayer.rate = rate
        if startFromTheBeginning {
            audioPlayer.currentTime = 0.0
        }
        audioPlayer.play()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
