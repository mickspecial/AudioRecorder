//
//  Recorder.swift
//  AudioRecorder
//
//  Created by Michael Schembri on 6/12/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import Foundation
import AVFoundation

class Recorder: NSObject, ObservableObject, AVAudioRecorderDelegate {

	var recordingSession: AVAudioSession
	var audioRecorder: AVAudioRecorder? {
		didSet {
			isRecording = (audioRecorder != nil)
		}
	}

	@Published var accessGranted = false
	@Published var isRecording = false

	override init() {
		recordingSession = AVAudioSession.sharedInstance()
		super.init()
	}

	// unable to record unless user grants access to mic
	func requestRecordingPermission() {
		do {
			try recordingSession.setCategory(.playAndRecord, mode: .default)
			try recordingSession.setActive(true)
			recordingSession.requestRecordPermission() { [weak self] allowed in
				DispatchQueue.main.async {
					if allowed {
						self?.accessGranted = true
					}
				}
			}
		} catch {
			// failed
		}
	}

	func toggleRecordingSession() {
		if isRecording {
			finishRecording(success: true)
		} else {
			startRecording()
		}
	}

	private func startRecording() {
		print("request to start recording")

		let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]

		do {
			audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
			audioRecorder?.delegate = self
			// no limit
			// audioRecorder?.record()

			// 3 second clip
			audioRecorder?.record(forDuration: 3)
			print("--- recording ---")
			print(audioFilename)
		} catch {
			finishRecording(success: false)
		}
	}

	private func finishRecording(success: Bool) {
		print("stop")
		audioRecorder?.stop()
		audioRecorder = nil
	}

	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		finishRecording(success: flag)
		print("Did end flag \(flag)")
	}

	private func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}
