//
//  recordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Aabhimanyu Gupta on 23/09/16.
//  Copyright © 2016 Aabhimanyu Gupta. All rights reserved.
//

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController , AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {
        recordingLabel.text = "Recording in Progress"
        buttonDisable(type: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
        recordingLabel.text = "Tap to Record"
        buttonDisable(type: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func buttonDisable(type : Bool) -> Void {
            recordButton.isEnabled = !type
            stopRecordingButton.isEnabled = type
        }
    
   
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag:Bool){
        if (flag) {
            performSegue(withIdentifier: "stopRecording", sender:audioRecorder.url)
        } else {
            print("Saving od Recording Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as!
                PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

