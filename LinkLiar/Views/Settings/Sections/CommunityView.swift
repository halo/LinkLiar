// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

extension SettingsView {
  struct CommunityView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      ScrollView {
        VStack(alignment: .center) {
          Image(systemName: "bubble.left.and.bubble.right.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .padding(.bottom, 3)
          Text("LinkLiar Community").bold()
        }.padding()

        GroupBox {
          VStack {
            Image(systemName: "figure.wave")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 20)
            Text("Say Hello!").italic()
          }.padding(.top)

          HStack {
            VStack(alignment: .leading) {
              Text("If you have questions, or ideas for improvement, start a discussion at")
              HStack {
                Spacer()
                Link(Urls.githubDiscussionsURL.host! + Urls.githubDiscussionsURL.path, destination: Urls.githubDiscussionsURL)
                Spacer()
              }.padding(2)
              Text("You may not get an immediate answer, but it will be read within hours.")
            }
            Spacer()
          }.padding(5)
        }.padding(.bottom)

        GroupBox {
          VStack {
            Image(systemName: "cloud.drizzle.fill")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 30)
            Text("Report problems").italic()
          }.padding(.top)

          HStack {
            VStack(alignment: .leading) {
              Text("If you encountered a reproducable error, please look for issues at ")
              HStack {
                Spacer()
                Link(Urls.githubIssuesURL.host! + Urls.githubIssuesURL.path, destination: Urls.githubIssuesURL)
                Spacer()
              }.padding(2)
              Text("It can happen that LinkLiar doesn't work properly, so tell us about it. ")
            }
            Spacer()
          }.padding(5)
        }.padding(.bottom)

        GroupBox {
          VStack {
            Image(systemName: "keyboard.fill")
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: 31)
            Text("Learn programming").italic()
          }.padding(.top)

          HStack {
            VStack(alignment: .leading) {
              Text("Fork the repository, make changes to code, and open pull requests at")
              HStack {
                Spacer()
                Link(Urls.githubRepoURL.host! + Urls.githubRepoURL.path, destination: Urls.githubRepoURL)
                Spacer()
              }.padding(2)
              Text("It's always hard to get started, so we aim for quality documentation.")
            }
            Spacer()
          }.padding(5)
        }.padding(.bottom)

      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  return SettingsView.CommunityView().environment(state).frame(width: 500)
}
