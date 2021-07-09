---
layout: default
---

## Design

### Direction

The goal of this project is to become a "reference microservices demo".
To this end, it aims to:

- Demonstrate microservice best practices (and mistakes!)
- Be cross-platform: deploy to all orchestrators
- Show the benefits of continuous integration/deployment
- Demonstrate how dev-ops and microservices compliment each other
- Provide a "real-life" testable application for various orchestration
  platforms

### Architecture

![Architecture diagram](https://github.com/microservices-demo/microservices-demo.github.io/blob/HEAD/assets/Architecture.png "Architecture")

The architecture of the demo microservices application was intentionally designed to provide as many microservices as possible. If you are considering your own design, we would recommend the iterative approach, whereby you only define new microservices when you see issues (performance/testing/coupling) developing in your application.

Furthermore, it is intentionally polyglot to exercise a number of different technologies. Again, we'd recommend that you only consider new technologies based upon a need.

As seen in the image above, the microservices are roughly defined by the function in an ECommerce site. Networks are specified, but due to technology limitations may not be implemented in some deployments.

All services communicate using REST over HTTP. This was chosen due to the simplicity of development and testing. Their API specifications are under development.
