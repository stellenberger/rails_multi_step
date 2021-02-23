![Deploy](https://github.com/DFE-Digital/govuk-rails-boilerplate/workflows/Deploy/badge.svg)

# GOV.UK Rails Boilerplate

# What this repo is

This repo is taken from the GovUK boilerplate and displays the first versions of the Wizard Steps gem for creating multi part forms with ease. 

```
$ bundle install
```

## Here are some instructions in how to create multi-step forms with the Wizard Steps gem

Firstly, there is a pre-requisite of knowing what a multi-step form is if you dont already. A great resource is [this rails cast](http://railscasts.com/episodes/217-multistep-forms).

To use this gem, you will need to register your steps in a wizard.rb file, located at the base of your multi step folder. Take the following file structure below as an example for a model to create a user

|models
|__user_creation
|  |__steps
|  |  |__register_name.rb 
|  |  |__register_age.rb
|  |  |__register_gender.rb
|  |  |__review_answers.rb
|  |__wizard.rb  <--- register your steps here

For the above example with four steps and a User class, lets have a look at what the wizard.rb could look like: 

```
# app/models/user_creation/wizard.rb

require 'wizard_steps/base'

module UserCreation
  class Wizard < WizardSteps::Base
    self.steps = [
      Steps::RegisterName,
      Steps::RegisterAge,
      Steps::RegisterGender,
      Steps::ReviewAnswers
    ].freeze

  private

    def do_complete
      User.create!(
        first_name: @store.data["first_name"],
        last_name: @store.data["last_name"],
        date_of_birth: @store.data["date_of_birth"],
        gender: @store.data["gender"],
      )
    end
  end
end
```

Cool. You create a module to wrap the multi step form. Inside this module, create a new wizard which derives from WizardSteps::Base, and register the steps you plan on using. These steps should reflect what you have in your views and in the steps folder in the current directory. 

The private method, do_complete, is what will be called **once the form has been submitted fully, ie when all the steps are complete**, and is what will be written into the db. 

In this example, our multi step form is for the User model, so we ask various attributes in each step, such as Name, Age and Gender, store it, review the answers, and if all is good, we submit it. 

Wait, but what does each step look like? Similarly to the above, it follows a modular pattern. Take the below as an example. 

```
# app/models/steps/register_name.rb

require 'wizard_steps/step'

module UserCreation
  module Steps
    class RegisterName < WizardSteps::Step
      include ActiveRecord::AttributeAssignment

      attribute :first_name, :string
      attribute :last_name, :string

      validates :first_name, :last_name
      presence: true

      def reviewable_answers
        {
          "name" => "#{first_name} #{last_name}"
        }
      end
    end
  end
end
```

I wont dive into this too deeply, but as you can see its similar to the above. Wrap your modules up, and derive the step name (`RegisterName`) from `WizardSteps::Step`. Validate the fields you wish to add to the store. 

Your review answers can look something like this: 

```
require 'wizard_steps/step'

module UserCreation
  module Steps
    class ReviewAnswers < WizardSteps::Step
      def answers_by_step
        @answers_by_step ||= @wizard.reviewable_answers_by_step
      end
    end
  end
end

```

Lets move onto the controller. 

Your controller layour should be something like the following: 

|controllers
|__user_creation
|  |__steps_controller.rb

Yep, its that simple.

```
# app/controllers/user_creation/steps_controller.rb

module UserCreation
  class StepsController < ApplicationController
    include WizardSteps
    self.wizard_class = UserCreation::Wizard

  private

    def step_path(step = params[:id])
      user_creation_step_path(step)
    end

    def wizard_store_key
      :user_creation
    end

    def on_complete(child)
      redirect_to(<your custom route>)
    end
  end
end
```

Inside the module for your steps, you can see it follows a general controller layout deriving from ApplicationController. 

And the views; 

|views
|__user_creation
|  |__ _register_name.html.erb
|  |__ _register_age.html.erb
|  |__ _register_gender.html.erb
|  |__ _review_answers.html.erb
|  |__show.html.erb

```
# app/views/user_creation/_register_name.html.erb
<%= f.govuk_fieldset legend: { text: "Name" } do %>
  <%= f.govuk_text_field :first_name, label: { text: 'First name' } %>
  <%= f.govuk_text_field :last_name %>
<% end %>
```

```
# app/views/user_creation/show.html.erb
<%= render "form", current_step: current_step, wizard: wizard %>
```

```
# app/views/user_creation/show.html.erb
<%= render "form", current_step: current_step, wizard: wizard %>
```

And finally, in your routes

```
namespace :children_creation do
  resources :steps, only: %i[show update]
end
```
## Prerequisites

- Ruby 2.7.1
- PostgreSQL
- NodeJS 12.13.x
- Yarn 1.12.x

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bin/rails db:setup` to set up the database development and test schemas, and seed with test data
4. Run `bundle exec rails server` to launch the app on http://localhost:3000
5. Run `./bin/webpack-dev-server` in a separate shell for faster compilation of assets

## Whats included in this boilerplate?

- Rails 6.0 with Webpacker
- [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
- RSpec
- Dotenv (managing environment variables)
- Travis with Heroku deployment
- Docker and docker compose

## Running specs, linter(without auto correct) and annotate models and serializers
```
bundle exec rake
```

## Running specs
```
bundle exec rspec
```

## Linting

It's best to lint just your app directories and not those belonging to the framework, e.g.

```bash
bundle exec rubocop app config db lib spec Gemfile --format clang -a

or

bundle exec scss-lint app/webpacker/styles
```

## Docker

### Why use Docker?
- Run the application locally without installing dependencies (postgres, system libraries...)
- Run in a Linux environment similar to production
- Simulate running in production with dependencies using docker-compose
- Package the application so it can be versioned and deployed to multiple environments

### Prerequisites
- Docker >= 19.03.12

### Build
```
make build-local-image
```

It relies heavily on caching. The first build may be slow and subsequent ones faster.

### Single docker image
The docker image doesn't contain a default command. Any command can be appended:
```
% docker run -p 3001:3000 dfedigital/govuk-rails-boilerplate:latest rails -vT
rails about                              # List versions of all Rails frameworks and the environment
rails action_mailbox:ingress:exim        # Relay an inbound email from Exim to Action Mailbox (URL and INGRESS_PASSWORD required)
...
```

### Run in production mode
Docker compose provides a default empty database to run rails in production mode.

```
docker-compose up
```

Open: http://localhost:3000

## Deploying on GOV.UK PaaS

### Prerequisites

- Your department, agency or team has a GOV.UK PaaS account
- You have a personal account granted by your organisation manager
- You have downloaded and installed the [Cloud Foundry CLI](https://github.com/cloudfoundry/cli#downloads) for your platform

### Deploy

1. Run `cf login -a api.london.cloud.service.gov.uk -u USERNAME`, `USERNAME` is your personal GOV.UK PaaS account email address
2. Run `bundle package --all` to vendor ruby dependencies
3. Run `yarn` to vendor node dependencies
4. Run `bundle exec rails webpacker:compile` to compile assets
5. Run `cf push` to push the app to Cloud Foundry Application Runtime

Check the file `manifest.yml` for customisation of name (you may need to change it as there could be a conflict on that name), buildpacks and eventual services (PostgreSQL needs to be [set up](https://docs.cloud.service.gov.uk/deploying_services/postgresql/)).

The app should be available at https://govuk-rails-boilerplate.london.cloudapps.digital
