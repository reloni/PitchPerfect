//
//  PlaySoundController.swift
//  PitchPerfect
//
//  Created by Anton Efimenko on 04.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit
import AVFoundation

enum SoundType : Int {
	case snail = 0
	case rabbit
	case chipmunk
	case vader
	case echo
	case reverb
}

final class PlaySoundController : UIViewController {
	var voiceFile: URL!
	
	var audioPlayerNode: AVAudioPlayerNode!
	var audioEngine: AVAudioEngine!
	var stopTimer: Timer!
	var audioFile: AVAudioFile?
	
	@IBOutlet weak var snailButton: UIButton!
	@IBOutlet weak var rabbitButton: UIButton!
	@IBOutlet weak var chipmunkButton: UIButton!
	@IBOutlet weak var vaderButton: UIButton!
	@IBOutlet weak var echoButton: UIButton!
	@IBOutlet weak var reverbButton: UIButton!
	@IBOutlet weak var stopButton: UIButton!
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureUI(.notPlaying)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		do {
			audioFile = try AVAudioFile(forReading: voiceFile)
		} catch {
			showAlert(Alerts.AudioFileError, message: String(describing: error))
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}
	
	@IBAction func play(_ sender: UIButton) {
		guard let audioFile = audioFile else {
			// do nothing if audioFile didn't initialized
			return
		}
		switch SoundType(rawValue: sender.tag)! {
		case .snail: playSound(audioFile: audioFile, rate: 0.5)
		case .rabbit: playSound(audioFile: audioFile, rate: 1.5)
		case .chipmunk: playSound(audioFile: audioFile, pitch: 1000)
		case .vader: playSound(audioFile: audioFile, pitch: -1000)
		case .echo: playSound(audioFile: audioFile, echo: true)
		case .reverb: playSound(audioFile: audioFile, reverb: true)
		}
		configureUI(.playing)
	}
	
	@IBAction func stop(_ sender: UIButton) {
		stopAudio()
		configureUI(.notPlaying)
	}
}
