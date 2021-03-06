//
//  RecordController.swift
//  PitchPerfect
//
//  Created by Anton Efimenko on 04.01.17.
//  Copyright © 2017 Anton Efimenko. All rights reserved.
//

import UIKit
import AVFoundation

class RecordController: UIViewController {
	@IBOutlet weak var stopButton: UIButton!
	@IBOutlet weak var infoLabel: UILabel!
	@IBOutlet weak var recordButton: UIButton!
	
	let voiceFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("voice.wav")
	var recorder: AVAudioRecorder?

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		AVAudioSession.sharedInstance().requestRecordPermission { response in
			DispatchQueue.main.async {
				self.recordButton.isEnabled = response
			}
			
			if !response {
				self.showErrorAlert(message: "Microphone permission denied. Go to setting to allow microphone access")
			}
		}
	}

	@IBAction func startRecord(_ sender: Any) {
		recordButton.isEnabled = false
		stopButton.isEnabled = true
		
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
			recorder = try AVAudioRecorder(url: voiceFile, settings: [:])
			recorder?.isMeteringEnabled = true
			recorder?.delegate = self
			recorder?.prepareToRecord()
			recorder?.record()
			
			infoLabel.text = "Recordind in progress"
		} catch {
			recordButton.isEnabled = true
			stopButton.isEnabled = false
			showErrorAlert(message: "Unable to start recording")
		}
	}
	
	func showErrorAlert(message: String) {
		let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
		alert.addAction(ok)
		present(alert, animated: true, completion: nil)
	}
	
	@IBAction func stopRecord(_ sender: Any) {
		recordButton.isEnabled = true
		stopButton.isEnabled = false
		infoLabel.text = "Tap to Record"
		
		guard let recorder = recorder else { return }
		
		recorder.stop()
		_ = try? AVAudioSession.sharedInstance().setActive(false)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "ShowPlaySoundController" else { return }
		guard let controller = segue.destination as? PlaySoundController else { return }
		controller.voiceFile = voiceFile
	}
}

extension RecordController : AVAudioRecorderDelegate {
	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		guard flag else {
			showErrorAlert(message: "Unable to record sound")
			return
		}
		performSegue(withIdentifier: "ShowPlaySoundController", sender: nil)
	}
}

