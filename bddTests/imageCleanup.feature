Feature: Task 84101 - Build: image cleanup in build extension
As a pipeline user I want to have an image quota in the build job to limit images so that I can both version images, and maintain an organized image registry that is within the registry limits.

@createimages1
Scenario: Start with less images
Given I have a setup pipeline with a Container Image Build Stage
And I have set the number images to keep to a value below the ICS image limit
And I have less than the image limit in images (used and unused)
When The container Image Build job is run
Then The new image is built

@createimages5
Scenario: Start with more unused images
Given I have a setup pipeline with a Container Image Build Stage
And I have set the number images to keep to a value below the ICS image limit
And I have less than the image limit in used images
And I have more than the image limit in used and unused images
When The container Image Build job is run
Then The new image is built
And unused images will be deleted from oldest to newest until we are under the limit

@createimages5
@useimages3
Scenario: Too many used images
Given I have a setup pipeline with a Container Image Build Stage
And I have set the number images to keep to a value below the ICS image limit
And I have as many or more than the image limit in currently used images
When The container Image Build job is run
Then The new image is built
And all unused images will be deleted
And no used images will be deleted
And A warning will be issued that the images in use could not be deleted

@wip
Scenario: At ICS image limit
Given I have a setup pipeline with a Container Image Build Stage
And I have set the number images to keep to a value equal to or greater than the ICS image limit
And I am currently at the ICS image limit
When The container Image Build job is run
Then The job will fail because the ICS image limit is reached

@wip
Scenario: Negative number set
Given I have a setup pipeline with a Container Image Build Stage
And I have set the number images to keep to a negative number
When The container Image Build job is run
Then The new image is built
And no images will be deleted

@wip
Scenario: Default value with extra unused images
Given I have a setup pipeline with a Container Image Build Stage
And There is no user-defined image limit
And I have less than the default image limit in currently used images
When The container Image Build job is run
Then The new image is built
And unused images will be deleted from oldest to newest until we are under the limit

@wip
Scenario: Default value with extra used images
Given I have a setup pipeline with a Container Image Build Stage
And There is no user-defined image limit
And The default max limit has been reached
When The container Image Build job is run
Then The new image is built
And all unused images will be deleted
And A warning will be issued that the images in use could not be deleted