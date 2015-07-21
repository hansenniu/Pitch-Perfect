//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Hansen Niu on 13/07/2015.
//  Copyright (c) 2015 Taika. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecord: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    var currentState : RecorderState = RecorderState.Stop
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecord.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        stopRecord.hidden = true
        recordButton.enabled = true
        statusLabel.text = "Tap to Record"
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        stopRecord.hidden = false
        switch (currentState) {
        case RecorderState.Stop:
            record()
        case RecorderState.Record:
            pause()
        case RecorderState.Pause:
            resume()
        }
    }
    
    func record() {
        currentState = RecorderState.Record
        statusLabel.text = "Recording. Tap to Pause"
        stopRecord.hidden = false
    
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func pause() {
        currentState = RecorderState.Pause
        statusLabel.text = "Pause. Tap to Resume"
        stopRecord.hidden = false
        audioRecorder.pause()
    }
    
    func resume() {
        currentState = RecorderState.Record
        statusLabel.text = "Recording. Tap to Pause"
        stopRecord.hidden = false
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil) //ensures correct playback volume
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not succesful")
            recordButton.enabled = true
            stopRecord.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecord(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

}

