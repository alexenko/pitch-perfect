//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Gavrilenko, Alexander on 3/16/15.
//  Copyright (c) 2015 Gavrilenko, Alexander. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (receivedAudio.filePathURL != ""){
            audioEngine = AVAudioEngine()
            audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        } else {
            println("The file path is empty")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioEngine(0.65, changePitch: false)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioEngine(1.5, changePitch: false)
    }

    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioEngine(1000, changePitch: true)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioEngine(-1000, changePitch: true)
    }
    
    func stopAllAudio(){
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioEngine(controlValue: Float, changePitch: Bool){
        // changePitch 0 = speed
        // changePitch 1 = pitch
        stopAllAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeEffect = AVAudioUnitTimePitch()
        if changePitch {
            changeEffect.pitch = controlValue
        }
        else {
            changeEffect.rate = controlValue
        }
        
        audioEngine.attachNode(changeEffect)
        audioEngine.connect(audioPlayerNode, to: changeEffect, format: nil)
        audioEngine.connect(changeEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
}
