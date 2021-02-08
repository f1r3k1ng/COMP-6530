# COMP-6530
## Alexa-Watson
### General Overview
For the second assignement we were required to create an Amazon Alexa skill that would take in user voice commands and then send the information to IBM Watson Assistant. The Watson Assistant would then do the computational work to determine a response and then send that response to Alexa. In order for Alexa and the Watson Assistant to communicate we had to write a middleware cloud function that acted as a translator. The Alexa request was formatted so that Watson could understand it and the Watson response was formatted so taht Alexa could understand it.
### How to Run Locally
1. [Clone the repo](#1-clone-the-repo)
2. Create an Alexa Skill
3. Create a Watson Assistant Skill
4. Configure your parameters
5. Create a cloud function
6. Begin using your app

### Steps
#### 1. Clone the Repo
Clone the repo to you local machine and then `cd` into the local repo
#### 2. Create an Alexa Skill
If you do not have an account create an Amazon Developer Account [here](https://developer.amazon.com/)  
Once you have created an account go to your developer console [here](https://developer.amazon.com/alexa/console/ask) and click on the `Create Skill` button  
Provide a skill name and then choose the __Custom__ model and hit the `Create Skill` button  
Next when choosing a template hit the __Start from Scratch__ template then hit the `Choose` button  
Now you need to provide an invocation name, this is how you will call you app from Alexa. For example, I would say Hey Alexa, ask test ...   
Now let's add a custom slot type:  
- On the left menu select `Slot Types` and hit the `Add` button
- Name your custom slot type `BAG_OF_WORDS` and hit the `Create custom slot type` button
- Lastly input `Hello World` as the slot value and click the `+` button
Next we will add a custom intent type
- On the left menu select `Intents` and hit the `Add` button
- Use the name `EveryThingIntent` and hit the `Create custom intent` button
- Add `{EveryThingSlot}` to the Sample Utterances then hit the `+` button to create
- Lastly select `Intent Slots` and then click `Select a slot type` to give your `EveryThingSlot` the type `BAG_OF_WORDS`
