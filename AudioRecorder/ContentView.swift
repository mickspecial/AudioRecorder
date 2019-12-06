//
//  ContentView.swift
//  AudioRecorder
//
//  Created by Michael Schembri on 6/12/19.
//  Copyright © 2019 Michael Schembri. All rights reserved.
//

import SwiftUI

struct ContentView: View {

	@EnvironmentObject var recorder: Recorder

    var body: some View {
		NavigationView {
			VStack {
				Button(action: {
					self.beginRecording()
				}) {
					Image(systemName: recorder.isRecording ? "mic.slash" : "mic.fill")
						.foregroundColor(.red)
						.font(Font.system(size: 72))
				}
		}
		.navigationBarTitle("Recorder")

		}.onAppear {
			if !self.recorder.accessGranted {
				self.recorder.requestRecordingPermission()
			}
		}
	}

	private func beginRecording() {
		recorder.toggleRecordingSession()
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
