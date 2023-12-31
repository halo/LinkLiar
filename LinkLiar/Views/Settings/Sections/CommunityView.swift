// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

extension SettingsView {
  struct CommunityView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      ScrollView {
        Image(systemName: "figure.wave")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 25, height: 22)
          .padding(.top, 20)
          .padding(.bottom, 12)
        Text("Discussions, Suggestions, Questions").font(.title3)

        GroupBox {
          HStack {
            VStack(alignment: .leading) {
              Text("If you're just wondering about something, would like to give feedback, or pitch an idea for improvement, ") +
              Text("please go open  ")
              Link(Urls.githubDiscussions, destination: Urls.githubDiscussionsURL)
              Text("and see if you can start a discussion. ") +
              Text("While it can't be guaranteed that you'll get an immediate answer, ") +
              Text(" you can be sure that it will be read within hours.")
            }
            Spacer()
          }
        }.padding(.bottom)

        Image(systemName: "cloud.drizzle.fill")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 35, height: 30)
        Text("Bugs, Issues, Problems").font(.title3)

        GroupBox {
          HStack {
            VStack(alignment: .leading) {
              Text("It can happen that LinkLiar doesn't work properly in certain cases. ") +
              Text("If you believe that you encountered a reproducable error, please head over to ")
              Link(Urls.githubIssues, destination: Urls.githubIssuesURL)
              Text("and see if there already is an issue open for your problem. ") +
              Text("If not, please feel free to open a new issue.")
            }
          Spacer()
          }
        }.padding(.bottom)

        Image(systemName: "swift")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 34, height: 25)
          .padding(.top, 12)
        Text("Programming").font(.title3)

        GroupBox {
          HStack {
            VStack(alignment: .leading) {
              Text("Maybe you want to improve your programming skills or just make sure that LinkLiar ") +
              Text("is not some fishy malware. You can do so at  ")
              Link(Urls.githubRepo, destination: Urls.githubRepoURL)
              Text("to check out the programming code. ") +
              Text("You can fork the repository, make changes to the code, and open pull requests.")
            }
          Spacer()
          }
        }.padding(.bottom)

      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  return SettingsView.CommunityView().environment(state)
}
