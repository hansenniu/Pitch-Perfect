//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Hansen Niu on 14/07/2015.
//  Copyright (c) 2015 Taika. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var overrideError:NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func playbackSpeed() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.play()
    }

    func stopAudio() {
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudio()
    }

    @IBAction func slowSnail(sender: UIButton) {
        audioPlayer.rate = 0.5
        playbackSpeed()
    }

    @IBAction func fastRabbit(sender: UIButton) {
        audioPlayer.rate = 2.0
        playbackSpeed()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEcho(sender: UIButton) {
        playbackSpeed()
        let delay:NSTimeInterval = 0.3
        var playingtime:NSTimeInterval
        playingtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.playAtTime(playingtime)
    }
    
    @IBAction func playReverb(sender: UIButton) {
        playWithReverb(85)
    }

    func playWithReverb(effect : Float) {
        stopAudio()
        
        var audioPlayerNode2 = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode2)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = effect
        audioEngine.attachNode (reverbEffect)
        
        audioEngine.connect(audioPlayerNode2, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
       
        audioPlayerNode2.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
    
        audioPlayerNode2.play()
    }

    func playAudioWithVariablePitch(pitch: Float){
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
    
}



