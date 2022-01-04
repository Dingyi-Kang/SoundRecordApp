//
//  ViewController.swift
//  Sound Recorder App
//
//  Created by OSU App Center on 8/3/21.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    //tell the iphone what type of recording we are doing/which speaker to use, either main speaker or earpiece
    var recordingSession: AVAudioSession!
    //the object allowing us to record audio
    var audioRecorder: AVAudioRecorder!
    //the object allowing us to play the audio
    var audioPlayer: AVAudioPlayer!
    
    let sounds = ["a", "b", "c", "d"]
    
    
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonD: UIButton!
    
    
    //set different settings for our recording, like quality of a recording
    let settings = [AVFormatIDKey:Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 12000, AVNumberOfChannelsKey:1, AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let longPressRecognizerA = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonA.addGestureRecognizer(longPressRecognizerA)
        
        let longPressRecognizerB = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonB.addGestureRecognizer(longPressRecognizerB)
        
        let longPressRecognizerC = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonC.addGestureRecognizer(longPressRecognizerC)
        
        let longPressRecognizerD = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        buttonD.addGestureRecognizer(longPressRecognizerD)
        
        recordingSession = AVAudioSession.sharedInstance()
        AVAudioSession.sharedInstance().requestRecordPermission { (accept) in
            if accept {
                print("Permission granted")
            }
        }
        
    }
    
    //return a url where we can save our recordings
    func getDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let tag = sender.tag
        let path = getDirectory().appendingPathComponent("\(tag).m4a")
        let pathString = path.path
        //check if there is recorder file
        if FileManager.default.fileExists(atPath: pathString) {
            //play the recorded file
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: path)
                audioPlayer.play()
            }
            catch{}
            
            return
        }
        //if not exist, play the deafult sound
        let url = Bundle.main.url(forResource: self.sounds[sender.tag], withExtension: "mp3")
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url!)
            audioPlayer.play()
        }
        catch{}
        
    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer){
        
        let button = sender.view as? UIButton
        let tag = sender.view?.tag
        
        //when press the button
        if sender.state == .began {
            
            button?.setTitle("Recording", for: .normal)
            
            
            do {
                //tell the iphone we wannt to record it
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
                //this make sure we play the sound on speaker instead of just eariece
                try recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                //where to the save the record
                let fileName = getDirectory().appendingPathComponent("\(tag!).m4a")
                //create file recorder object
                audioRecorder = try AVAudioRecorder(url: fileName, settings: settings)
                //begin to record
                audioRecorder.record()
                
            }catch{
                print("!!")
            }
            
            
            
        }//when let the buttion go
        else if sender.state == .ended {
            
            button?.setTitle("Play", for: .normal)
            audioRecorder.stop()
            audioRecorder = nil
            
        }
        
    }
    
}

