### Steps to Run the App
1) Make sure you're running Xcode 15 or higher.
2) Clone the project on GitHub - git clone https://github.com/Kevin-Galarza/FetchRecipes.git
3) Open the project in Xcode, build it, and run it on a simulator or physical device running iOS 16+.

The project includes a `Configuration` to quickly switch between the various recipe API paths (normal, malformed, empty). You can also change the cache storage location here.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I focused on implementing a scalable MVVM architecture and robust cache & image loader within the time constraints. I also focused on delivering a simple and clean UI instead of something with many bells and whistles. When there are strict time or economic constraints, I stick to an MVP methodology and deliver a simple product that runs reliably and meets core requirements. In my opinion, this is more valuable than something that looks good but doesn't perform as expected.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I worked on this project for about 10-12 hours. I completed this over the holiday week and worked on it over several days in short work sessions. There was likely a small loss in velocity completing it this way (1-2 hours).

Honestly, I thought the 4-5 hour estimate in the project instructions was somewhat ambitious. Perhaps past candidates were significantly more skilled, but I don't think I'd be able to complete this project in that time frame without delivering a simpler version that does a poor job of showcasing my engineering skills.

Time Allocation Estimate
~ 1 hour planning, considering requirements, and creating a simple UI design in Figma.
~ 8 hours writing code, about an hour setting up the project architecture/structure, 4-5 hours on the Data and UI layers, about an hour handling edge cases, and the rest of this time went towards research/reading documentation as needed.
~ 2 hours writing unit tests, functional testing, and project debugging.
~ 1 hour working on project cleanup and writing this README.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
To save time on writing boilerplate and putting together additional structure code, I decided to omit the Repository Pattern implementation in my data layer. That is, the APIClient, DiskCache, and ImageLoader are coupled directly to higher-level code (the view model in this case). 

Usually, when structuring projects on iOS, I like to use an architecture that includes Scoped Dependency Containers, MVVM, and a data layer that abstracts away access to resources related to persistence, networking, some business logic, etc. I find this architecture has several benefits, including:

1) Makes it easy to work with other developers/designers in parallel.
2) Yields highly testable view models and data layer code. View models are treated as pure mappings of input/output signals, and the Repository Pattern enables you to easily sub a mock as the concrete instance of whatever object you're working with.
3) Helps you avoid tight coupling between components in your project.
4) Results in a codebase that is well-structured and scalable without requiring too much boilerplate or over-engineering.

Example High-Level Project Structure:

- AppDelegate
- SceneDelegate
- AppContainer
- Data Layer
  - Models
  - Tools
  - Database Services
    - Customers Service
      - Customers Repository
      - Customers Data Store (protocol)
      - SQLite Customers Data Store (concrete, conforms to data store protocol)
      - Mock SQLite Customers Data Store (testing, conforms to data store protocol)
    - Products Service
    ...
  - API Services
  ...
- UI Layer
  - Project UIKit
  - Onboarding
    - Onboarding Container
    - Onboarding View Controller
    - Onboarding View Model
    - Onboarding Root View
  - SignUp
  ...
  - SignedIn
  ...

### Weakest Part of the Project: What do you think is the weakest part of your project?
The unit test coverage is not great. I think this can be improved. I also think the performance of the collection view when filtering or refreshing can be improved by using a diffable data source. I am not super familiar with this part of the UIKit SDK and didn't have time to implement it in my solution. My understanding is that this will improve the management of data in the collection view and will enable smooth animations when updates occur. Right now, the updates to the collection view appear to be somewhat jarring.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Overall, I found this take-home project to be interesting. I am very interested in the opportunity to work for Fetch. I'm not sure if this project submission is coming in too late. Unfortunately, the initial email from the recruiter was lost in my spam mailbox for a couple of weeks. I stumbled on it by chance right before the holidays.

In any case, if you are still interviewing candidates, I hope you'll give me a shot. I'm eager to join a new company, learn and expand my skills, and contribute using my experience. Thank you for the opportunity, and I hope you enjoy reviewing this project.