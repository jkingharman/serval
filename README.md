## Installation  ##

First checkout this repo: ```git clone https://github.com/jkingharman/serval.git``` Then:

```
cd serval
bundle install
```

You can run the test suite with: ```rspec -fd```

To test the service manually, expose the service on port 9292 with ```rackup```.
You can then test via the browser or cURL.

## Core Dependencies ##

* Grape
* Rack
* RSpec
